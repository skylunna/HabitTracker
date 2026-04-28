//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by ztl on 2026/4/28.
//

import SwiftUI
import SwiftData


@main
struct HabitTrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Habit.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("SwiftData 初始化失败: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
