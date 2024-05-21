import ARKit
import SwiftUI
import RealityKit

struct ModeSelectView: View {

    @State private var imageTrackingProvider:ImageTrackingProvider?
    @State private var entityMap: [UUID: Entity] = [:]
    @State private var contentEntity: ModelEntity?
    private let session = ARKitSession()
    @State private var noteText = ""
//    @State private var noteVisible = false
    @State var IdeViewmodel: IdeViewModel
    @State var color: UIColor = .brown



    var body: some View {
        RealityView { content, attachments in
            let mesh = MeshResource.generatePlane(width: 0.15748, height: 0.2286)
            let material = SimpleMaterial(color: color, isMetallic: false)
            contentEntity = ModelEntity(mesh: mesh, materials: [material])
            content.add(contentEntity!)

            if let note = attachments.entity(for: "NoteTitle") {
                note.position = [0, -0.1, 0.03]
                contentEntity!.addChild(note)

            }

        } attachments: {
            Attachment(id: "NoteTitle") {
                if IdeViewmodel.addNoteToObject() {
                    ZStack {
                        TextEditor(text: $noteText)
                    }.frame(width: 250, height: 100)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }
        }.task {
            await loadImage()
            await runSession()
            await processImageTrackingUpdates()
        }
        .onChange(of: IdeViewmodel.shouldUpdate) {
            print("ON CHANGE IS GETTING CALLED")
            updateModelEntityColor()
            IdeViewmodel.shouldUpdate = false

        }
    }

    private func updateModelEntityColor() {
        guard let contentEntity = contentEntity else { return }
        let color = IdeViewmodel.getColor()?.withAlphaComponent(IdeViewmodel.addOpacity()) ?? UIColor.red.withAlphaComponent(0.2)
        if var material = contentEntity.model?.materials.first as? SimpleMaterial {
            material.color = .init(tint: color)
            contentEntity.model?.materials = [material]
            contentEntity.model?.materials.append(material)
        }
    }

    func loadImage() async {
        let uiImage = UIImage(named: "bigNate")
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
            let additionalRotation = simd_quatf(angle: .pi / 2, axis: [0, 1, 0])
            let initialRotation = simd_quatf(angle: (3 * .pi)/2, axis: [0, 1, 0])
            let combinedRotation = additionalRotation * initialRotation

            entityMap[anchor.id]?.transform.translation = transform.translation
            entityMap[anchor.id]?.transform.rotation = combinedRotation
        } else {
            contentEntity!.isEnabled = false
        }
    }
}


