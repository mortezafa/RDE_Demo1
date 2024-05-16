import SwiftUI
import ARKit

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .defaultSize(width: 300, height: 300)
        ImmersiveSpace(id: "ImmersiveSpace") {
            ModeSelectView()
        }
        .windowResizability(.contentSize)

        WindowGroup(id: "ControlPanel") {
            IdeView()
        }
        .windowResizability(.contentSize)

    }
}
