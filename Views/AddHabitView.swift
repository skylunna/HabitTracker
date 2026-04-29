//
//  AddHabitView.swift
//  HabitTracker
//
//  Created by ztl on 2026/4/29.
//

import SwiftUI

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var selectedColor = "blue"
    let onAdd: (String, String) -> Void
    
    private let colors = ["blue", "green", "orange", "red", "purple", "yellow"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("习惯名称") {
                    TextField("例如：每天阅读 30 分钟", text: $title)
                        .autocapitalization(.none)
                }
                
                Section("标识颜色") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(colors, id: \.self) { color in
                                Circle()
                                    .fill(Color(color))
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Circle().stroke(Color.white, lineWidth: selectedColor == color ? 3 : 0)
                                    )
                                    .onTapGesture { selectedColor = color }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("新建习惯")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !cleanTitle.isEmpty else { return }
                        onAdd(cleanTitle, selectedColor)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
