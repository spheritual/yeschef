import SwiftUI
import YesChefCore

/// Basil's wardrobe: outfits bought with leaves the cook earns by planning, cooking, rating,
/// importing and asking (BR-18). The outfits and prices come from the Figma wardrobe screen.
struct WardrobeView: View {
    @Environment(AppModel.self) private var model
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("\(model.points.streak())-day streak")
                        Spacer()
                        Text("\(model.points.balance) leaves").fontWeight(.semibold)
                    }
                    .foregroundStyle(Theme.ink)
                    .listRowBackground(Theme.card)
                } footer: {
                    Text("Planning earns 10 leaves, cooking 25, rating 10, importing a recipe 15 and asking Basil 5.")
                }
                Section("Outfits") {
                    ForEach(PointsLog.outfits) { outfit in
                        Button {
                            model.dressBasil(in: outfit)
                        } label: {
                            HStack(spacing: 12) {
                                Image(outfit.id)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 48, height: 54)
                                    .accessibilityHidden(true)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(outfit.name).font(.headline).foregroundStyle(Theme.ink)
                                    Text(status(of: outfit)).font(.footnote).foregroundStyle(Theme.muted)
                                }
                            }
                        }
                        .listRowBackground(Theme.card)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.cream)
            .navigationTitle("Basil's wardrobe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { Button("Done") { dismiss() } }
        }
        .tint(Theme.green)
    }

    private func status(of outfit: PointsLog.Outfit) -> String {
        if model.points.wearing == outfit.id { return "Wearing now" }
        if model.points.owned.contains(outfit.id) { return "Owned, tap to wear" }
        return "\(outfit.cost) leaves"
    }
}

#Preview {
    WardrobeView()
        .environment(AppModel(apiKey: nil))
}
