//
//  HabitRowView.swift
//  SwiftUIHabitTracker
//
//  Created by David Messer on 1/5/26.
//

import SwiftUI

struct HabitRowView: View {
	let habit: Habit
	
	var body: some View {
		HStack(spacing: 12) {
			VStack(alignment: .leading, spacing: 4) {
				Text(habit.category.displayName)
					.font(.headline)
				
				Text(progressText)
					.font(.subheadline)
					.foregroundStyle(.secondary)
			}
			
			Spacer()
			
			Text("\(Int(habit.progressRatio() * 100))%")
				.font(.headline)
				.foregroundStyle(.blue)
		}
		.padding(.vertical, 6)
	}
	
	private var progressText: String {
		let progress = habit.progressInCurrentPeriod()
		let goal = habit.targetValue
		
		if habit.category.unit == "liters" {
			return String(format: "%.1f / %.1f %@", progress, goal, habit.category.unit)
		} else {
			return String(format: "%.0f / %.0f %@", progress, goal, habit.category.unit)
		}
	}
}

#Preview {
	let previewHabit = Habit(
		category: .water,
		frequency: .everyDay,
		period: .day,
		targetValue: 2.0
	)
	
	HabitRowView(habit: previewHabit)
}

