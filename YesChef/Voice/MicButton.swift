import AVFoundation
import Speech
import SwiftUI

/// The mic in the subtitle bar: listens, then sends the words to `model.ask(_:)`.
/// Tap to start; tap again or pause to stop. If listening isn't possible it says so and opens the chat to type.
struct MicButton: View {
    @Environment(AppModel.self) private var model
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var listener = Listener()
    @State private var showChat = false

    private var busy: Bool { model.mood == .cooking && !listener.isListening }

    var body: some View {
        Button {
            if listener.isListening {
                listener.stop()
            } else if !listener.isStarting {
                Task { await listen() }
            }
        } label: {
            ZStack {
                if listener.isListening { PulseRing(animated: !reduceMotion) }
                Circle()
                    .fill(listener.isListening ? Theme.green : Color.clear)
                Image(systemName: listener.isListening ? "mic.fill" : "mic")
                    .font(.title3)
                    .foregroundStyle(listener.isListening ? Theme.onGreen : Theme.ink)
            }
            .frame(width: 44, height: 44)
            .contentShape(.circle)
            .animation(.easeOut(duration: 0.15), value: listener.isListening)
        }
        .buttonStyle(MicPressStyle())
        .disabled(busy)
        .accessibilityLabel(listener.isListening ? "Stop listening" : "Talk to Basil")
        .sheet(isPresented: $showChat) { ChatView() }
    }

    private func listen() async {
        let resting = (model.mood, model.subtitle)
        var spoken = ""
        do {
            model.mood = .listening
            model.subtitle = "Listening…"
            for try await text in try await listener.start() {
                spoken = text
                model.subtitle = text
            }
        } catch {
            // Saying why is the only way to tell a permission, a missing mic and a speech service
            // error apart in the simulator. The chat bubble still takes typed questions.
            print("[MicButton] \(error.localizedDescription)")
            model.mood = resting.0 == .listening ? .idle : resting.0
            model.subtitle = "I can't hear you. \(error.localizedDescription)"
            return
        }
        spoken = spoken.trimmingCharacters(in: .whitespacesAndNewlines)
        if spoken.isEmpty {
            model.mood = resting.0 == .listening ? .idle : resting.0
            model.subtitle = resting.0 == .listening ? "I didn't catch that. Tap the mic to try again." : resting.1
        } else {
            await model.ask(spoken)
        }
    }
}

/// A ring that grows and fades while listening. Still when Reduce Motion is on.
private struct PulseRing: View {
    let animated: Bool
    @State private var grown = false

    var body: some View {
        Circle()
            .stroke(Theme.green, lineWidth: 2)
            .scaleEffect(animated && grown ? 1.5 : 1)
            .opacity(animated ? (grown ? 0 : 0.5) : 0.35)
            .onAppear {
                guard animated else { return }
                withAnimation(.easeOut(duration: 1.2).repeatForever(autoreverses: false)) { grown = true }
            }
            .accessibilityHidden(true)
    }
}

private struct MicPressStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        let pressed = configuration.isPressed && isEnabled
        configuration.label
            .scaleEffect(pressed && !reduceMotion ? 0.96 : 1)
            .opacity(isEnabled ? 1 : 0.4)
            .animation(.easeOut(duration: 0.15), value: pressed)
    }
}

/// Speech recognition on top of `AVAudioEngine`, with permission asked on first use.
@MainActor @Observable
private final class Listener {
    struct Unavailable: LocalizedError {
        let reason: String
        var errorDescription: String? { reason }
    }

    private(set) var isListening = false
    private(set) var isStarting = false
    private var heard = false
    private let engine = AVAudioEngine()
    // Kept for the whole session, since a local one was released as soon as start() returned.
    private var recognizer: SFSpeechRecognizer?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var pause: Task<Void, Never>?
    private var output: AsyncThrowingStream<String, Error>.Continuation?

