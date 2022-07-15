//
//  Resort.swift
//  Day97_SnowSeeker_Part2
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
    
    /* An example of shorter version code, which is same with code below.
    static let example = (Bundle.main.decode("resorts.json") as [Resort])[0] // Static let --> is the lazy. Not run until need it.
     */
    static let allResorts: [Resort] = Bundle.main.decode("resorts.json") // Load an array of resort from JSON stored
    static let example = allResorts[0]
}
