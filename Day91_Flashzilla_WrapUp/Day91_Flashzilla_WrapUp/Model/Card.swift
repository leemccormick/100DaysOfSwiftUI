//
//  Card.swift
//  Day91_Flashzilla_WrapUp
//
//  Created by Lee McCormick on 7/11/22.
//

import Foundation

// MARK: - Card
struct Card: Codable {
    let prompt: String
    let answer: String
    
    static let example = Card(prompt: "What is the capital of Thailand?", answer: "Bangkok")
}
