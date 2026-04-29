//
//  DetailView.swift
//  HabitTracker
//
//  Created by ztl on 2026/4/29.
//

import SwiftUI

struct DetailView: View {
    let habit: Habit
    var store: HabitStore

    @State private var selectedMonth = Date()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // 顶部习惯卡片
                HabitHeaderCard(habit: habit)

                // 统计数字
                StatsRow(habit: habit)

                // 热力图日历
                CalendarHeatmap(
                    habit: habit,
                    month: selectedMonth,
                    onPrevMonth: {
                        selectedMonth = Calendar.current.date(
                            byAdding: .month, value: -1, to: selectedMonth
                        )!
                    },
                    onNextMonth: {
                        selectedMonth = Calendar.current.date(
                            byAdding: .month, value: 1, to: selectedMonth
                        )!
                    }
                )

                // 打卡按钮
                CheckInButton(habit: habit) {
                    withAnimation(.spring(duration: 0.3)) {
                        store.toggleToday(habit)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(habit.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 顶部卡片
struct HabitHeaderCard: View {
    let habit: Habit

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: habit.icon)
                .font(.system(size: 40))
                .foregroundStyle(Color.fromName(habit.colorName))
                .frame(width: 80, height: 80)
                .background(Color.fromName(habit.colorName).opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 20))

            VStack(alignment: .leading, spacing: 6) {
                Text(habit.name)
                    .font(.title2.bold())
                Label("\(habit.currentStreak) 天连续坚持", systemImage: "flame.fill")
                    .font(.subheadline)
                    .foregroundStyle(.orange)
                Label("累计完成 \(habit.completedDates.count) 次", systemImage: "checkmark.seal.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color.fromName(habit.colorName).opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - 统计数字行
struct StatsRow: View {
    let habit: Habit

    var completionRate: Int {
        guard !habit.completedDates.isEmpty else { return 0 }
        let daysSinceFirst = Calendar.current.dateComponents(
            [.day],
            from: habit.completedDates.min()!,
            to: Date()
        ).day! + 1
        return min(100, Int(Double(habit.completedDates.count) / Double(daysSinceFirst) * 100))
    }

    var bestStreak: Int {
        guard !habit.completedDates.isEmpty else { return 0 }
        let sorted = habit.completedDates
            .map { Calendar.current.startOfDay(for: $0) }
            .sorted()
        var best = 1, current = 1
        for i in 1..<sorted.count {
            let diff = Calendar.current.dateComponents(
                [.day], from: sorted[i-1], to: sorted[i]
            ).day!
            current = diff == 1 ? current + 1 : 1
            best = max(best, current)
        }
        return best
    }

    var body: some View {
        HStack(spacing: 12) {
            StatCard(value: "\(habit.currentStreak)", label: "当前连续", icon: "flame.fill", color: .orange)
            StatCard(value: "\(bestStreak)", label: "最长连续", icon: "trophy.fill", color: .yellow)
            StatCard(value: "\(completionRate)%", label: "完成率", icon: "chart.pie.fill", color: .blue)
        }
    }
}

struct StatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.title3)
            Text(value)
                .font(.title2.bold())
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color.primary.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - 热力图日历
struct CalendarHeatmap: View {
    let habit: Habit
    let month: Date
    let onPrevMonth: () -> Void
    let onNextMonth: () -> Void

    let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 7)
    let weekdays = ["日", "一", "二", "三", "四", "五", "六"]

    var daysInMonth: [Date?] {
        let calendar = Calendar.current
        let start = calendar.date(
            from: calendar.dateComponents([.year, .month], from: month)
        )!
        let range = calendar.range(of: .day, in: .month, for: start)!
        let firstWeekday = calendar.component(.weekday, from: start) - 1

        var days: [Date?] = Array(repeating: nil, count: firstWeekday)
        for day in range {
            days.append(calendar.date(byAdding: .day, value: day - 1, to: start))
        }
        return days
    }

    func isCompleted(_ date: Date) -> Bool {
        habit.completedDates.contains {
            Calendar.current.isDate($0, inSameDayAs: date)
        }
    }

    func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }

    var body: some View {
        VStack(spacing: 14) {

            // 月份导航
            HStack {
                Button(action: onPrevMonth) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(month, format: .dateTime.year().month(.wide))
                    .font(.headline)
                Spacer()
                Button(action: onNextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .foregroundStyle(
                            Calendar.current.isDate(month, equalTo: Date(), toGranularity: .month)
                            ? Color.secondary.opacity(0.3)
                            : .secondary
                        )
                }
                .disabled(
                    Calendar.current.isDate(month, equalTo: Date(), toGranularity: .month)
                )
            }

            // 星期标题
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            // 日历格子
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(Array(daysInMonth.enumerated()), id: \.offset) { _, date in
                    if let date {
                        let completed = isCompleted(date)
                        let today = isToday(date)

                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    completed
                                    ? Color.fromName(habit.colorName)
                                    : Color.primary.opacity(0.05)
                                )
                            if today {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.fromName(habit.colorName), lineWidth: 2)
                            }
                            Text("\(Calendar.current.component(.day, from: date))")
                                .font(.caption.bold())
                                .foregroundStyle(
                                    completed ? .white :
                                    today ? Color.fromName(habit.colorName) : .secondary
                                )
                        }
                        .aspectRatio(1, contentMode: .fit)
                    } else {
                        Color.clear.aspectRatio(1, contentMode: .fit)
                    }
                }
            }
        }
        .padding()
        .background(Color.primary.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - 打卡按钮
struct CheckInButton: View {
    let habit: Habit
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 10) {
                Image(systemName: habit.isCompletedToday
                      ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                Text(habit.isCompletedToday ? "今天已完成 🎉" : "完成今日打卡")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                habit.isCompletedToday
                ? Color.fromName(habit.colorName).opacity(0.15)
                : Color.fromName(habit.colorName)
            )
            .foregroundStyle(
                habit.isCompletedToday
                ? Color.fromName(habit.colorName)
                : .white
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}
