//
//  Favorites.swift
//  Day99_SnowSeeker_WrapUp
//
//  Created by Lee McCormick on 7/15/22.
//

import Foundation

// MARK: - Favorites
class Favorites : ObservableObject {
    private var resorts: Set<String>
    private let saveKey = "Favorites"
    
    init() {
        resorts = []
        //  Challenge 2 : Fill in the loading methods for Favorites.
        if let stringArray = UserDefaults.standard.stringArray(forKey: saveKey) {
            resorts = Set(stringArray)
        }
    }
    
    func contain(_ report: Resort) -> Bool {
        resorts.contains(report.id)
    }
    
    func add(_ report: Resort) {
        objectWillChange.send()
        resorts.insert(report.id)
        save()
    }
    
    func remove(_ report: Resort) {
        objectWillChange.send()
        resorts.remove(report.id)
    }
    
    func save() {
        //  Challenge 2 : Fill in the saving methods for Favorites.
        UserDefaults.standard.set(Array(resorts), forKey: saveKey)
    }
}
