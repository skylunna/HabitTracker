//
//  HabitViewModel.swift
//  HabitTracker
//
//  Created by ztl on 2026/4/29.
//

import SwiftData
import Foundation

@Observable
final class HabitViewModel {
    let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // 添加习惯
    func addHabit(title: String, color: String) {
        let newHabit = Habit(title: title, accentColor: color)
        context.insert(newHabit)
    }
    
    // 删除习惯
    func deleteHabits(at offsets: IndexSet, from habits: [Habit]) {
        for index in offsets {
            context.delete(habits[index])
        }
    }
    
    // 切换今日打卡状态
    func toggleCompletion(for habit: Habit) {
        let today = Calendar.current.startOfDay(for: Date())
        let isCompleted = habit.completedDates.contains { Calendar.current.isDate($0, inSameDayAs: today) }
        
        if isCompleted {
            habit.completedDates.removeAll { Calendar.current.isDate($0, inSameDayAs: today) }
        } else {
            habit.completedDates.append(today)
        }
    }
}
