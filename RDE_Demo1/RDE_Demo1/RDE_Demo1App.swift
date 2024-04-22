// RDE_Demo1App.swift

import SwiftUI

@main
struct RDE_Demo1App: App {
    var body: some Scene {
        WindowGroup {
            ModeSelectView()
        }
        .defaultSize(CGSize(width: 700, height: 450))

        WindowGroup(id: "textWindow") {
            TextWindowView()
        }
        .defaultSize(CGSize(width: 300, height: 100))
    }
}
