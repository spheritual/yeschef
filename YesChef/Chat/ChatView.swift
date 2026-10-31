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
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.top, 40)
                        }
                        ForEach(model.messages) { message in
                            Bubble(message: message)
                        }
                        if isThinking {
                            Bubble(message: ChatMessage(speaker: .basil, text: "…"), typing: true)
                        }
                        Color.clear.frame(height: 1).id(bottom)
                    }
                    .padding()
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: model.messages.count) { scroll(proxy) }
                .onChange(of: isThinking) { scroll(proxy) }
                .onAppear { proxy.scrollTo(bottom) }
            }
            .background(Palette.cream)
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

    private var composer: some View {
        HStack(spacing: 8) {
            TextField("Ask Basil…", text: $draft, axis: .vertical)
                .lineLimit(1...4)
                .focused($typing)
                .submitLabel(.send)
                .onSubmit(send)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(.white, in: .rect(cornerRadius: 20))
            Button("Send", systemImage: "arrow.up.circle.fill", action: send)
                .labelStyle(.iconOnly)
                .font(.largeTitle)
                .foregroundStyle(Palette.green)
                .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isThinking)
        }
        .padding()
        .background(.bar)
    }

    private func send() {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, !isThinking else { return }
        draft = ""
        Task { await model.ask(text) }
    }
}

private enum Palette {
    static let cream = Color(red: 0xf8 / 255, green: 0xf5 / 255, blue: 0xec / 255)
    static let ink = Color(red: 0x26 / 255, green: 0x3b / 255, blue: 0x2e / 255)
    static let green = Color(red: 0x38 / 255, green: 0x63 / 255, blue: 0x47 / 255)
}

private struct Bubble: View {
    let message: ChatMessage
    var typing = false

    private var isUser: Bool { message.speaker == .user }

    var body: some View {
        HStack {
            if isUser { Spacer(minLength: 48) }
            Group {
                if typing { ProgressView().padding(.vertical, 2) } else { Text(message.text) }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .foregroundStyle(isUser ? Color.white : Palette.ink)
            .background(isUser ? Palette.green : Color.white, in: .rect(cornerRadius: 18))
            .accessibilityLabel(typing ? "Basil is thinking" : "\(isUser ? "You" : "Basil"): \(message.text)")
            if !isUser { Spacer(minLength: 48) }
        }
    }
}

#Preview {
    ChatView()
        .environment(AppModel(apiKey: nil))
}
