import AVFoundation
import Observation
import SwiftUI

/// Whether Basil is muted. Kept in memory only, since the demo saves nothing. `ChatView` has the switch.
@MainActor @Observable
final class BasilVoiceSettings {
    static let shared = BasilVoiceSettings()
    var muted = false
}

extension View {
    /// Speaks each new Basil message out loud, unless muted. Speech stops when a new question starts.
    func basilVoice() -> some View { modifier(BasilVoice()) }
}

private struct BasilVoice: ViewModifier {
    @Environment(AppModel.self) private var model
    private var settings = BasilVoiceSettings.shared
    @State private var speaker = AVSpeechSynthesizer()

    func body(content: Content) -> some View {
        content
            // Only changes are spoken, so the greeting (the subtitle) and old chats stay quiet at launch.
            .onChange(of: model.messages) { old, new in
                let fresh = new.dropFirst(old.count)
                if fresh.contains(where: { $0.speaker == .user }) { speaker.stopSpeaking(at: .immediate) }
                guard !settings.muted, let reply = fresh.last(where: { $0.speaker == .basil }) else { return }
                speak(reply.text)
            }
            .onChange(of: model.mood) { _, mood in
                if mood == .listening { speaker.stopSpeaking(at: .immediate) }
            }
            .onChange(of: settings.muted) { _, muted in
                if muted { speaker.stopSpeaking(at: .immediate) }
            }
    }

    private func speak(_ text: String) {
        let plain = text.filter { !"*#_`".contains($0) }
        let utterance = AVSpeechUtterance(string: plain)
        utterance.voice = AVSpeechSynthesisVoice(language: AVSpeechSynthesisVoice.currentLanguageCode())
        // The mic switches the session to recording, and speech needs it back on playback.
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .spokenAudio)
        try? session.setActive(true)
        speaker.stopSpeaking(at: .immediate)
        speaker.speak(utterance)
    }
}
