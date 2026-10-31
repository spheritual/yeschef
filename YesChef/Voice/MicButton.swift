import SwiftUI

/// The mic in the subtitle bar: listens, then sends the words to `model.ask(_:)`.
/// Owned by the voice worker; this is a stub.
struct MicButton: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        Button("Talk to Basil", systemImage: "mic.fill") {}
            .labelStyle(.iconOnly)
    }
}
