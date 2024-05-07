import SwiftUI
import ARKit

@main
struct MyApp: App {
    @State private var immersionStyle: ImmersionStyle = .mixed
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .defaultSize(width: 300, height: 300)
        ImmersiveSpace(id: "ImmersiveSpace") {
            ModeSelectView()
        }
        .windowResizability(.contentSize)
    }
}
