//
//  Expense.swift
//  Day38_iExpenseWrapup
//
//  Created by Lee McCormick on 4/7/22.
//

import Foundation

class Expense : ObservableObject {
    @Published var items = [ExpeneseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "items") {
            if let decoded = try? JSONDecoder().decode([ExpeneseItem].self, from: savedItems) {
                items = decoded
            }
        }
        items = []
    }
}
