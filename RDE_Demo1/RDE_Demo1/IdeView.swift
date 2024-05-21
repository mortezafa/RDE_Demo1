// ControlPanelView.swift

import SwiftUI

struct IdeView: View {
    @State var IdeViewmodel = IdeViewModel()

    var body: some View {
        VStack {
            ZStack {
                TextEditor(text: $IdeViewmodel.cssText)
                    .padding()
                    .font(.system(size: 15, design: .monospaced))
            }

            Button(action: {
                IdeViewmodel.sendCSS()
                print(IdeViewmodel.jsonResult )
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
