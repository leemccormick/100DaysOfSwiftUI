//
//  Dice.swift
//  Day95_RollDice
//
//  Created by Lee McCormick on 7/13/22.
//

import Foundation

// MARK: - DiceData Struct
struct DiceData : Codable, Identifiable {
    var id = UUID()
    var dateTime : Date = Date()
    let points: Int
    let sides: Int
}

// MARK: - RollingDiceState
enum RollingDiceState {
    case shakeDice, showPointText, showDiceView
}

// MARK: - Dice Enum
enum Dice : String, CaseIterable, Identifiable {
    case sideOf4 = "4"
    case sideOf6 = "6"
    case sideOf8 = "8"
    case sideOf10 = "10"
    case sideOf12 = "12"
    case sideOf20 = "20"
    case sideOf100 = "100"
    
    var id: String { self.rawValue }
    
    var title : String {
        switch self {
        case .sideOf4:
            return "Side Of 4"
        case .sideOf6:
            return "Side Of 6"
        case .sideOf8:
            return "Side Of 8"
        case .sideOf10:
            return "Side Of 10"
        case .sideOf12:
            return "Side Of 12"
        case .sideOf20:
            return "Side Of 20"
        case .sideOf100:
            return "Side Of 100"
        }
    }
    
    var sides : Int {
        switch self {
        case .sideOf4:
            return 4
        case .sideOf6:
            return 6
        case .sideOf8:
            return 8
        case .sideOf10:
            return 10
        case .sideOf12:
            return 12
        case .sideOf20:
            return 20
        case .sideOf100:
            return 100
        }
    }
}
