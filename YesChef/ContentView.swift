import SwiftUI

/// The root view: the main screen from Figma frame 9:2.
struct ContentView: View {
    var body: some View {
        MainScreen()
    }
}

#Preview {
    ContentView()
        .environment(AppModel(apiKey: nil))
}
