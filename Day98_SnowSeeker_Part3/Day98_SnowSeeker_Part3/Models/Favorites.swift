//
//  Favorites.swift
//  Day98_SnowSeeker_Part3
//
//  Created by Lee McCormick on 7/15/22.
//

import Foundation

/*
 The final task for this project is to let the user assign favorites to resorts they like. This is mostly straightforward, using techniques we’ve already covered:
 
 - Creating a new Favorites class that has a Set of resort IDs the user likes.
 - Giving it add(), remove(), and contains() methods that manipulate the data, sending update notifications to SwiftUI while also saving any changes to UserDefaults.
 - Injecting an instance of the Favorites class into the environment.
 - Adding some new UI to call the appropriate methods.
 */

class Favorites: ObservableObject {
    private var resorts: Set<String> // The actual resorts the user has favorited
    private let saveKey = "Favorites" // The key we're using to read / write in UserDefaults
    
    init() {
        // load our saved data
        
        // still here? User an emptry array
        resorts = []
    }
    
    // Return true if our set contains this resort
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    // Adds the resort to our set, updates all views, and saves the change
    func add(_ resort: Resort) {
        objectWillChange.send() // Swift’s sets already contain methods for adding, removing, and checking for an element, but we’re going to add our own around them so we can use objectWillChange to notify SwiftUI that changes occurred, and also call a save() method so the user’s changes are persisted. This in turn means we can mark the favorites set using private access control, so we can’t accidentally bypass our methods and miss out saving.
        resorts.insert(resort.id)
        save()
    }
    
    // Removes the resort from our set, updates all views, and saves the change
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
    }
    
    func save() {
        // Write out our data
    }
}
