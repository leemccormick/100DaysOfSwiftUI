//
//  Activity.swift
//  Day47_HabitTracking
//
//  Created by Lee McCormick on 4/17/22.
//

import Foundation

struct Activity : Identifiable, Codable, Equatable {
    var id = UUID()
    let name : String
    let description: String
    var countOfCompletion: Int = 0
}
