//
//  PhysicalActivityAppApp.swift
//  PhysicalActivityApp
//
//  Created by Алексей Никулин on 20.12.2023.
//

import SwiftUI

@main
struct PhysicalActivityAppApp: App {
    @StateObject var manager = HealthManager()
    var body: some Scene {
        WindowGroup {
            TabViewPAapp()
                .environmentObject(manager)
        }
    }
}
