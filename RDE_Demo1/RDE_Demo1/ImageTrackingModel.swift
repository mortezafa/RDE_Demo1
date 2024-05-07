import Foundation
import ARKit
import RealityKit
import RealityKitContent
import Observation

@Observable class ImageTrackingModel {

    let session = ARKitSession() // ARSession used to manage AR content
    var imageAnchors = [UUID: Bool]() // Tracks whether specific anchors have been processed
    var entityMap = [UUID: ModelEntity]() // Maps anchors to their corresponding ModelEntity
    var rootEntity = ModelEntity() // Root entity to which all other entities are added
    let imageInfo = ImageTrackingProvider(
        referenceImages: ReferenceImage.loadReferenceImages(inGroupNamed: "referancePaper")
    )

    func setupImageTracking() {
        if ImageTrackingProvider.isSupported {
            Task {
                try await session.run([imageInfo])
                for await update in imageInfo.anchorUpdates {
                    updateImage(update.anchor)
                }
            }
        }
    }

    func updateImage(_ anchor: ImageAnchor) {

        if imageAnchors[anchor.id] == nil {
                // Add a new entity to represent this image.
                let entity = ModelEntity(mesh: .generateSphere(radius: 0.05))
                entityMap[anchor.id] = entity
                rootEntity.addChild(entity)
            }

            if anchor.isTracked {
                entityMap[anchor.id]?.transform = Transform(matrix: anchor.originFromAnchorTransform)
            }
    }
}
