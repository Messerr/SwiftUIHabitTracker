//
//  HabitSchedule.swift
//  SwiftUIHabitTracker
//
//  Created by David Messer on 1/5/26.
//

import Foundation

enum HabitFrequency: String, Codable, CaseIterable, Identifiable {
	case everyDay
	case everyOtherDay
	case weekly
	case monthly
	
	var id: String { rawValue }
	
	var displayName: String {
		switch self {
		case .everyDay:
			return "Every day"
		case .everyOtherDay:
			return "Every other day"
		case .weekly:
			return "Weekly"
		case .monthly:
			return "Monthly"
		}
	}
}

enum HabitPeriod: String, Codable, CaseIterable, Identifiable {
	case day
	case week
	case month
	
	var id: String { rawValue }
	
	var displayName: String {
		switch self {
		case .day: return "Daily"
		case .week: return "Weekly"
		case .month: return "Monthly"
		}
	}
}


