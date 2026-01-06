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
	@State private var selectedDate = Date()
	private var filteredHabits: some View {
		ForEach(vm.habitsScheduled(on: selectedDate)) { habit in
			NavigationLink {
				HabitProgressView(
					habitID: habit.id,
					vm: vm
				)
			} label: {
				HabitRowView(habit: habit)
			}
		}
	}
	
	var body: some View {
		NavigationStack {
			WeekStripView(
				selectedDate: $selectedDate,
				hasScheduledHabits: { date in
					!vm.habitsScheduled(on: date).isEmpty
				}
			)
			List {
				if vm.habits.isEmpty {
					ContentUnavailableView(
						"No Habits Yet",
						systemImage: "checklist",
						description: Text("Tap + to add your first habit")
					)
				}
				
				filteredHabits
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
				AddHabitView { notes, category, frequency, period, targetValue, weekdays in
					vm.addHabit(
						category: category,
						frequency: frequency,
						period: period,
						targetValue: targetValue,
						weekdays: weekdays,
						notes: notes
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


