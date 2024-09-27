//
//  SolarSystem.swift
//  Capstone
//
//  Created by Ernesto González on 25/9/24.
//

import Foundation

enum SolarSystem: String, CaseIterable {
    case sun = "Sun"
    case mercury = "Mercury"
    case venus = "Venus"
    case earth = "Earth"
    case mars = "Mars"
    case jupiter = "Jupiter"
    case saturn = "Saturn"
    case uranus = "Uranus"
    case neptune = "Neptune"

    var position: SIMD3<Float> {
        switch self {
        case .sun:
            [0, 1, 0]
        case .mercury:
            [1, 1, 0]
        case .venus:
            [2, 1, 0]
        case .earth:
            [3, 1, 0]
        case .mars:
            [4, 1, 0]
        case .jupiter:
            [6, 1, 0]
        case .saturn:
            [8, 1, 0]
        case .uranus:
            [10, 1, -0]
        case .neptune:
            [12, 1, 0]
        }
    }

    var scale: SIMD3<Float> {
        switch self {
        case .sun:
            [8, 8, 8]
        case .mercury:
            [1, 1, 1]
        case .venus:
            [2.5, 2.5, 2.5]
        case .earth:
            [3, 3, 3]
        case .mars:
            [2, 2, 2]
        case .jupiter:
            [6, 6, 6]
        case .saturn:
            [5.5, 5.5, 5.5]
        case .uranus:
            [4.5, 4.5, 4.5]
        case .neptune:
            [4, 4, 4]
        }
    }

    var duration: Double {
        switch self {
        case .sun: 20
        case .mercury: 5.4
        case .venus: 6.8
        case .earth: 9.7
        case .mars: 13.1
        case .jupiter: 24.1
        case .saturn: 29.8
        case .uranus: 35.0
        case .neptune: 47.9
        }
    }

    var accessibilityLabel: String {
        switch self {
        case .sun:
            "Sun"
        default:
            "Planet \(self.rawValue)"
        }
    }
}
