//
//  ContentView.swift
//  SwiftUIHabitTracker
//
//  Created by David Messer on 1/4/26.
//

import SwiftUI

struct ContentView: View {
	@State private var vm = HabitListViewModel()
	@State private var showingAddHabit = false
	
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
							progressToday: vm.progressToday(for: habit),
							isCompletedToday: vm.isCompletedToday(habit),
							streak: vm.currentStreak(for: habit),
							onAddProgress: {
								vm.addProgress(
									for: habit,
									amount: habit.category.stepSize
								)
							}
						)
					}
				}
			}
			.navigationTitle("Habits")
			.navigationBarTitleDisplayMode(.large)
			.toolbar {
				Button {
					showingAddHabit = true
				} label: {
					Image(systemName: "plus")
				}
			}
			.sheet(isPresented: $showingAddHabit) {
				AddHabitView { category, name, notes, dailyGoal in
					vm.addHabit(
						category: category,
						name: name,
						notes: notes,
						dailyGoal: dailyGoal
					)
					showingAddHabit = false
				}
			}
		}
	}
}

#Preview {
	ContentView()
}

