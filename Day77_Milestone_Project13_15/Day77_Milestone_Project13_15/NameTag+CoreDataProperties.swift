//
//  NameTag+CoreDataProperties.swift
//  Day77_Milestone_Project13_15
//
//  Created by Lee McCormick on 6/16/22.
//
//

import Foundation
import CoreData


extension NameTag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NameTag> {
        return NSFetchRequest<NameTag>(entityName: "NameTag")
    }

    @NSManaged public var name: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var image: Data?

}

extension NameTag : Identifiable {

}
