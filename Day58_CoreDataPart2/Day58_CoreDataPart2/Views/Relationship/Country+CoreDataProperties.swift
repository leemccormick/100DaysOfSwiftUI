//
//  Country+CoreDataProperties.swift
//  Day58_CoreDataPart2
//
//  Created by Lee McCormick on 5/9/22.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var fullName: String?
    @NSManaged public var shortName: String?
    @NSManaged public var candy: NSSet?
  
    public var wrappedShortName: String {
        shortName ?? "Unknown Country"
    }
    public var wrappedFullName: String {
        fullName ?? "Unknown Country"
    }
    
    public var candyArray: [Candy] {
        let set = candy as? Set<Candy> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
}

/* So, to get this thing into a useful form for SwiftUI we need to:
 
 Convert it from an NSSet to a Set<Candy> – a Swift-native type where we know the types of its contents.
 Convert that Set<Candy> into an array, so that ForEach can read individual values from there.
 Sort that array, so the candy bars come in a sensible order.
 Swift actually lets us perform steps 2 and 3 in one, because sorting a set automatically returns an array. However, sorting the array is harder than you might think: this is an array of custom types, so we can’t just use sorted() and let Swift figure it out. Instead, we need to provide a closure that accepts two candy bars and returns true if the first candy should be sorted before the second.
 */

// MARK: Generated accessors for candy
extension Country {

    @objc(addCandyObject:)
    @NSManaged public func addToCandy(_ value: Candy)

    @objc(removeCandyObject:)
    @NSManaged public func removeFromCandy(_ value: Candy)

    @objc(addCandy:)
    @NSManaged public func addToCandy(_ values: NSSet)

    @objc(removeCandy:)
    @NSManaged public func removeFromCandy(_ values: NSSet)
}

extension Country : Identifiable {

}
