//
//  HabitDetailView.swift
//  SwiftUIHabitTracker
//
//  Created by David Messer on 1/5/26.
//

import SwiftUI

struct HabitEditView: View {
	let habitID: UUID
	let vm: HabitListViewModel
	
	@Environment(\.dismiss) private var dismiss
	
	@State private var notes: String = ""
	@State private var targetValue: Double = 0
	@State private var frequency: HabitFrequency = .everyDay
	@State private var period: HabitPeriod = .day
	@State private var weekdays: Set<Weekday> = []
	
	private var habit: Habit? {
		vm.habits.first { $0.id == habitID }
	}
	
	var body: some View {
		Form {
			if let habit {
				
				Section("Notes") {
					TextEditor(text: $notes)
						.frame(minHeight: 100)
				}

				// MARK: - Goal
				Section("Goal per \(period.displayName)") {
					Stepper(
						value: $targetValue,
						in: habit.category.goalRange,
						step: habit.category.stepSize
					) {
						Text(goalLabel(for: habit))
					}
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
						ForEach(HabitPeriod.allCases) { habitPeriod in
							Text(habitPeriod.displayName)
								.tag(habitPeriod)
						}
					}
				}
				
				// MARK: - Weekdays (only for weekly)
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
			}
		}
		.navigationTitle("Edit Habit")
		.navigationBarTitleDisplayMode(.inline)
		.onAppear {
			guard let habit else { return }
			targetValue = habit.targetValue
			frequency = habit.frequency
			period = habit.period
			weekdays = habit.weekdays
			notes = habit.notes ?? ""
		}
		.toolbar {
			ToolbarItem(placement: .topBarLeading) {
				Button("Cancel") {
					dismiss()
				}
			}
			
			ToolbarItem(placement: .topBarTrailing) {
				Button("Save") {
					guard let habit else { return }
					
					vm.updateHabit(
						id: habit.id,
						category: habit.category,
						frequency: frequency,
						period: period,
						targetValue: targetValue,
						weekdays: weekdays,
						notes: notes.isEmpty ? nil : notes
					)
					
					dismiss()
				}
			}
		}
	}
	
	private func toggle(_ day: Weekday) {
		if weekdays.contains(day) {
			weekdays.remove(day)
		} else {
			weekdays.insert(day)
		}
	}
	
	private func goalLabel(for habit: Habit) -> String {
		let unit = habit.category.unit
		
		if unit == "liters" {
			return String(format: "%.1f %@", targetValue, unit)
		} else {
			return String(format: "%.0f %@", targetValue, unit)
		}
	}
}

#Preview {
	NavigationStack {
		HabitEditView(
			habitID: UUID(),
			vm: HabitListViewModel()
		)
	}
}

