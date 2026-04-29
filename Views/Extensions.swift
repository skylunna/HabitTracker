//
//  Extensions.swift
//  HabitTracker
//
//  Created by ztl on 2026/4/29.
//

import SwiftUI

extension Color {
    static func fromName(_ name: String) -> Color {
        switch name {
        case "red":    return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "green":  return .green
        case "teal":   return .teal
        case "blue":   return .blue
        case "indigo": return .indigo
        case "purple": return .purple
        case "pink":   return .pink
        case "brown":  return .brown
        case "gray":   return .gray
        case "mint":   return .mint
        default:       return .blue
        }
    }
}
