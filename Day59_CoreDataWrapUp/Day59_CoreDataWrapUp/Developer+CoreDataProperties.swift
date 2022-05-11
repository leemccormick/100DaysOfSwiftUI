//
//  Developer+CoreDataProperties.swift
//  Day59_CoreDataWrapUp
//
//  Created by Lee McCormick on 5/9/22.
//
//

import Foundation
import CoreData

extension Developer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Developer> {
        return NSFetchRequest<Developer>(entityName: "Developer")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    
    var wrappedFirstName : String {
        firstName ?? "Unknown"
    }
    
    var wrappedLastName : String {
        lastName ?? "Unknown"
    }
}

extension Developer : Identifiable {

}
