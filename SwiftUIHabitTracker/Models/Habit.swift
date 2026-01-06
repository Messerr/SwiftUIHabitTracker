//
//  Habit.swift
//  SwiftUIHabitTracker
//
//  Created by David Messer on 1/4/26.
//

import Foundation

struct Habit: Identifiable, Codable {
	let id: UUID
	var category: HabitCategory
	var notes: String?
	
	var frequency: HabitFrequency
	var period: HabitPeriod
	var weekdays: Set<Weekday>
	
	var targetValue: Double
	var progressByDate: [Date: Double]
	
	init(
		id: UUID = UUID(),
		category: HabitCategory,
		frequency: HabitFrequency,
		period: HabitPeriod,
		targetValue: Double,
		weekdays: Set<Weekday> = [],
		notes: String? = nil
	) {
		self.id = id
		self.category = category
		self.frequency = frequency
		self.period = period
		self.targetValue = targetValue
		self.weekdays = weekdays
		self.notes = notes
		self.progressByDate = [:]
	}
}

extension Habit {
	static func normalized(_ date: Date) -> Date {
		Calendar.current.startOfDay(for: date)
	}
	
	mutating func addProgress(_ amount: Double, on date: Date = .now) {
		let day = Self.normalized(date)
		progressByDate[day, default: 0] += amount
	}
	
	func currentPeriodRange(referenceDate: Date = .now) -> ClosedRange<Date> {
		let calendar = Calendar.current
		
		switch period {
		case .day:
			let start = calendar.startOfDay(for: referenceDate)
			let end = calendar.date(byAdding: .day, value: 1, to: start)!
			return start...end
			
		case .week:
			let start = calendar.dateInterval(of: .weekOfYear, for: referenceDate)!.start
			let end = calendar.date(byAdding: .day, value: 7, to: start)!
			return start...end
			
		case .month:
			let start = calendar.dateInterval(of: .month, for: referenceDate)!.start
			let end = calendar.date(byAdding: .month, value: 1, to: start)!
			return start...end
		}
	}
	
	func progressInCurrentPeriod(referenceDate: Date = .now) -> Double {
		let range = currentPeriodRange(referenceDate: referenceDate)
		
		return progressByDate
			.filter { range.contains($0.key) }
			.map(\.value)
			.reduce(0, +)
	}
	
	func progressRatio(referenceDate: Date = .now) -> Double {
		min(progressInCurrentPeriod(referenceDate: referenceDate) / targetValue, 1)
	}
	
	func isScheduled(on date: Date) -> Bool {
		let calendar = Calendar.current
		
		switch frequency {
		case .everyDay:
			return true
			
		case .everyOtherDay:
			let anchor = progressByDate.keys.sorted().first
			?? calendar.startOfDay(for: Date())
			
			let daysBetween = calendar.dateComponents(
				[.day],
				from: calendar.startOfDay(for: anchor),
				to: calendar.startOfDay(for: date)
			).day ?? 0
			
			return daysBetween % 2 == 0
			
		case .weekly:
			let weekday = Weekday(rawValue: calendar.component(.weekday, from: date))
			return weekday.map { weekdays.contains($0) } ?? false
			
		case .monthly:
			return calendar.component(.day, from: date) == 1
		}
	}

}
