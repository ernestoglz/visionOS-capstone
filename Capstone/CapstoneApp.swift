//
//  CapstoneApp.swift
//  Capstone
//
//  Created by Ernesto González on 23/9/24.
//

import SwiftUI

@main
struct CapstoneApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.windowStyle(.volumetric)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
