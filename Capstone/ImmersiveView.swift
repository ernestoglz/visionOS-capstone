//
//  ImmersiveView.swift
//  Capstone
//
//  Created by Ernesto González on 23/9/24.
//

import SwiftUI
import Combine
import RealityKit
import RealityKitContent

struct ImmersiveView: View {

    private var cancellable: Set<AnyCancellable> = []
    @State private var loadedEntity: Entity?

    var body: some View {
        RealityView { content in
            let floor = ModelEntity(mesh: .generatePlane(width: 1000, depth: 1000), materials: [OcclusionMaterial()])
            floor.generateCollisionShapes(recursive: false)
            floor.components[PhysicsBodyComponent.self] = .init(
                massProperties: .default,
                mode: .static
            )
            content.add(floor)

            do {
                let entity = try await Entity(named: "ModernChair")
                loadedEntity = entity

                loadedEntity?.position = [0, 0, -2]
                loadedEntity?.generateCollisionShapes(recursive: false)

                // Enable interactions on the entity.
                loadedEntity?.components.set(InputTargetComponent())
                loadedEntity?.components.set(CollisionComponent(shapes: [.generateBox(width: 20, height: 20, depth: 20)]))
                loadedEntity?.components[PhysicsBodyComponent.self]?.isAffectedByGravity = true

                guard let loadedEntity else { return }
                content.add(loadedEntity)
            } catch {
                debugPrint(error)

            }
        }
        .gesture(dragGesture)
        .gesture(tapGesture)
    }

    var dragGesture: some Gesture {
      DragGesture()
        .targetedToAnyEntity()
        .onChanged { value in
          value.entity.position = value.convert(value.location3D, from: .local, to: value.entity.parent!)
          value.entity.components[PhysicsBodyComponent.self]?.mode = .kinematic
        }
    }

    var tapGesture: some Gesture {
      TapGesture()
        .targetedToAnyEntity()
        .onEnded { value in
          // do nothing
          value.entity.components[PhysicsBodyComponent.self]?.mode = .dynamic
          value.entity.components[PhysicsMotionComponent.self]?.linearVelocity = [0, 7,-5]
        }
    }
}

#Preview {
    ImmersiveView()
}
