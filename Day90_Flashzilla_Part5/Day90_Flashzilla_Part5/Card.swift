//
//  Card.swift
//  Day90_Flashzilla_Part5
//
//  Created by Lee McCormick on 7/11/22.
//

import Foundation

struct Card: Codable {
    let prompt: String
    let answer: String
    
    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}


