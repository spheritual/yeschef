import SwiftUI

/// Import a recipe from a photo or screenshot through `model.importRecipe(from:mimeType:)`.
/// Owned by the voice-chat worker; this is a stub.
struct ImportView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        Text("Import a recipe from a photo")
    }
}
