//
//  AddHabitView.swift
//  SwiftUIHabitTracker
//
//  Created by David Messer on 1/5/26.
//

import SwiftUI

struct AddHabitView: View {
	@State private var name = ""
	@State private var notes = ""
	
	let onSave: (String, String?) -> Void
	@Environment(\.dismiss) private var dismiss
	
    var body: some View {
		NavigationStack {
			Form {
				TextField("Habit Name", text: $name)
				TextField("Notes (optional)", text: $notes)
			}
			.navigationTitle("New Habit")
			.toolbar {
				ToolbarItem(placement: .topBarTrailing) {
					Button("Save") {
						onSave(
							name,
							notes.isEmpty ? nil : notes
						)
						dismiss()
					}
					.disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
				}
				ToolbarItem(placement: .topBarLeading) {
					Button("Cancel") {
						dismiss()
					}
				}
			}
		}
    }
}

#Preview {
	AddHabitView { _, _ in

	}
}
