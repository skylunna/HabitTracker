//
//  Habit.swift
//  HabitTracker
//
//  Created by ztl on 2026/4/28.
//

import SwiftData
import Foundation

struct Habit: Identifiable, Codable {
    var id = UUID()
    var name: String
    var icon: String      // SF Symbol 名称，例如 "figure.run"
    var colorName: String // 颜色名称，例如 "blue"
    var completedDates: [Date] = []
    
    // 今天是否完成
    var isCompletedToday: Bool {
        completedDates.contains {
            Calendar.current.isDateInToday($0)
        }
    }
    
    // 当前连续天数
    var currentStreak: Int {
        var streak = 0
        var checkDate = Date()
        let calendar = Calendar.current
        
        while true {
            let completed = completedDates.contains {
                calendar.isDate($0, inSameDayAs: checkDate)
            }
            guard completed else { break }
            streak += 1
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
        }
        return streak
    }
    
    // 本周完成次数
    var weeklyCount: Int {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        return completedDates.filter { $0 >= weekAgo }.count
    }
}
