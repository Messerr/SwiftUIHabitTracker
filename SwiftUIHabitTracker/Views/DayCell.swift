//
//  DayCell.swift
//  SwiftUIHabitTracker
//
//  Created by David Messer on 1/6/26.
//

import SwiftUI

struct DayCell: View {
	let date: Date
	let isSelected: Bool
	let hasDot: Bool
	
	private let calendar = Calendar.current
	
	private var isToday: Bool {
		calendar.isDateInToday(date)
	}
	
	var body: some View {
		VStack(spacing: 4) {
			Text(monthString)
				.font(.caption2)
				.foregroundStyle(.secondary)
			
			ZStack {
				if isToday && !isSelected {
					Circle()
						.stroke(Color.blue.opacity(0.5), lineWidth: 1.5)
						.frame(width: 36, height: 36)
				}
				
				Text(dayString)
					.font(.headline)
					.frame(width: 36, height: 36)
					.background(
						isSelected ? Color.blue : Color.clear
					)
					.foregroundStyle(isSelected ? .white : .primary)
					.clipShape(Circle())
			}
			
			if hasDot {
				Circle()
					.fill(isSelected ? Color.blue : Color.secondary)
					.frame(width: 6, height: 6)
			} else {
				Spacer()
					.frame(height: 6)
			}
		}
	}
	
	private var dayString: String {
		String(calendar.component(.day, from: date))
	}
	
	private var monthString: String {
		let formatter = DateFormatter()
		formatter.dateFormat = "MMM"
		return formatter.string(from: date).uppercased()
	}
}


#Preview {
    DayCell(
		date: Date(),
		isSelected: true,
		hasDot: true
	)
}
