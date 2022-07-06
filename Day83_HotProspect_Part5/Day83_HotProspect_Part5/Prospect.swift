//
//  Prospect.swift
//  Day83_HotProspect_Part5
//
//  Created by Lee McCormick on 7/2/22.
//

import Foundation

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false // Swift can help us mitigate this problem by stopping us from modifying the Boolean outside of Prospects.swift. There’s a specific access control option called fileprivate, which means “this property can only be used by code inside the current file.” Of course, we still want to read that property, and so we can deploy another useful Swift feature: fileprivate(set), which means “this property can be read from anywhere, but only written from the current file” – the exact combination we need to make sure the Boolean is safe to use. So, modify the isContacted Boolean in Prospect to this:
}

@MainActor class Prospects: ObservableObject {
    @Published var people: [Prospect]
    
    init() {
        self.people = []
    }
    
    /*
     While the text for that is OK and the context menu displays correctly, the action doesn’t do anything. Well, that’s not strictly true: it does toggle the Boolean, but it doesn’t actually update the UI.
     
     This problem occurs because the people array in Prospects is marked with @Published, which means if we add or remove items from that array a change notification will be sent out. However, if we quietly change an item inside the array then SwiftUI won’t detect that change, and no views will be refreshed.
     
     To fix this, we need to tell SwiftUI by hand that something important has changed. So, rather than flipping a Boolean in ProspectsView, we are instead going to call a method on the Prospects class to flip that same Boolean while also sending a change notification out.
     
     Start by adding this method to the Prospects class:
     */
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send() //Important: You should call objectWillChange.send() before changing your property, to ensure SwiftUI gets its animations correct. Now you can replace the prospect.isContacted.toggle() action with this:
        prospect.isContacted.toggle()
    }
}
