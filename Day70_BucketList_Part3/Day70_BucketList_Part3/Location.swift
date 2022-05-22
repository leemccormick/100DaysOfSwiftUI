//
//  Location.swift
//  Day70_BucketList_Part3
//
//  Created by Lee McCormick on 5/21/22.
//

import Foundation
import CoreLocation
/*
 Where things get interesting is how we place locations on the map. We’ve bound the location of the map to a property in ContentView, but now we need to send in an array of locations we want to show.
 
 This takes a few steps, starting with a basic definition of the type of locations we’re creating in our app. This needs to conform to a few protocols:
 
 - Identifiable, so we can create many location markers in our map.
 - Codable, so we can load and save map data easily.
 - Equatable, so we can find one particular location in an array of locations.
 In terms of the data it will contain, we’ll give each location a name and description, plus a latitude and longitude. We’ll also need to add a unique identifier so SwiftUI is happy to create them from dynamic data.
 */

struct Location: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static let example = Location(id: UUID(), name: "Buckingham Palace", description: "Where Queen Elizabeth lives with her dorgis.", latitude: 51.501, longitude: -0.141) // The second change I want to make is one I encourage everyone to make when building custom data types for use with SwiftUI: add an example! This makes previewing significantly easier, so where possible I would encourage you to add a static example property to your types containing some sample data that can be previewed well.
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    } // The last change I’d like to make here is to add a custom == function to the struct. We already made Location conform to Equatable, which means we can already compare one location to another using ==. Behind the scenes, Swift will write this function for us by comparing every property against every other property, which is rather wasteful – all our locations already have a unique identifier, so if two locations have the same identifier then we can be sure they are the same without also checking the other properties.
}
