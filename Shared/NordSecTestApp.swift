//
//  NordSecTestApp.swift
//  Shared
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import SwiftUI

@main
struct NordSecTestApp: App {
    
    @ObservedObject private var appDataContainer = AppDataContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appDataContainer)
        }
    }
}
