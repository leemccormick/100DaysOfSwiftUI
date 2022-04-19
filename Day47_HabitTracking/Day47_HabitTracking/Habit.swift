//
//  Activities.swift
//  Day47_HabitTracking
//
//  Created by Lee McCormick on 4/17/22.
//

import Foundation

class Habit : ObservableObject {
    @Published var actions = [Activity]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(actions) {
                UserDefaults.standard.set(encoded, forKey: "actions")
            }
        }
    }
    
    init() {
        if let savedActions = UserDefaults.standard.data(forKey: "actions") {
            if let decoded = try? JSONDecoder().decode([Activity].self, from: savedActions) {
                actions = decoded
                return
            }
        }
        actions = []
    }
}
