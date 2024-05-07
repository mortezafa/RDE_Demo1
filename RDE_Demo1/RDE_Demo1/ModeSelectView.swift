import ARKit
import SwiftUI
import RealityKit

struct ModeSelectView: View {

    @State private var imageTrackingProvider:ImageTrackingProvider?
    @State private var entityMap: [UUID: Entity] = [:]
    @State private var contentEntity: Entity?
    private let session = ARKitSession()
    @State private var noteText = ""
    @State private var noteVisible = false



    var body: some View {

        Button("Add Note") {
            noteVisible.toggle()
        }
        .padding()
        .background(noteVisible ? Color.green : Color.gray)
        .foregroundColor(.white)
        .clipShape(Capsule())
        .padding(.bottom, 500)
        Spacer()


        RealityView { content, attachments in
            let mesh = MeshResource.generatePlane(width: 0.1524, height: 0.2032)
            let color = UIColor.clear
            let material = SimpleMaterial(color: color, isMetallic: false)
            contentEntity = ModelEntity(mesh: mesh, materials: [material])
            content.add(contentEntity!)

            if let note = attachments.entity(for: "NoteTitle") {
                note.position = [0, -0.15, 0.05]
                contentEntity!.addChild(note)

            }

        } attachments: {
            Attachment(id: "NoteTitle") {
                if noteVisible {
                    VStack {
                        TextEditor(text: $noteText)
                            .padding()
                    }.frame(width: 200, height: 100)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }
        }.task {
            await loadImage()
            await runSession()
            await processImageTrackingUpdates()
        }



    }

    func loadImage() async {
        let uiImage = UIImage(named: "bookImage")
        let cgImage = uiImage?.cgImage
        let referenceImage = ReferenceImage(cgimage: cgImage!, physicalSize: CGSize(width: 1920, height: 1005))
        imageTrackingProvider = ImageTrackingProvider(
            referenceImages: [referenceImage]
        )
    }

    func runSession() async {
        do {
            if ImageTrackingProvider.isSupported {
                try await session.run([imageTrackingProvider!])
                print("image tracking initializing in progress.")
            } else {
                print("image tracking is not supported.")
            }
        } catch {
            print("Error during initialization of image tracking. [\(type(of: self))] [\(#function)] \(error)")
        }
    }

    func processImageTrackingUpdates() async {
        for await update in imageTrackingProvider!.anchorUpdates {
            updateImage(update.anchor)
        }
    }

    private func updateImage(_ anchor: ImageAnchor) {
        if entityMap[anchor.id] == nil {
            entityMap[anchor.id] = contentEntity
        }
        if anchor.isTracked {
            DispatchQueue.main.async {
                contentEntity!.isEnabled = true
            }
            let transform = Transform(matrix: anchor.originFromAnchorTransform)
            let initialRotation = simd_quatf(angle: .pi / 2, axis: [0, 1, 0])

            entityMap[anchor.id]?.transform.translation = transform.translation
            entityMap[anchor.id]?.transform.rotation = initialRotation
        } else {
            contentEntity!.isEnabled = false
        }
    }
}

#Preview {
    ModeSelectView()
}

