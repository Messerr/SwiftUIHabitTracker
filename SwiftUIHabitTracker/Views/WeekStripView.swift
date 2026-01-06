//
//  WeekStripView.swift
//  SwiftUIHabitTracker
//
//  Created by David Messer on 1/6/26.
//

import SwiftUI

struct WeekStripView: View {
	@Binding var selectedDate: Date
	let hasScheduledHabits: (Date) -> Bool
	
	private let calendar = Calendar.current
	
	var body: some View {
		let week = weekDates(for: selectedDate)
		
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 16) {
				ForEach(week, id: \.self) { date in
					DayCell(
						date: date,
						isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
						hasDot: hasScheduledHabits(date)
					)
					.onTapGesture {
						selectedDate = date
					}
				}
			}
			.padding(.horizontal)
			.padding(.vertical, 8)
		}
	}
	
	private func weekDates(for date: Date) -> [Date] {
		guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: date)?.start else {
			return []
		}
		
		return (0..<7).compactMap {
			calendar.date(byAdding: .day, value: $0, to: startOfWeek)
		}
	}
}


#Preview {
	PreviewWrapper()
}

private struct PreviewWrapper: View {
	@State private var selectedDate = Date()
	
	var body: some View {
		WeekStripView(
			selectedDate: $selectedDate,
			hasScheduledHabits: { _ in true }
		)
	}
}

