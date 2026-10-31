import SwiftUI
import YesChefCore

/// Placeholder until the main screen from Figma frame 9:2 replaces it.
struct ContentView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("yeschef!")
                .font(.largeTitle.bold())
            Text("Basil is getting the kitchen ready.")
                .foregroundStyle(.secondary)
            Text(AppSecrets.geminiAPIKey == nil ? "No Gemini key" : "Gemini key found")
                .font(.footnote)
            Text("Learning model: \(FeatureEncoder.dimension) features")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
