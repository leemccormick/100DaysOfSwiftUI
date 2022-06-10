//
//  Expense.swift
//  Day76_Accessibility_WrapUp
//
//  Created by Lee McCormick on 6/9/22.
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
