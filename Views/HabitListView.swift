//
//  HabitListView.swift
//  HabitTracker
//
//  Created by ztl on 2026/4/29.
//

import SwiftUI
import SwiftData

struct HabitListView: View {
    @Query(sort: \Habit.createdAt, order: .reverse) private var habits: [Habit]
    @Environment(\.modelContext) private var modelContext
    @State private var isShowingAddSheet = false
    @State private var viewModel: HabitViewModel?
    
    var body: some View {
        NavigationStack {
            List {
                if habits.isEmpty {
                    ContentUnavailableView(
                        "暂无习惯",
                        systemImage: "leaf.circle",
                        description: Text("点击右上角 + 开始记录你的第一个习惯")
                    )
                } else {
                    ForEach(habits) { habit in
                        HabitRowView(habit: habit, viewModel: viewModel!)
                    }
                    .onDelete(perform: deleteHabits)
                }
            }
            .navigationTitle("习惯追踪")
            .toolbar {
                Button(action: { isShowingAddSheet = true }) {
                    Label("添加习惯", systemImage: "plus")
                }
            }
            .sheet(isPresented: $isShowingAddSheet) {
                AddHabitView { title, color in
                    viewModel?.addHabit(title: title, color: color)
                }
            }
            .onAppear {
                viewModel = HabitViewModel(context: modelContext)
            }
        }
    }
    
    private func deleteHabits(at offsets: IndexSet) {
        viewModel?.deleteHabits(at: offsets, from: habits)
    }
}
