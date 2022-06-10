//
//  Mission.swift
//  Day76_Accessibility_WrapUp
//
//  Created by Lee McCormick on 6/9/22.
//

import Foundation

struct Mission : Codable, Identifiable {
    struct CrewRole : Codable {
        let name: String
        let role: String
    }
    let id: Int
    let launchDate : Date?
    let crew: [CrewRole]
    let description: String
    var displayName : String {
        "Apollo \(id)"
    }
    var image: String {
        "apollo\(id)"
    }
    var formattedLunchDate: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
    var formattedLunchDateComplete: String {
        launchDate?.formatted(date: .complete, time: .omitted) ?? "N/A"
    }
}
