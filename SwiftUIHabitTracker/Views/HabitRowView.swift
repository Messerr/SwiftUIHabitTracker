//
//  HabitRowView.swift
//  SwiftUIHabitTracker
//
//  Created by David Messer on 1/5/26.
//

import SwiftUI

struct HabitRowView: View {
	let habit: Habit
	let progressToday: Double
	let isCompletedToday: Bool
	let streak: Int
	let onAddProgress: () -> Void
	
    var body: some View {
		HStack(spacing: 12) {
			Button {
				onAddProgress()
			} label: {
				Image(systemName: isCompletedToday
					  ? "checkmark.circle.fill"
					  : "plus.circle")
				.font(.title2)
				.foregroundColor(isCompletedToday ? .green : .primary)
			}
			.buttonStyle(.plain)
			
			VStack(alignment: .leading, spacing: 4) {
				Text(habit.name)
					.font(.headline)
				
				Text("\(formattedProgress) / \(formattedGoal) \(habit.category.unit)")
					.font(.headline)
					.foregroundStyle(.secondary)
				
				if streak > 0 {
					HStack(spacing: 4) {
						Image(systemName: "flame.fill")
							.foregroundStyle(.orange)
						Text("\(streak) day streak")
							.font(.caption)
					}
				}
			}
			
			Spacer()
			
		}
		.padding(.vertical, 6)
    }
	
	private var formattedProgress: String {
		habit.category.unit == "liters"
		? String(format: "%.1f", progressToday)
		: String(format: "%.0f", progressToday)
	}
	
	private var formattedGoal: String {
		habit.category.unit == "liters"
		? String(format: "%.1f", habit.dailyGoal)
		: String(format: "%.0f", habit.dailyGoal)
	}
}

#Preview {
	let previewHabit = Habit(
		category: .water,
		name: "New Habit",
		notes: "These are notes"
	)
	
    HabitRowView(
		habit: previewHabit,
		progressToday: 0.2,
		isCompletedToday: false,
		streak: 1,
		onAddProgress: {}
	)
}
