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
            if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                content.add(scene)
                let floor = ModelEntity(mesh: .generatePlane(width: 1000, depth: 1000), materials: [OcclusionMaterial()])
                floor.generateCollisionShapes(recursive: false)
                floor.components[PhysicsBodyComponent.self] = .init(
                    massProperties: .default,
                    mode: .static
                )
                content.add(floor)
                
                
            }
            
        }
        .gesture(dragGesture)
      //  .gesture(tapGesture)
    }

    var dragGesture: some Gesture {
      DragGesture()
        .targetedToAnyEntity()
        .onChanged { value in
          value.entity.position = value.convert(value.location3D, from: .local, to: value.entity.parent!)
          value.entity.components[PhysicsBodyComponent.self]?.mode = .kinematic
        }
        .onEnded { value in
            value.entity.components[PhysicsBodyComponent.self]?.mode = .dynamic
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
