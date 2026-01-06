//
//  HabitProgressView.swift
//  SwiftUIHabitTracker
//
//  Created by David Messer on 1/5/26.
//

import SwiftUI

struct HabitProgressView: View {
	let habitID: UUID
	let vm: HabitListViewModel
	
	@State private var showEdit = false
	@Environment(\.dismiss) private var dismiss
	
	private var habit: Habit? {
		vm.habits.first(where: { $0.id == habitID })
	}
	
	var body: some View {
		if let habit {
			content(for: habit)
		} else {
			Text("Habit not found")
		}
	}
	
	@ViewBuilder
	private func content(for habit: Habit) -> some View {
		let progress = vm.progressValue(for: habit)
		let ratio = vm.progressRatio(for: habit)
		
		VStack(spacing: 32) {
			Text(habit.category.displayName)
				.font(.largeTitle)
				.fontWeight(.bold)
			
			Spacer()
			
			ZStack {
				Circle()
					.stroke(.gray.opacity(0.2), lineWidth: 20)
				
				Circle()
					.trim(from: 0, to: ratio)
					.stroke(.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round))
					.rotationEffect(.degrees(-90))
				
				Text(progressLabel(for: habit, progress: progress))
					.font(.title2)
					.fontWeight(.semibold)
			}
			.frame(width: 220, height: 220)
			.animation(.easeInOut, value: ratio)
			
			Spacer()
			
			HStack(spacing: 40) {
				Button {
					vm.addProgress(
						for: habit.id,
						amount: -habit.category.stepSize
					)
				} label: {
					Image(systemName: "minus.circle.fill")
						.font(.system(size: 44))
				}
				.disabled(progress <= 0)
				
				Button {
					vm.addProgress(
						for: habit.id,
						amount: habit.category.stepSize
					)
				} label: {
					Image(systemName: "plus.circle.fill")
						.font(.system(size: 44))
				}
			}
			
			Spacer()
		}
		.padding()
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Menu {
					Button("Edit") {
						showEdit = true
					}
					
					Button(role: .destructive) {
						vm.deleteHabit(id: habit.id)
						dismiss()
					} label: {
						Text("Delete")
					}
				} label: {
					Image(systemName: "ellipsis.circle")
				}
			}
		}
		.navigationDestination(isPresented: $showEdit) {
			HabitEditView(
				habitID: habit.id,
				vm: vm
			)
		}
	}
	
	private func progressLabel(for habit: Habit, progress: Double) -> String {
		let goal = habit.targetValue
		let unit = habit.category.unit
		
		if unit == "liters" {
			return String(format: "%.1f / %.1f %@", progress, goal, unit)
		} else {
			return String(format: "%.0f / %.0f %@", progress, goal, unit)
		}
	}
}

#Preview {
    HabitProgressView(
		habitID: UUID(),
		vm: HabitListViewModel()
	)
}
