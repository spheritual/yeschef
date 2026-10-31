import SwiftUI

@main
struct YesChefApp: App {
    @State private var model = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(model)
                #if DEBUG
                .task { await DemoScript.run(model) }
                #endif
        }
    }
}
