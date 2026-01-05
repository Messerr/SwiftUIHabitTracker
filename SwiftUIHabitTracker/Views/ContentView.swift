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
				ForEach(vm.habits) { habit in
					HStack {
						Text(habit.name)
						
						Spacer()
						
						if vm.isCompletedToday(habit) {
							Image(systemName: "checkmark.circle.fill")
								.foregroundStyle(.green)
						}
					}
					.contentShape(Rectangle())
					.onTapGesture {
						vm.toggleToday(for: habit)
					}
				}
			}
			.navigationTitle("Habits")
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
