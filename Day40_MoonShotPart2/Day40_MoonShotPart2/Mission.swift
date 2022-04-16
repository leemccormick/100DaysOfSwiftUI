//
//  Mission.swift
//  Day40_MoonShotPart2
//
//  Created by Lee McCormick on 4/10/22.
//

import Foundation


struct Mission: Codable, Identifiable {
    struct CrewRole: Codable {
        let name: String
        let role: String
    }
    
    let id: Int
    //  let launchDate: String?
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String
    var displayName: String {
        "Apollo \(id)"
    }
    
    var image: String {
        "apollo\(id)"
    }
    var formattedLaunchDate: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A" //That attempts to use an optional Date inside a text view, or replace it with “N/A” if the date is empty. This is another place where a computed property works better: we can ask the mission itself to provide a formatted launch date that converts the optional date into a neatly formatted string or sends back “N/A” for missing dates. This uses the same formatted() method we’ve used previously, so this should be somewhat familiar for you. Add this computed property to Mission now:
    }
}
