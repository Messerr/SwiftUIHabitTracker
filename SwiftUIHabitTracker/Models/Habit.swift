//
//  Habit.swift
//  SwiftUIHabitTracker
//
//  Created by David Messer on 1/4/26.
//

import Foundation

struct Habit: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var notes: String?
    var completedDates: [Date]
    
    init(
        id: UUID = UUID(),
        name: String,
        notes: String? = nil,
        completedDates: [Date] = []
    ) {
        self.id = id
        self.name = name
        self.notes = notes
        self.completedDates = completedDates
    }
}
