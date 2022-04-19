//
//  ContentView.swift
//  Day47_HabitTracking
//
//  Created by Lee McCormick on 4/17/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var habit = Habit()
    @State private var showingAddActivityView = false
    
    var body: some View {
        NavigationView {
            Form {
                ForEach (habit.actions) { a in
                    NavigationLink {
                        if let i = habit.actions.firstIndex(of: a) {
                            EditActivityView(habit: habit, selectedIndex: i)
                        }
                    } label: {
                        VStack {
                        Text(a.name)
                            .font(.headline.bold())
                        Text("Completion \(a.countOfCompletion) times." )
                            .font(.headline)
                            .foregroundColor(a.countOfCompletion == 0 ? .red : .green)
                        }
                    }
                }
            }
            .navigationTitle("Habit Tracking")
            .toolbar {
                Button() {
                    showingAddActivityView = true
                } label : {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddActivityView) {
            AddActivityView(habit: habit)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