    /// Starts listening and streams the partial transcript. The stream ends when listening stops.
    func start() async throws -> AsyncThrowingStream<String, Error> {
        isStarting = true
        defer { isStarting = false }
        guard await Self.authorized() else {
            throw Unavailable(reason: "Speech recognition or the microphone isn't allowed. Turn both on for YesChef in Settings.")
        }
        guard let recognizer = SFSpeechRecognizer(locale: .current), recognizer.isAvailable else {
            throw Unavailable(reason: "Speech recognition isn't available for \(Locale.current.identifier) right now.")
        }

        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record, mode: .measurement, options: .duckOthers)
        try session.setActive(true)

        let format = engine.inputNode.outputFormat(forBus: 0)
        guard format.sampleRate > 0, format.channelCount > 0 else {  // no mic
            try? session.setActive(false)
            throw Unavailable(reason: "There's no microphone input. In the Simulator, pick a mic under I/O, then Audio Input, and allow the Simulator to use the microphone in the Mac's Privacy settings.")
        }

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        // On-device only fails at once when the speech model isn't downloaded, which is common in
        // the simulator and closed the mic before anyone spoke; letting it use Apple's server works.
        request.requiresOnDeviceRecognition = false
        Self.tap(engine.inputNode, format: format, into: request)
        engine.prepare()
        do {
            try engine.start()
        } catch {
            engine.inputNode.removeTap(onBus: 0)
            try? session.setActive(false)
            throw error
        }

        let (stream, continuation) = AsyncThrowingStream<String, Error>.makeStream()
        output = continuation
        self.request = request
        self.recognizer = recognizer
        isListening = true
        heard = false
        task = Self.recognize(recognizer, request) { [weak self] text, isFinal, problem in
            // A late callback from an earlier session must not touch the current one.
            guard let self, self.request === request else { return }
            if let text {
                self.heard = true
                continuation.yield(text)
                // 2 s after the last word ends the question.
                if !isFinal { self.restartPauseTimer(after: 2) }
            } else if let problem, !self.heard {
                continuation.finish(throwing: Unavailable(reason: "Speech recognition stopped: \(problem)"))
            }
            if isFinal { self.stop() }
        }
        // Waiting for the first word gets longer than the pause that ends a question.
        restartPauseTimer(after: 8)
        return stream
    }

    func stop() {
        guard isListening else { return }
        isListening = false
        pause?.cancel()
        engine.stop()
        engine.inputNode.removeTap(onBus: 0)
        request?.endAudio()
        task?.cancel()
        request = nil
        task = nil
        recognizer = nil
        output?.finish()
        output = nil
        let session = AVAudioSession.sharedInstance()
        try? session.setActive(false, options: .notifyOthersOnDeactivation)
        // A record-only session would leave Basil's spoken answer silent.
        try? session.setCategory(.playback, mode: .spokenAudio)
    }

    /// A pause in speech ends the question.
    private func restartPauseTimer(after seconds: Double) {
        pause?.cancel()
        pause = Task { [weak self] in
            try? await Task.sleep(for: .seconds(seconds))
            if !Task.isCancelled { self?.stop() }
        }
    }

    // These run on audio and speech threads, so they must not inherit main-actor isolation.

    private nonisolated static func authorized() async -> Bool {
        let speech = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { continuation.resume(returning: $0 == .authorized) }
        }
        guard speech else { return false }
        return await AVAudioApplication.requestRecordPermission()
    }

    private nonisolated static func tap(_ node: AVAudioInputNode, format: AVAudioFormat,
                                        into request: SFSpeechAudioBufferRecognitionRequest) {
        nonisolated(unsafe) let request = request
        node.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            request.append(buffer)
        }
    }

    private nonisolated static func recognize(
        _ recognizer: SFSpeechRecognizer, _ request: SFSpeechAudioBufferRecognitionRequest,
        handler: @escaping @MainActor (String?, Bool, String?) -> Void
    ) -> SFSpeechRecognitionTask {
        recognizer.recognitionTask(with: request) { result, error in
            let text = result?.bestTranscription.formattedString
            // Only the message crosses to the main actor, since Error isn't Sendable.
            let problem = error?.localizedDescription
            let isFinal = (result?.isFinal ?? false) || problem != nil
            Task { @MainActor in handler(text, isFinal, problem) }
        }
    }
}
