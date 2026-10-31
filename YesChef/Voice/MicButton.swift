import AVFoundation
import Speech
import SwiftUI

/// The mic in the subtitle bar: listens, then sends the words to `model.ask(_:)`.
/// Tap to start; tap again or pause to stop. If listening isn't possible it opens the chat to type.
struct MicButton: View {
    @Environment(AppModel.self) private var model
    @State private var listener = Listener()
    @State private var showChat = false

    var body: some View {
        Button {
            if listener.isListening {
                listener.stop()
            } else {
                Task { await listen() }
            }
        } label: {
            Label(listener.isListening ? "Stop listening" : "Talk to Basil",
                  systemImage: listener.isListening ? "mic.fill" : "mic")
                .labelStyle(.iconOnly)
                .font(.title2)
                .foregroundStyle(listener.isListening ? Color.red : Color.primary)
                .frame(minWidth: 44, minHeight: 44)
        }
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
            model.mood = resting.0
            model.subtitle = resting.1
            showChat = true
            return
        }
        spoken = spoken.trimmingCharacters(in: .whitespacesAndNewlines)
        if spoken.isEmpty {
            model.mood = resting.0
            model.subtitle = resting.1
        } else {
            await model.ask(spoken)
        }
    }
}

/// Speech recognition on top of `AVAudioEngine`, with permission asked on first use.
@MainActor @Observable
private final class Listener {
    struct Unavailable: Error {}

    private(set) var isListening = false
    private let engine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private var pause: Task<Void, Never>?
    private var output: AsyncThrowingStream<String, Error>.Continuation?

    /// Starts listening and streams the partial transcript. The stream ends when listening stops.
    func start() async throws -> AsyncThrowingStream<String, Error> {
        guard await Self.authorized(),
              let recognizer = SFSpeechRecognizer(locale: .current), recognizer.isAvailable
        else { throw Unavailable() }

        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record, mode: .measurement, options: .duckOthers)
        try session.setActive(true)

        let format = engine.inputNode.outputFormat(forBus: 0)
        guard format.sampleRate > 0, format.channelCount > 0 else { throw Unavailable() }  // no mic

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        request.requiresOnDeviceRecognition = recognizer.supportsOnDeviceRecognition
        Self.tap(engine.inputNode, format: format, into: request)
        engine.prepare()
        try engine.start()

        let (stream, continuation) = AsyncThrowingStream<String, Error>.makeStream()
        output = continuation
        self.request = request
        isListening = true
        task = Self.recognize(recognizer, request) { [weak self] text, isFinal in
            guard let self else { return }
            if let text {
                continuation.yield(text)
                if !isFinal { self.restartPauseTimer() }
            }
            if isFinal { self.stop() }
        }
        restartPauseTimer()
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
        output?.finish()
        output = nil
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }

    /// A pause in speech ends the question.
    private func restartPauseTimer() {
        pause?.cancel()
        pause = Task { [weak self] in
            try? await Task.sleep(for: .seconds(1.6))
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
        handler: @escaping @MainActor (String?, Bool) -> Void
    ) -> SFSpeechRecognitionTask {
        recognizer.recognitionTask(with: request) { result, error in
            let text = result?.bestTranscription.formattedString
            let isFinal = (result?.isFinal ?? false) || error != nil
            Task { @MainActor in handler(text, isFinal) }
        }
    }
}
