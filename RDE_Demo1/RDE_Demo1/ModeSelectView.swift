// ContentView.swift

import SwiftUI
import RealityKit
import RealityKitContent

struct ModeSelectView: View {
    @Environment(\.openWindow) private var openWindow
    var body: some View {
        VStack {
            Button(action: {
                openWindow(id: "textWindow")
            }, label: {
                Image(systemName: "text.bubble")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .aspectRatio(1, contentMode: .fit)
            })
            .frame(width: 400, height: 400)

        }
        .padding()


    }
}

#Preview(windowStyle: .automatic) {
    ModeSelectView()
}
