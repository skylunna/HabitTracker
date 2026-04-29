//
//  HabitViewModel.swift
//  HabitTracker
//
//  Created by ztl on 2026/4/29.
//

import SwiftUI

@Observable
class HabitStore {
    var habits: [Habit] = [] {
        didSet { save() }
    }
    
    init() {
        load()
        // 第一次运行，加入示例数据
        if habits.isEmpty {
            habits = [
                Habit(name: "晨跑", icon: "figure.run", colorName: "orange"),
                Habit(name: "读书", icon: "book.fill", colorName: "blue"),
                Habit(name: "喝水", icon: "drop.fill", colorName: "teal"),
            ]
        }
    }
    
    // 打卡 / 取消打卡
    func toggleToday(_ habit: Habit) {
        guard let i = habits.firstIndex(where: { $0.id == habit.id }) else { return }
        if habits[i].isCompletedToday {
            habits[i].completedDates.removeAll { Calendar.current.isDateInToday($0) }
        } else {
            habits[i].completedDates.append(Date())
        }
    }
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
    }
    
    func deleteHabit(at offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
    }
    
    // MARK: - 持久化
    private func save() {
        if let data = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(data, forKey: "habits_v1")
        }
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: "habits_v1"),
              let saved = try? JSONDecoder().decode([Habit].self, from: data)
        else { return }
        habits = saved
    }
}
