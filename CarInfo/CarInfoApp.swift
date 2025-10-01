//
//  CarInfoApp.swift
//  CarInfo
//
//  Created by window1 on 9/9/25.
//

import SwiftUI
import SwiftData

@main
struct CarInfoApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
