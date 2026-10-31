import AVFoundation
import SwiftUI

/// The `@AppStorage` key for the mute toggle. `ChatView` has the switch.
let basilMutedKey = "basilMuted"

extension View {
    /// Speaks each new Basil message out loud, unless muted. Speech stops when a new question starts.
    func basilVoice() -> some View { modifier(BasilVoice()) }
}

private struct BasilVoice: ViewModifier {
    @Environment(AppModel.self) private var model
    @AppStorage(basilMutedKey) private var muted = false
    @State private var speaker = AVSpeechSynthesizer()

    func body(content: Content) -> some View {
        content
            // Only changes are spoken, so the greeting (the subtitle) and old chats stay quiet at launch.
            .onChange(of: model.messages) { old, new in
                let fresh = new.dropFirst(old.count)
                if fresh.contains(where: { $0.speaker == .user }) { speaker.stopSpeaking(at: .immediate) }
                guard !muted, let reply = fresh.last(where: { $0.speaker == .basil }) else { return }
                speak(reply.text)
            }
            .onChange(of: model.mood) { _, mood in
                if mood == .listening { speaker.stopSpeaking(at: .immediate) }
            }
            .onChange(of: muted) { _, muted in
                if muted { speaker.stopSpeaking(at: .immediate) }
            }
    }

    private func speak(_ text: String) {
        let plain = text.filter { !"*#_`".contains($0) }
        let utterance = AVSpeechUtterance(string: plain)
        utterance.voice = AVSpeechSynthesisVoice(language: AVSpeechSynthesisVoice.currentLanguageCode())
        speaker.stopSpeaking(at: .immediate)
        speaker.speak(utterance)
    }
}
