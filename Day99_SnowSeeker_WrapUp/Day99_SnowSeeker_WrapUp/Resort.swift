//
//  Resort.swift
//  Day99_SnowSeeker_WrapUp
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
    
    var facilityType: [Facility] {
        facilities.map(Facility.init)
    }
    
    static let example = (Bundle.main.decoded("resorts.json") as [Resort])[0]
}

