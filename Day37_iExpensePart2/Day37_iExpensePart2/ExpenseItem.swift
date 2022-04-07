//
//  ExpenseItem.swift
//  Day37_iExpensePart2
//
//  Created by Lee McCormick on 4/6/22.
//

import Foundation

struct ExpenseItem : Identifiable, Codable {
    // let id = UUID() // However, you will see a warning that id will not be decoded because we made it a constant and assigned a default value. This is actually the behavior we want, but Swift is trying to be helpful because it’s possible you did plan to decode this value from JSON. To make the warning go away, make the property variable like this:
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
