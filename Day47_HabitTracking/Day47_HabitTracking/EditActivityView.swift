//
//  EditActivityView.swift
//  Day47_HabitTracking
//
//  Created by Lee McCormick on 4/17/22.
//

import SwiftUI

struct EditActivityView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var habit: Habit
    var selectedIndex: Int
    
    var body: some View {
        NavigationView {
            Form {
                Text("Name : \(habit.actions[selectedIndex].name)")
                Text("Description : \n\(habit.actions[selectedIndex].description)")
                Stepper("Time of Completion \( habit.actions[selectedIndex].countOfCompletion)", value: $habit.actions[selectedIndex].countOfCompletion, step: 1)
            }
            .navigationTitle("Update Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Save") {
                    let count = habit.actions[selectedIndex].countOfCompletion
                    habit.actions[selectedIndex].countOfCompletion = count
                    
                    dismiss()
                }
            }
        }
    }
}

struct EditActivityView_Previews: PreviewProvider {
    static var previews: some View {
        EditActivityView(habit: Habit(), selectedIndex: 0)
    }
}
