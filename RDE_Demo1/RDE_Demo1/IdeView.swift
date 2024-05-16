// ControlPanelView.swift

import SwiftUI

struct IdeView: View {
    @State private var cssText: String = ""

    var body: some View {
        VStack {
            ZStack {
                TextEditor(text: $cssText)
                    .padding()
                    .font(.system(size: 15, design: .monospaced))
            }


            Button(action: {
                // Action to convert CSS to JSON
            }) {
                Text("Compile")
                    .buttonStyle(.borderedProminent)
            }
            .padding()
            .tint(.green)

        }
        .padding()
    }
}

#Preview {
    IdeView()
}
