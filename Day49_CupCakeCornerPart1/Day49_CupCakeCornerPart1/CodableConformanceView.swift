//
//  CodableConformanceView.swift
//  Day49_CupCakeCornerPart1
//
//  Created by Lee McCormick on 4/19/22.
//

import SwiftUI

class User: ObservableObject, Codable {
    // None of those steps are terribly hard, so let’s just dive in with the first one: telling Swift which properties should be loaded and saved. This is done using an enum that conforms to a special protocol called CodingKey, which means that every case in our enum is the name of a property we want to load and save. This enum is conventionally called CodingKeys, with an S on the end, but you can call it something else if you want.
    enum CodingKeys: CodingKey {
        case name
    }
    
    @Published var name = "Paul Hudson" //Swift already has rules in place that say if an array contains Codable types then the whole array is Codable, and the same for dictionaries and sets. However, SwiftUI doesn’t provide the same functionality for its Published struct – it has no rule saying “if the published object is Codable, then the published struct itself is also Codable.” As a result, we need to make the type conform ourselves: we need to tell Swift which properties should be loaded and saved, and how to do both of those actions.
    
    
    // Anyone who subclasses our User class must override this initializer with a custom implementation to make sure they add their own values. We mark this using the required keyword: required init. An alternative is to mark this class as final so that subclassing isn’t allowed, in which case we’d write final class User and drop the required keyword entirely.
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self) // This means “this data should have a container where the keys match whatever cases we have in our CodingKeys enum.
        name = try container.decode(String.self, forKey: .name) //This provides really strong safety in two ways: we’re making it clear we expect to read a string, so if name gets changed to an integer the code will stop compiling; and we’re also using a case in our CodingKeys enum rather than a string, so there’s no chance of typos.
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
    }
}

struct CodableConformanceView: View {
    var body: some View {
        Text("Hello, Codable User ! \nAdding Codable conformance for @Published properties")
            .font(.headline.bold())
    }
}

struct CodableConformanceView_Previews: PreviewProvider {
    static var previews: some View {
        CodableConformanceView()
    }
}
