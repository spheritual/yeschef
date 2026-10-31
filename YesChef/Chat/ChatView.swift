import SwiftUI

/// The full text conversation with Basil, opened from the chat bubble.
/// Owned by the voice worker; this is a stub.
struct ChatView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        List(model.messages) { message in
            Text(message.text)
        }
    }
}
