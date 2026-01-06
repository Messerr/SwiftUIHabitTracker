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
	var progressByDate: [String: Double]
    
	init(
		id: UUID = UUID(),
		category: HabitCategory,
		name: String,
		notes: String? = nil,
		dailyGoal: Double? = nil,
		progressByDate: [String: Double] = [:]
	) {
		self.id = id
		self.category = category
		self.name = name
		self.notes = notes
		self.dailyGoal = dailyGoal ?? category.defaultGoal
		self.progressByDate = progressByDate
	}
	
	var progressByDay: [Date: Double] {
		var result: [Date: Double] = [:]
		let formatter = Habit.dateFormatter
		
		for (key, value) in progressByDate {
			if let date = formatter.date(from: key) {
				result[date] = value
			}
		}
		return result
	}

	static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.calendar = .current
		formatter.locale = .current
		formatter.timeZone = .current
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter
	}()

	mutating func addProgress(on date: Date, amount: Double) {
		let key = Habit.dateFormatter.string(from: date)
		progressByDate[key, default: 0] += amount
	}
}
