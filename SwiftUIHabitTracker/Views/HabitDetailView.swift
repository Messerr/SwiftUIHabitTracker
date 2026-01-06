//
//  HabitDetailView.swift
//  SwiftUIHabitTracker
//
//  Created by David Messer on 1/5/26.
//

import SwiftUI

struct HabitDetailView: View {
	let habitID: UUID
	let vm: HabitListViewModel
	
	@State private var isEditing = false
	@State private var editedName = ""
	@State private var editedNotes = ""
	@State private var showDeletionConfirmation = false
	
	@Environment(\.dismiss) private var dismiss
	
	private var habit: Habit? {
		vm.habits.first { $0.id == habitID }
	}
	
	var body: some View {
		Group {
			if let habit {
				detailContent(for: habit)
			} else {
				Text("Habit not found")
			}
		}
	}
	
	@ViewBuilder
	private func detailContent(for habit: Habit) -> some View {
		let hasChanges =
		editedName != habit.name ||
		editedNotes != (habit.notes ?? "")
		
		let history = habit.progressByDate
			.sorted { $0.key > $1.key }
		
		ScrollView {
			VStack(alignment: .leading, spacing: 16) {
				
				// MARK: - Title
				if isEditing {
					TextField("Habit name", text: $editedName)
						.font(.largeTitle)
						.fontWeight(.bold)
				} else {
					Text(habit.name)
						.font(.largeTitle)
						.fontWeight(.bold)
				}
				
				// MARK: - Goal
				Text("Daily goal: \(formatted(habit.dailyGoal)) \(habit.category.unit)")
					.font(.subheadline)
					.foregroundStyle(.secondary)
				
				// MARK: - Notes
				if isEditing {
					TextEditor(text: $editedNotes)
						.frame(minHeight: 100)
						.overlay(
							RoundedRectangle(cornerRadius: 8)
								.stroke(.secondary.opacity(0.3))
						)
				} else if let notes = habit.notes, !notes.isEmpty {
					Text(notes)
						.foregroundStyle(.secondary)
				}
				
				// MARK: - Streak
				let streak = vm.currentStreak(for: habit)
				if streak > 0 {
					HStack {
						Image(systemName: "flame.fill")
							.foregroundStyle(.orange)
						Text("\(streak) day streak")
							.font(.headline)
					}
				}
				
				Divider()
				
				// MARK: - History
				VStack(alignment: .leading, spacing: 8) {
					Text("Completion History")
						.font(.headline)
					
					if history.isEmpty {
						Text("No progress yet")
							.foregroundStyle(.secondary)
					} else {
						ForEach(history.sorted(by: { $0.key > $1.key }), id: \.key) { key, progress in
							if let date = Habit.dateFormatter.date(from: key) {
								Text(
									"\(date, format: .dateTime.month().day().year()) – \(formatted(progress)) \(habit.category.unit)"
								)
								.font(.caption)
								.foregroundStyle(.secondary)
							}
						}
					}
				}
				
				Spacer()
			}
			.padding()
		}
		.onAppear {
			editedName = habit.name
			editedNotes = habit.notes ?? ""
		}
		.navigationTitle("Habit")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			
			// MARK: - Edit / Save
			ToolbarItem(placement: .topBarLeading) {
				if isEditing {
					Button("Cancel") {
						isEditing = false
					}
				}
			}
			
			ToolbarItem(placement: .topBarTrailing) {
				if isEditing {
					Button("Save") {
						vm.updateHabit(
							id: habit.id,
							name: editedName,
							notes: editedNotes.isEmpty ? nil : editedNotes
						)
						isEditing = false
					}
					.disabled(
						editedName.trimmingCharacters(in: .whitespaces).isEmpty ||
						!hasChanges
					)
				} else {
					Button("Edit") {
						editedName = habit.name
						editedNotes = habit.notes ?? ""
						isEditing = true
					}
				}
			}
			
			// MARK: - Bottom actions
			ToolbarItemGroup(placement: .bottomBar) {
				
				Button {
					vm.addProgress(
						for: habit,
						amount: habit.category.stepSize
					)
				} label: {
					Label(
						vm.isCompletedToday(habit) ? "Completed Today" : "Add Progress",
						systemImage: vm.isCompletedToday(habit)
						? "checkmark.circle.fill"
						: "plus.circle"
					)
				}
				.disabled(vm.isCompletedToday(habit))
				
				Spacer()
				
				Button(role: .destructive) {
					showDeletionConfirmation = true
				} label: {
					Label("Delete Habit", systemImage: "trash")
				}
			}
		}
		.alert("Delete Habit?", isPresented: $showDeletionConfirmation) {
			Button("Delete", role: .destructive) {
				vm.deleteHabit(id: habit.id)
				dismiss()
			}
			Button("Cancel", role: .cancel) { }
		} message: {
			Text("This action cannot be undone.")
		}
	}
	
	// MARK: - Formatting
	private func formatted(_ value: Double) -> String {
		habit?.category.unit == "liters"
		? String(format: "%.1f", value)
		: String(format: "%.0f", value)
	}
}

#Preview {
	NavigationStack {
		HabitDetailView(
			habitID: UUID(),
			vm: HabitListViewModel()
		)
	}
}

