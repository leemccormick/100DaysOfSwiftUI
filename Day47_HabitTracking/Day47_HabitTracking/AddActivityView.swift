//
//  AddActivityView.swift
//  Day47_HabitTracking
//
//  Created by Lee McCormick on 4/17/22.
//

import SwiftUI

struct AddActivityView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var habit: Habit
    @State private var name = ""
    @State private var description = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Activity Name", text: $name)
                    .keyboardType(.default)
                TextField("Activity Description", text: $description)
                    .frame(height: 200, alignment: .leading)
                    .keyboardType(.default)
            }
            .navigationTitle("Add New Activity")
            .toolbar {
                Button("Save") {
                    let newActivity = Activity(name: name, description: description)
                    habit.actions.append(newActivity)
                    dismiss()
                }
            }
        }
    }
}

struct AddActivityView_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityView(habit: Habit())
    }
}
