//
//  Habit.swift
//  HabitTracker
//
//  Created by ztl on 2026/4/28.
//

import SwiftData
import Foundation

@Model
final class Habit {
    var id: UUID
    var title: String
    var createAt: Date
    var completedDates: [Date]
    var accentColor: String
    
    init(title: String, accentColor: String = "blue") {
        self.id = UUID()
        self.title = title
        self.createAt = Date()
        self.completedDates = []
        self.accentColor = accentColor
    }
}
