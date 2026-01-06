//
//  Habit.swift
//  SwiftUIHabitTracker
//
//  Created by David Messer on 1/4/26.
//

import Foundation

struct Habit: Identifiable, Codable, Equatable {
    let id: UUID
	var category: HabitCategory
    var name: String
    var notes: String?
    
	var dailyGoal: Double
	var progressByDate: [Date: Double]
    
	init(
		id: UUID = UUID(),
		category: HabitCategory,
		name: String,
		notes: String? = nil,
		dailyGoal: Double? = nil,
		progressByDate: [Date: Double] = [:]
	) {
		self.id = id
		self.category = category
		self.name = name
		self.notes = notes
		self.dailyGoal = dailyGoal ?? category.defaultGoal
		self.progressByDate = progressByDate
	}
}
