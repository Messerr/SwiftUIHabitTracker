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
	
	private func isCompletedToday(_ habit: Habit) -> Bool {
		vm.isCompletedToday(habit)
	}
	
	var body: some View {
		if let habit {
			detailContent(for: habit)
		} else {
			Text("Habit not found")
		}
	}
	
	@ViewBuilder
	private func detailContent(for habit: Habit) -> some View {
		let hasChanges =
		editedName != habit.name ||
		editedNotes != (habit.notes ?? "")
		
		ScrollView {
			VStack(alignment: .leading, spacing: 16) {
				
				if isEditing {
					TextField("Habit name", text: $editedName)
						.font(.largeTitle)
						.fontWeight(.bold)
				} else {
					Text(habit.name)
						.font(.largeTitle)
						.fontWeight(.bold)
				}

				
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
				
				VStack(alignment: .leading, spacing: 8) {
					Text("Completion History")
						.font(.headline)
					
					if habit.completedDates.isEmpty {
						Text("No completions yet")
							.foregroundStyle(.secondary)
					} else {
						ForEach(habit.completedDates.sorted(by: >), id: \.self) { date in
							Text(date, format: .dateTime.month().day().year())
								.font(.caption)
								.foregroundStyle(.secondary)
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
			ToolbarItem(placement: .topBarLeading) {
				if isEditing {
					Button("Cancel") {
						isEditing = false
					}
				}
			}
			ToolbarItem {
				if isEditing {
					Button("Save") {
						vm.updateHabit(
							id: habit.id,
							name: editedName,
							notes: editedNotes.isEmpty ? nil : editedNotes
						)
						isEditing = false
					}
					.disabled(editedName.trimmingCharacters(in: .whitespaces).isEmpty || !hasChanges)
				} else {
					Button("Edit") {
						editedName = habit.name
						editedNotes = habit.notes ?? ""
						isEditing = true
					}
				}
			}
		}
		.toolbar {
			ToolbarItemGroup(placement: .bottomBar) {
				Button {
					vm.toggleToday(for: habit)
				} label: {
					Label(
						isCompletedToday(habit) ? "Undo Today" : "Complete Today",
						systemImage: isCompletedToday(habit)
						? "arrow.uturn.left"
						: "checkmark.circle.fill"
					)
				}
				
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
}

#Preview {
	NavigationStack {
		HabitDetailView(
			habitID: UUID(),
			vm: HabitListViewModel()
		)
	}
}
