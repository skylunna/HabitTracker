//
//  HomeView.swift
//  HabitTracker
//
//  Created by ztl on 2026/4/29.
//

import SwiftUI

struct HomeView: View {
    @State private var store = HabitStore()
    @State private var showingAddHabit = false

    var completedCount: Int {
        store.habits.filter { $0.isCompletedToday }.count
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ProgressCard(
                    completed: completedCount,
                    total: store.habits.count
                )
                .padding()

                List {
                    ForEach(store.habits) { habit in
                        NavigationLink(destination: DetailView(habit: habit, store: store)) {
                            HabitRow(habit: habit) {
                                withAnimation(.spring(duration: 0.3)) {
                                    store.toggleToday(habit)
                                }
                            }
                        }
                    }
                    .onDelete { store.deleteHabit(at: $0) }
                }
                .listStyle(.plain)
            }
            .navigationTitle("今日习惯")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showingAddHabit = true } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView(store: store)
            }
        }
    }
}

// MARK: - 进度卡片
struct ProgressCard: View {
    let completed: Int
    let total: Int

    var progress: Double {
        total == 0 ? 0 : Double(completed) / Double(total)
    }

    var emoji: String {
        switch progress {
        case 1.0:       return "🎉"
        case 0.5...:    return "💪"
        case 0.0001...: return "🚀"
        default:        return "☀️"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(Date(), style: .date)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("\(emoji) 今日进度")
                        .font(.title2.bold())
                }
                Spacer()
                ZStack {
                    Circle()
                        .stroke(Color.primary.opacity(0.1), lineWidth: 6)
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.accentColor, style: StrokeStyle(
                            lineWidth: 6, lineCap: .round
                        ))
                        .rotationEffect(.degrees(-90))
                        .animation(.spring(duration: 0.5), value: progress)
                    Text("\(completed)/\(total)")
                        .font(.caption.bold())
                }
                .frame(width: 56, height: 56)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.primary.opacity(0.08))
                        .frame(height: 8)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.accentColor)
                        .frame(width: geo.size.width * progress, height: 8)
                        .animation(.spring(duration: 0.5), value: progress)
                }
            }
            .frame(height: 8)
        }
        .padding()
        .background(Color.accentColor.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - 习惯行
struct HabitRow: View {
    let habit: Habit
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: habit.icon)
                .font(.title3)
                .foregroundStyle(Color.fromName(habit.colorName))
                .frame(width: 44, height: 44)
                .background(Color.fromName(habit.colorName).opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 3) {
                Text(habit.name)
                    .font(.headline)
                    .strikethrough(habit.isCompletedToday, color: .secondary)
                    .foregroundStyle(habit.isCompletedToday ? .secondary : .primary)

                if habit.currentStreak > 0 {
                    Label("\(habit.currentStreak) 天连续", systemImage: "flame.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }

            Spacer()

            Button(action: onToggle) {
                Image(systemName: habit.isCompletedToday
                      ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(habit.isCompletedToday
                        ? Color.fromName(habit.colorName)
                        : Color.secondary.opacity(0.4))
                    .scaleEffect(habit.isCompletedToday ? 1.1 : 1.0)
                    .animation(.spring(duration: 0.2), value: habit.isCompletedToday)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}
