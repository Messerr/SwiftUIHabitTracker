//
//  ContentView.swift
//  SwiftUIHabitTracker
//
//  Created by David Messer on 1/4/26.
//

import SwiftUI

struct ContentView: View {
	@State private var vm = HabitListViewModel()
	@State private var showingAddHabit: Bool = false
	
    var body: some View {
		NavigationStack {
			List {
				if vm.habits.isEmpty {
					ContentUnavailableView(
						"No Habits Yet",
						systemImage: "checklist",
						description: Text("Tap + to add your first habit")
					)
				}
				ForEach(vm.habits) { habit in
					NavigationLink {
						HabitDetailView(
							habitID: habit.id,
							vm: vm
						)
					} label: {
						HabitRowView(
							habit: habit,
							isCompletedToday: vm.isCompletedToday(habit),
							streak: vm.currentStreak(for: habit),
							onToggle: {
								vm.toggleToday(for: habit)
							}
						)
					}
					.swipeActions(edge: .trailing) {
						Button {
							vm.toggleToday(for: habit)
						} label: {
							Label(
								vm.isCompletedToday(habit) ? "Undo" : "Complete",
								systemImage: vm.isCompletedToday(habit)
								? "arrow.uturn.left"
								: "checkmark"
							)
						}
						.tint(vm.isCompletedToday(habit) ? .orange : .green)
					}
				}
			}
			.navigationTitle("Habits")
			.navigationBarTitleDisplayMode(.large)
			.sheet(isPresented: $showingAddHabit) {
				AddHabitView { name, notes in
					vm.addHabit(name: name, notes: notes)
					showingAddHabit = false
				}
			}
			.toolbar {
				Button {
					showingAddHabit = true
				} label: {
					Image(systemName: "plus")
				}
			}
		}
    }
}

#Preview {
    ContentView()
}
