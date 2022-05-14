//
//  CachedFriend+CoreDataProperties.swift
//  Day61_FriendFaceCoreData
//
//  Created by Lee McCormick on 5/14/22.
//
//

import Foundation
import CoreData


extension CachedFriend {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedFriend> {
        return NSFetchRequest<CachedFriend>(entityName: "CachedFriend")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var ofUser: CachedUser?
    
    public var wrappedId : String {
        id ?? "Unknown"
    }

    public var wrappedName : String {
        name ?? "Unknown"
    }
}

extension CachedFriend : Identifiable {

}
