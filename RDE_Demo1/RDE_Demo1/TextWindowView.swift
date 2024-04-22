// TextWindowView.swift

import SwiftUI

struct TextWindowView: View {
    @State private var noteText = ""
    var body: some View {
        VStack {
            TextField("enter note", text: $noteText)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    TextWindowView()
}
