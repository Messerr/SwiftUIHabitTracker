//
//  HabitListViewModel.swift
//  SwiftUIHabitTracker
//
//  Created by David Messer on 1/4/26.
//

import Foundation
import Observation

@Observable
class HabitListViewModel {
	private let storageKey = "habits_storage"
	var habits: [Habit] = []
	
	init() {
		loadHabits()
	}
	
	// MARK: - Persistence
	private func loadHabits() {
		guard
			let data = UserDefaults.standard.data(forKey: storageKey),
			let decoded = try? JSONDecoder().decode([Habit].self, from: data)
		else {
			return
		}
		
		habits = decoded
	}
	
	private func saveHabits() {
		guard let data = try? JSONEncoder().encode(habits) else { return }
		UserDefaults.standard.set(data, forKey: storageKey)
	}
	
	// MARK: - CRUD
	
	func addHabit(
		category: HabitCategory,
		frequency: HabitFrequency,
		period: HabitPeriod,
		targetValue: Double,
		weekdays: Set<Weekday>,
		notes: String?
	) {
		let habit = Habit(
			category: category,
			frequency: frequency,
			period: period,
			targetValue: targetValue,
			weekdays: weekdays,
			notes: notes
		)
		
		habits.append(habit)
		saveHabits()
	}

	func updateHabit(
		id: UUID,
		category: HabitCategory,
		frequency: HabitFrequency,
		period: HabitPeriod,
		targetValue: Double,
		weekdays: Set<Weekday>,
		notes: String?
	) {
		guard let index = habits.firstIndex(where: { $0.id == id }) else { return }
		
		habits[index].category = category
		habits[index].frequency = frequency
		habits[index].period = period
		habits[index].targetValue = targetValue
		habits[index].weekdays = weekdays
		habits[index].notes = notes
		
		saveHabits()
	}

	func deleteHabit(id: UUID) {
		habits.removeAll { $0.id == id }
		saveHabits()
	}
	
	// MARK: - Progress
	func addProgress(for habitID: UUID, amount: Double) {
		guard let index = habits.firstIndex(where: { $0.id == habitID }) else { return }
		
		habits[index].addProgress(amount)
		saveHabits()
	}
	
	func progressValue(for habit: Habit) -> Double {
		habit.progressInCurrentPeriod()
	}
	
	func progressRatio(for habit: Habit) -> Double {
		habit.progressRatio()
	}
	
	func habitsScheduled(on date: Date) -> [Habit] {
		habits.filter { $0.isScheduled(on: date) }
	}
}
