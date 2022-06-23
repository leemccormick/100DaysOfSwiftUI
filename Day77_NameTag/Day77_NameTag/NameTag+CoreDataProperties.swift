//
//  NameTag+CoreDataProperties.swift
//  Day77_NameTag
//
//  Created by Lee McCormick on 6/18/22.
//
//

import Foundation
import CoreData


extension NameTag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NameTag> {
        return NSFetchRequest<NameTag>(entityName: "NameTag")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var path: String?
   
    public var wrappedId : UUID {
        id ?? UUID()
    }
    
    public var wrappedName : String {
        name ?? "Unknown Name"
    }
    
    public var wrappedIdString : String {
        wrappedId.uuidString
    }
    
    public var wrappedPath : String {
       path ?? "Unknown Path"
    }
}

extension NameTag : Identifiable {

}
