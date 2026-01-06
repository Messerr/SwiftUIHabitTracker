//
//  HabitCategory.swift
//  SwiftUIHabitTracker
//
//  Created by David Messer on 1/5/26.
//

import Foundation

enum HabitCategory: String, Codable, CaseIterable, Identifiable {
	case water
	case walking
	case meditation
	case exercise
	case reading
	
	var id: String { rawValue }
}
extension HabitCategory {
	var displayName: String {
		switch self {
		case .water: return "Drink Water"
		case .walking: return "Walk"
		case .meditation: return "Meditate"
		case .exercise: return "Exercise"
		case .reading: return "Read"
		}
	}
	
	var unit: String {
		switch self {
		case .water: return "liters"
		case .walking: return "steps"
		case .meditation, .exercise, .reading:
			return "minutes"
		}
	}
	
	var defaultGoal: Double {
		switch self {
		case .water: return 2.0
		case .walking: return 8_000
		case .meditation: return 10
		case .exercise: return 30
		case .reading: return 20
		}
	}
	
	var stepSize: Double {
		switch self {
		case .water: return 0.25
		case .walking: return 500
		default: return 5
		}
	}
}
