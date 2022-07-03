//
//  Prospect.swift
//  Day82_HotProspects_Part4
//
//  Created by Lee McCormick on 7/2/22.
//

import Foundation

// Yes, that’s a class rather than a struct. This is intentional, because it allows us to change instances of the class directly and have it be updated in all other views at the same time. Remember, SwiftUI takes care of propagating that change to our views automatically, so there’s no risk of views getting stale.
class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var isContacted = false
}

// When it comes to sharing that across multiple views, one of the best things about SwiftUI’s environment is that it uses the same ObservableObject protocol we’ve been using with the @StateObject property wrapper. This means we can mark properties that should be announced using the @Published property wrapper – SwiftUI takes care of most of the work for us
@MainActor class Prospects: ObservableObject {
    @Published var people: [Prospect]
    
    init() {
        self.people = []
    }
}
