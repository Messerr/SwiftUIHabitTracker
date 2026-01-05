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
    var habits: [Habit] = []
    
    func addHabit(name: String, notes: String? = nil ) {
        let habit = Habit(name: name, notes: notes)
        habits.append(habit)
    }
    
    func toggleToday(for habit: Habit) {
        guard let index = habits.firstIndex(of: habit) else { return }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if habits[index].completedDates.contains(where: {
            calendar.isDate($0, inSameDayAs: today)
        }) {
            habits[index].completedDates.removeAll {
                calendar.isDate($0, inSameDayAs: today)
            }
        } else {
            habits[index].completedDates.append(today)
        }
    }
    
    func isCompletedToday(_ habit: Habit) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return habit.completedDates.contains {
            calendar.isDate($0, inSameDayAs: today)
        }
    }
    
    func currentStreak(for habit: Habit) -> Int {
        var streak = 0
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var currentDay = today
        
        while habit.completedDates.contains(where: {
            calendar.isDate($0, inSameDayAs: currentDay)
        }) {
            streak += 1
            
            guard let previousDay = calendar.date(
                byAdding: .day,
                value: -1,
                to: currentDay
            ) else {
                break
            }
            
            return streak
        }
    }
}
