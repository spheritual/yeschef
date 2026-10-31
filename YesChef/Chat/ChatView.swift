import SwiftUI

/// The full text conversation with Basil, opened from the chat bubble.
struct ChatView: View {
    @Environment(AppModel.self) private var model
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    private var voice = BasilVoiceSettings.shared
    @State private var draft = ""
    @FocusState private var typing: Bool

    private var isThinking: Bool { model.mood == .cooking }

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        if model.messages.isEmpty {
                            Text("Ask Basil anything about your week or what's on the stove.")
                                .font(.subheadline)
                                .foregroundStyle(Theme.muted)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                                .padding(.top, 48)
                        }
                        ForEach(model.messages) { message in
                            Bubble(message: message)
                        }
                        if isThinking {
                            Bubble(message: ChatMessage(speaker: .basil, text: "…"), typing: true)
                        }
                        if model.mood == .confused {
                            VStack(spacing: 8) {
                                Text("Hmm, that didn't work.")
                                    .font(.footnote)
                                    .foregroundStyle(Theme.muted)
                                Button("Try again") { Task { await model.retry() } }
                                    .buttonStyle(PillButtonStyle())
                            }
                            .padding(.top, 8)
                        }
                        Color.clear.frame(height: 1).id(bottom)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: model.messages.count) { scroll(proxy) }
                .onChange(of: isThinking) { scroll(proxy) }
                .onChange(of: model.mood) { scroll(proxy) }
                .onAppear { proxy.scrollTo(bottom) }
            }
            .background(Theme.cream)
            .safeAreaInset(edge: .bottom) { composer }
            .navigationTitle("Basil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(voice.muted ? "Unmute Basil" : "Mute Basil", systemImage: voice.muted ? "speaker.slash" : "speaker.wave.2") {
                        voice.muted.toggle()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private let bottom = "bottom"

    private func scroll(_ proxy: ScrollViewProxy) {
        withAnimation(reduceMotion ? nil : .easeOut) { proxy.scrollTo(bottom) }
    }

    private var canSend: Bool {
        !draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isThinking
    }

    /// The field and send button share one pill: 22pt outer radius = 16pt button radius + 6pt inset.
    private var composer: some View {
        HStack(alignment: .bottom, spacing: 0) {
            TextField("Ask Basil…", text: $draft, axis: .vertical)
                .lineLimit(1...4)
                .focused($typing)
                .submitLabel(.send)
                .onSubmit(send)
                .padding(.leading, 16)
                .padding(.vertical, 12)
            Button(action: send) {
                Image(systemName: "arrow.up")
                    .font(.footnote.weight(.bold))
                    .foregroundStyle(Theme.onGreen)
                    .frame(width: 32, height: 32)
                    .background(Theme.green, in: .circle)
                    .opacity(canSend ? 1 : 0.35)
                    .frame(width: 44, height: 44)
                    .contentShape(.rect)
            }
            .buttonStyle(SendPressStyle())
            .disabled(!canSend)
            .accessibilityLabel("Send")
        }
        .background(Theme.card, in: .rect(cornerRadius: 22, style: .continuous))
        .overlay { RoundedRectangle(cornerRadius: 22, style: .continuous).strokeBorder(Theme.hairline, lineWidth: 1) }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Theme.cream)
    }

    private func send() {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, !isThinking else { return }
        draft = ""
        Task { await model.ask(text) }
    }
}

private struct SendPressStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        let pressed = configuration.isPressed && isEnabled
        configuration.label
            .scaleEffect(pressed && !reduceMotion ? 0.96 : 1)
            .animation(.easeOut(duration: 0.15), value: pressed)
    }
}

private struct Bubble: View {
    let message: ChatMessage
    var typing = false

    private var isUser: Bool { message.speaker == .user }

    var body: some View {
        HStack {
            if isUser { Spacer(minLength: 56) }
            Group {
                if typing { ProgressView().padding(.vertical, 2) } else { Text(message.text) }
            }
            .font(.body)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .foregroundStyle(isUser ? Theme.onGreen : Theme.ink)
            .background(isUser ? Theme.green : Theme.card, in: shape)
            .overlay { if !isUser { shape.strokeBorder(Theme.hairline, lineWidth: 1) } }
            .accessibilityLabel(typing ? "Basil is thinking" : "\(isUser ? "You" : "Basil"): \(message.text)")
            if !isUser { Spacer(minLength: 56) }
        }
    }

    private var shape: RoundedRectangle { RoundedRectangle(cornerRadius: 20, style: .continuous) }
}

#Preview {
    ChatView()
        .environment(AppModel(apiKey: nil))
}
