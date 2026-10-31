import PhotosUI
import SwiftUI

/// Import a recipe from a photo or screenshot through `model.importRecipe(from:mimeType:)`.
/// Shown as a sheet; it dismisses itself once the recipe is in.
struct ImportView: View {
    @Environment(AppModel.self) private var model
    @Environment(\.dismiss) private var dismiss
    @State private var picked: PhotosPickerItem?
    @State private var unreadable = false

    private var isWorking: Bool { model.mood == .cooking }
    private var failed: Bool { model.mood == .confused || unreadable }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 28, weight: .regular))
                    .foregroundStyle(Theme.green)
                    .frame(width: 64, height: 64)
                    .background(Theme.stage, in: .circle)
                    .accessibilityHidden(true)
                    .padding(.bottom, 8)
                Text("Import a recipe")
                    .font(.heading(.title3))
                    .foregroundStyle(Theme.ink)
                if isWorking {
                    ProgressView()
                    Text(model.subtitle)
                        .foregroundStyle(Theme.muted)
                } else if failed {
                    Text(unreadable ? "I couldn't open that photo. Try another." : model.subtitle)
                        .foregroundStyle(Theme.muted)
                    if !unreadable {
                        Button("Try again") { Task { await retry() } }
                            .buttonStyle(PillButtonStyle())
                    }
                } else {
                    Text("Pick a photo or screenshot of a recipe and Basil will read it.")
                        .foregroundStyle(Theme.muted)
                }
                if !isWorking {
                    let label = PickerLabel(failed: failed)
                    PhotosPicker(selection: $picked, matching: .images) { label }
                }
            }
            .font(.subheadline)
            .multilineTextAlignment(.center)
            .padding(32)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.cream)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(isWorking ? "Cancel" : "Done") { dismiss() }
                }
            }
            .onChange(of: picked) { _, item in
                guard let item else { return }
                picked = nil
                Task { await load(item) }
            }
        }
    }

    private func load(_ item: PhotosPickerItem) async {
        unreadable = false
        guard let data = try? await item.loadTransferable(type: Data.self),
              let (image, mimeType) = Self.encode(data, isPNG: item.supportedContentTypes.contains { $0.conforms(to: .png) })
        else { unreadable = true; return }
        await model.importRecipe(from: image, mimeType: mimeType)
        finishIfDone()
    }

    private func retry() async {
        await model.retry()
        finishIfDone()
    }

    private func finishIfDone() {
        if model.mood != .confused { dismiss() }
    }

    /// Sends PNGs as they are and everything else (HEIC from the camera, say) as JPEG.
    private static func encode(_ data: Data, isPNG: Bool) -> (Data, String)? {
        if isPNG { return (data, "image/png") }
        guard let jpeg = UIImage(data: data)?.jpegData(compressionQuality: 0.85) else { return nil }
        return (jpeg, "image/jpeg")
    }
}

/// What the picker looks like: a green pill, or a light one when offering a second try.
private struct PickerLabel: View {
    let failed: Bool

    var body: some View {
        Label(failed ? "Choose another" : "Choose a photo", systemImage: "photo")
            .font(.footnote.weight(.semibold))
            .foregroundStyle(failed ? Theme.green : Theme.onGreen)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(failed ? Theme.card : Theme.green, in: .capsule)
            .overlay { if failed { Capsule().strokeBorder(Theme.hairline, lineWidth: 1) } }
    }
}

#Preview {
    ImportView()
        .environment(AppModel(apiKey: nil))
}
