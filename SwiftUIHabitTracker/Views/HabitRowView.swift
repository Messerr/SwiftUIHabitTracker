//
//  HabitRowView.swift
//  SwiftUIHabitTracker
//
//  Created by David Messer on 1/5/26.
//

import SwiftUI

struct HabitRowView: View {
	let habit: Habit
	let isCompletedToday: Bool
	let streak: Int
	let onToggle: () -> Void
	
    var body: some View {
		HStack(spacing: 12) {
			Button {
				onToggle()
			} label: {
				Image(systemName: isCompletedToday
					  ? "checkmark.circle.fill"
					  : "circle")
				.foregroundStyle(isCompletedToday ? .green : .secondary)
				.font(.title3)
			}
			.buttonStyle(.plain)
			
			VStack(alignment: .leading, spacing: 2) {
				Text(habit.name)
					.font(.body)
					.fontWeight(.medium)
				
				if streak > 0 {
					Text("\(streak) day streak")
						.font(.caption)
						.foregroundStyle(.secondary)
				}
			}
			.opacity(isCompletedToday ? 0.7 : 1)
			
			Spacer()
		}
		.padding(.vertical, 6)
    }
}

#Preview {
	let previewHabit = Habit(
		name: "New Habit",
		notes: "These are notes"
	)
	
    HabitRowView(
		habit: previewHabit,
		isCompletedToday: false,
		streak: 1,
		onToggle: { }
	)
}
