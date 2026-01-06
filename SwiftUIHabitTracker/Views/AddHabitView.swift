//
//  AddHabitView.swift
//  SwiftUIHabitTracker
//
//  Created by David Messer on 1/5/26.
//

import SwiftUI

struct AddHabitView: View {
	@Environment(\.dismiss) private var dismiss
	
	// MARK: - Form State
	@State private var notes: String = ""
	@State private var category: HabitCategory = .water
	@State private var frequency: HabitFrequency = .everyDay
	@State private var period: HabitPeriod = .day
	@State private var targetValue: Double = 1
	@State private var weekdays: Set<Weekday> = []
	
	let onSave: (
		_ notes: String?,
		_ category: HabitCategory,
		_ frequency: HabitFrequency,
		_ period: HabitPeriod,
		_ targetValue: Double,
		_ weekdays: Set<Weekday>
	) -> Void
	
	var body: some View {
		NavigationStack {
			Form {
				// MARK: - Category
				Section("Type") {
					Picker("Habit", selection: $category) {
						ForEach(HabitCategory.allCases) { category in
							Text(category.displayName)
								.tag(category)
						}
					}
				}
				
				// MARK: - Title
				Section("Details") {
					TextField("Notes", text: $notes)
				}
				
				// MARK: - Schedule
				Section("Schedule") {
					Picker("Frequency", selection: $frequency) {
						ForEach(HabitFrequency.allCases) { frequency in
							Text(frequency.displayName)
								.tag(frequency)
						}
					}
					
					Picker("Tracking Period", selection: $period) {
						ForEach(HabitPeriod.allCases) {
							Text($0.displayName)
								.tag($0)
						}
					}
				}
				
				// MARK: - Weekdays
				if frequency == .weekly {
					Section("Days") {
						HStack {
							ForEach(Weekday.allCases) { day in
								Button {
									toggle(day)
								} label: {
									Text(day.shortName)
										.font(.caption)
										.padding(8)
										.background(
											weekdays.contains(day)
											? Color.blue.opacity(0.2)
											: Color.gray.opacity(0.1)
										)
										.clipShape(Capsule())
								}
							}
						}
					}
				}
				
				// MARK: - Goal
				Section("Goal per \(period.displayName)") {
					Stepper(
						value: $targetValue,
						in: category.goalRange,
						step: category.stepSize
					) {
						Text(goalLabel)
					}
				}
			}
			.navigationTitle("New Habit")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button("Cancel") {
						dismiss()
					}
				}
				
				ToolbarItem(placement: .topBarTrailing) {
					Button("Save") {
						onSave(
							notes.isEmpty ? nil : notes,
							category,
							frequency,
							period,
							targetValue,
							weekdays
						)
						dismiss()
					}
				}
			}
			.onAppear {
				targetValue = category.defaultGoal
			}
			.onChange(of: category) {
				targetValue = category.defaultGoal
			}
		}
	}
	
	// MARK: - Helpers
	
	private func toggle(_ day: Weekday) {
		if weekdays.contains(day) {
			weekdays.remove(day)
		} else {
			weekdays.insert(day)
		}
	}
	
	private var goalLabel: String {
		if category.unit == "liters" {
			return String(format: "%.1f %@", targetValue, category.unit)
		} else {
			return String(format: "%.0f %@", targetValue, category.unit)
		}
	}
}

#Preview {
	AddHabitView { _, _, _, _, _, _ in }
}

