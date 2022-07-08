//
//  Prospects.swift
//  Day84_HotProspects_Part6
//
//  Created by Lee McCormick on 7/6/22.
//

import Foundation

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}

/*
 This time our data is stored using a slightly easier format: although the Prospects class uses the @Published property wrapper, the people array inside it is simple enough that it already conforms to Codable just by adding the protocol conformance. So, we can get most of the way to our goal by making three small changes:
 
 1) Updating the Prospects initializer so that it loads its data from UserDefaults where possible.
 2) Adding a save() method to the same class, writing the current data to UserDefaults.
 3) Calling save() when adding a prospect or toggling its isContacted property.
 */

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect] // This helps lock down our code so that we can’t make mistakes by accident – the compiler simply won’t allow it. In fact, if you try building the code now you’ll see exactly what I mean: ProspectsView tries to append to the people array and call save(), which is no longer allowed.
    let saveKey = "SaveData"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                people = decoded
                return
            }
        }
        people = []
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    /*
     - We’ve had to hard-code the key name “SavedData” in two places, which again might cause problems in the future if the name changes or needs to be used in more places.
     - Having to call save() inside ProspectsView isn’t good design, partly because our view really shouldn’t know about the internal workings of its model, but also because if we have other views working with the data then we might forget to call save() there.
     */
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}
