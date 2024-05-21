import SwiftUI
import ARKit

@main
struct MyApp: App {
    @State var IdeViewmodel = IdeViewModel()

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .defaultSize(width: 300, height: 300)
        ImmersiveSpace(id: "ImmersiveSpace") {
            ModeSelectView(IdeViewmodel: IdeViewmodel)
        }
        .windowResizability(.contentSize)

        WindowGroup(id: "ControlPanel") {
            IdeView(IdeViewmodel: IdeViewmodel)
        }
        .windowResizability(.contentSize)

    }
}
