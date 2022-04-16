//
//  ExpenseItem.swift
//  Day38_iExpenseWrapup
//
//  Created by Lee McCormick on 4/7/22.
//

import Foundation

struct ExpeneseItem: Codable, Identifiable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
