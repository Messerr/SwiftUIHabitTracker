//
//  AddHabitView.swift
//  SwiftUIHabitTracker
//
//  Created by David Messer on 1/5/26.
//

import SwiftUI

struct AddHabitView: View {
	@State private var category: HabitCategory = .water
	@State private var name = ""
	@State private var notes = ""
	@State private var dailyGoal: Double = 1
	
	let onSave: (HabitCategory, String, String?, Double) -> Void
	@Environment(\.dismiss) private var dismiss
	
	var body: some View {
		NavigationStack {
			Form {
				Section("Type") {
					Picker(
						selection: $category,
						label: Text("Habit")
					) {
						ForEach(HabitCategory.allCases, id: \.self) { category in
							Text(category.displayName)
								.tag(category)
						}
					}
				}
				
				Section("Details") {
					TextField("Habit Name", text: $name)
					TextField("Notes (optional)", text: $notes)
				}
				
				Section("Daily Goal") {
					Stepper(
						value: $dailyGoal,
						in: category.goalRange,
						step: category.stepSize
					) {
						Text("\(formattedGoal) \(category.unit)")
					}
				}
			}
			.navigationTitle("New Habit")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Save") {
						onSave(
							category,
							name,
							notes.isEmpty ? nil : notes,
							dailyGoal
						)
						dismiss()
					}
					.disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
				}
				
				ToolbarItem(placement: .topBarLeading) {
					Button("Cancel") {
						dismiss()
					}
				}
			}
		}
	}
	
	private var formattedGoal: String {
		category.unit == "liters"
		? String(format: "%.1f", dailyGoal)
		: String(format: "%.0f", dailyGoal)
	}
}


#Preview {
	AddHabitView { _, _, _, _ in

	}
}
