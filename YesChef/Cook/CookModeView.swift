import SwiftUI
import YesChefCore

/// Step-by-step cooking for `model.recipe`. Owned by the cook-mode worker; this is a stub.
struct CookModeView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        Text(model.recipe?.title ?? "Pick a recipe first")
    }
}
