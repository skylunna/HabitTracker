//
//  HabitRowView.swift
//  HabitTracker
//
//  Created by ztl on 2026/4/29.
//

import SwiftUI
import SwiftData

struct HabitRowView: View {
    @Bindable var habit: Habit
    let viewModel: HabitViewModel
    
    var isCompletedToday: Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return habit.completedDates.contains { Calendar.current.isDate($0, inSameDayAs: today) }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(habit.accentColor))
                .frame(width: 10, height: 10)
            
            Text(habit.title)
                .font(.headline)
            
            Spacer()
            
            Button(action: {
                viewModel.toggleCompletion(for: habit)
            }) {
                Image(systemName: isCompletedToday ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isCompletedToday ? Color(habit.accentColor) : .secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    ContentView()
}
