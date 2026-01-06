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
	
	// MARK: - Helpers
	
	private func startOfToday() -> Date {
		Calendar.current.startOfDay(for: Date())
	}
	
	private func dayKey(for date: Date) -> String {
		Habit.dateFormatter.string(from: date)
	}
	
	// MARK: - CRUD
	
	func addHabit(
		category: HabitCategory,
		name: String,
		notes: String? = nil,
		dailyGoal: Double
	) {
		let habit = Habit(
			category: category,
			name: name,
			notes: notes,
			dailyGoal: dailyGoal
		)
		
		habits.append(habit)
		saveHabits()
	}
	
	func updateHabit(
		id: UUID,
		name: String,
		notes: String?
	) {
		guard let index = habits.firstIndex(where: { $0.id == id }) else { return }
		
		habits[index].name = name
		habits[index].notes = notes
		saveHabits()
	}
	
	func deleteHabit(id: UUID) {
		habits.removeAll { $0.id == id }
		saveHabits()
	}
	
	// MARK: - Progress
	
	func addProgress(
		for habit: Habit,
		amount: Double
	) {
		guard let index = habits.firstIndex(of: habit) else { return }
		
		let key = dayKey(for: startOfToday())
		habits[index].progressByDate[key, default: 0] += amount
		
		saveHabits()
	}
	
	func progressToday(for habit: Habit) -> Double {
		let key = dayKey(for: startOfToday())
		return habit.progressByDate[key] ?? 0
	}
	
	func isCompletedToday(_ habit: Habit) -> Bool {
		progressToday(for: habit) >= habit.dailyGoal
	}
	
	func currentStreak(for habit: Habit) -> Int {
		var streak = 0
		let calendar = Calendar.current
		var currentDay = calendar.startOfDay(for: Date())
		
		while true {
			let key = dayKey(for: currentDay)
			let progress = habit.progressByDate[key] ?? 0
			
			if progress >= habit.dailyGoal {
				streak += 1
			} else {
				break
			}
			
			guard let previousDay = calendar.date(
				byAdding: .day,
				value: -1,
				to: currentDay
			) else {
				break
			}
			
			currentDay = previousDay
		}
		
		return streak
	}
}
