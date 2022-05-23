//
//  Result.swift
//  Day71_BucketList_Part4
//
//  Created by Lee McCormick on 5/22/22.
//

import Foundation
/*
 Wikipedia’s API sends back JSON data in a precise format, so we need to do a little work to define Codable structs capable of storing it all. The structure is this:
 
 - The main result contains the result of our query in a key called “query”.
 - Inside the query is a “pages” dictionary, with page IDs as the key and the Wikipedia pages themselves as values.
 - Each page has a lot of information, including its coordinates, title, terms, and more.
 */
struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int : Page]
}

struct Page: Codable, Comparable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    // We don’t want this mess to plague our SwiftUI code, so again the best thing to do is make a computed property that returns the description if it exists, or a fixed string otherwise. Add this to the Page struct to finish it off:
    var description: String {
        terms?["description"]?.first ?? "No further information"
    }
    
    // If you recall, conforming to Comparable has only a single requirement: we must implement a < function that accepts two parameters of the type of our struct, and returns true if the first should be sorted before the second. In this case we can just pass the test directly onto the title strings, so add this method to the Page struct now:
    static func<(lhs: Page, rhs:Page) -> Bool {
        lhs.title < rhs.title
    }
}
