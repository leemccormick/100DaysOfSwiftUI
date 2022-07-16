//
//  Resort.swift
//  Day98_SnowSeeker_Part3
//
//  Created by Lee McCormick on 7/15/22.
//

import Foundation

// MARK: - Resort
struct Resort: Codable, Identifiable {
    let id: String
    let name: String
    let country: String
    let description: String
    let imageCredit: String
    let price: Int
    let size: Int
    let snowDepth: Int
    let elevation: Int
    let runs: Int
    let facilities: [String]
    
    // The next step is to create Facility instances for every of the facilities in a Resort, which we can do in a computed property inside the Resort struct itself:
    var facilityType: [Facility] {
        facilities.map(Facility.init)
    }
    
    static let allResorts : [Resort] = Bundle.main.decode("resorts.json")
    static let example = allResorts[0]
}

