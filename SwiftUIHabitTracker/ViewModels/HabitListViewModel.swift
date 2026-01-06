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
	private var storageKey = "habits_storage"
    var habits: [Habit] = []
    
	init() {
		loadHabits()
	}
	
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
	
	
    func addHabit(name: String, notes: String? = nil ) {
        let habit = Habit(name: name, notes: notes)
        habits.append(habit)
		saveHabits()
    }
    
	func updateHabit(
		id: UUID,
		name: String,
		notes: String?
	){
		guard let index = habits.firstIndex(where: { $0.id == id }) else { return }
		
		habits[index].name = name
		habits[index].notes = notes
		saveHabits()
	}
	
	func deleteHabit(id: UUID) {
		habits.removeAll { $0.id == id }
		saveHabits()
	}
    
    func isCompletedToday(_ habit: Habit) -> Bool {
		progressToday(for: habit) >= habit.dailyGoal
    }
    
    func currentStreak(for habit: Habit) -> Int {
        var streak = 0
        let calendar = Calendar.current
		var currentDay = calendar.startOfDay(for: Date())
        
        while true {
			let progress = habit.progressByDate[currentDay] ?? 0
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
	
	func progressToday(for habit: Habit) -> Double {
		let today = startOfToday()
		return habit.progressByDate[today] ?? 0
	}
	
	func addProgress(
		for habit: Habit,
		amount: Double
	){
		guard let index = habits.firstIndex(of: habit) else { return }
		let today = startOfToday()
		let current = habits[index].progressByDate[today] ?? 0
		habits[index].progressByDate[today] = current + amount
		
		saveHabits()
	}
	
	private func startOfToday() -> Date {
		Calendar.current.startOfDay(for: Date())
	}
}
