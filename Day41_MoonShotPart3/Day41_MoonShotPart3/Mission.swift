//
//  Mission.swift
//  Day41_MoonShotPart3
//
//  Created by Lee McCormick on 4/11/22.
//

import Foundation

struct Mission: Codable, Identifiable {
    struct CrewRow: Codable {
        let name: String
        let role: String
    }
    let id: Int
    let launchDate: Date?
    let crew: [CrewRow]
    let description: String
    var displayName: String {
        "Apollo \(id)"
    }
    var image: String {
        "apollo\(id)"
    }
    var formattedLunchDate: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
}
