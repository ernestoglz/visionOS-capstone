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

    var body: some View {
        RealityView { content in
            await loadEntities(content: &content)
        } update: { content in
            var distanceFromOrigin: Float = 0
            content.entities.forEach { entity in
                let planet = SolarSystem(rawValue: entity.name.capitalized)
                applyOrbitAnimation(
                    to: entity,
                    distanceFromOrigin: distanceFromOrigin,
                    position: planet?.position, 
                    scale: planet?.scale,
                    duration: planet?.duration ?? 0.0,
                    content: content
                )
                distanceFromOrigin += 0.1
            }
        }
    }

    private func loadEntities(content: inout RealityViewContent) async {
        for planet in SolarSystem.allCases {
            if let scene = try? await Entity(named: planet.rawValue, in: realityKitContentBundle) {
                content.add(scene)
                await applySkyBox(scene: scene)
            }
        }
    }

    private func applyOrbitAnimation(to entity: Entity, distanceFromOrigin: Float, position: SIMD3<Float>?, scale: SIMD3<Float>?,duration: Double, content: RealityViewContent) {
        entity.scale = scale ?? [0, 0, 0]
        entity.position = position ?? [0, 0, 0]
        let orbit = OrbitAnimation(
            duration: duration,
            axis: SIMD3<Float>(x: 0, y: 0.1, z: 0),
            startTransform: entity.transform,
            spinClockwise: false,
            orientToPath: true,
            rotationCount: 1.0,
            bindTarget: .transform,
            repeatMode: .repeat
        )


        if let animation = try? AnimationResource.generate(with: orbit) {
            entity.playAnimation(animation)
        }
    }

    private func applySkyBox(scene: Entity) async {
        guard let resource = try? await EnvironmentResource(named: "Sunlight") else { return }
        var iblComponent = ImageBasedLightComponent(source: .single(resource), intensityExponent: 3.0)
        iblComponent.inheritsRotation = true

        await scene.components.set(iblComponent)
        await scene.components.set(ImageBasedLightReceiverComponent(imageBasedLight: scene))
    }
}

#Preview {
    ImmersiveView()
}
