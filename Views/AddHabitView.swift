//
//  AddHabitView.swift
//  HabitTracker
//
//  Created by ztl on 2026/4/29.
//

import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    var store: HabitStore

    @State private var name = ""
    @State private var selectedIcon = "figure.run"
    @State private var selectedColor = "blue"

    var body: some View {
        NavigationStack {
            Form {
                // 预览
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: selectedIcon)
                                .font(.system(size: 36))
                                .foregroundStyle(Color.fromName(selectedColor))
                                .frame(width: 80, height: 80)
                                .background(Color.fromName(selectedColor).opacity(0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 20))

                            Text(name.isEmpty ? "新习惯" : name)
                                .font(.headline)
                                .foregroundStyle(name.isEmpty ? .secondary : .primary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }

                // 名称
                Section("习惯名称") {
                    TextField("例如：晨跑、读书、喝水", text: $name)
                }

                // 图标
                Section("选择图标") {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible()), count: 6),
                        spacing: 12
                    ) {
                        ForEach(iconOptions, id: \.self) { icon in
                            Button {
                                selectedIcon = icon
                            } label: {
                                Image(systemName: icon)
                                    .font(.title3)
                                    .foregroundStyle(
                                        selectedIcon == icon
                                        ? Color.fromName(selectedColor)
                                        : .secondary
                                    )
                                    .frame(width: 44, height: 44)
                                    .background(
                                        selectedIcon == icon
                                        ? Color.fromName(selectedColor).opacity(0.15)
                                        : Color.clear
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(
                                                selectedIcon == icon
                                                ? Color.fromName(selectedColor)
                                                : Color.clear,
                                                lineWidth: 1.5
                                            )
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                }

                // 颜色
                Section("选择颜色") {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible()), count: 6),
                        spacing: 12
                    ) {
                        ForEach(colorOptions, id: \.self) { color in
                            Button {
                                selectedColor = color
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.fromName(color))
                                        .frame(width: 36, height: 36)
                                    if selectedColor == color {
                                        Image(systemName: "checkmark")
                                            .font(.caption.bold())
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("添加习惯")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("添加") {
                        let habit = Habit(
                            name: name.trimmingCharacters(in: .whitespaces),
                            icon: selectedIcon,
                            colorName: selectedColor
                        )
                        store.addHabit(habit)
                        dismiss()
                    }
                    .bold()
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    let iconOptions = [
        "figure.run", "figure.walk", "figure.hiking", "figure.swimming",
        "figure.yoga", "figure.cooldown", "dumbbell.fill", "bicycle",
        "book.fill", "pencil", "doc.text.fill", "graduationcap.fill",
        "drop.fill", "fork.knife", "cup.and.saucer.fill", "carrot.fill",
        "moon.fill", "sunrise.fill", "heart.fill", "brain.head.profile",
        "music.note", "paintbrush.fill", "camera.fill", "gamecontroller.fill"
    ]

    let colorOptions = [
        "red", "orange", "yellow", "green",
        "teal", "blue", "indigo", "purple",
        "pink", "brown", "gray", "mint"
    ]
}
