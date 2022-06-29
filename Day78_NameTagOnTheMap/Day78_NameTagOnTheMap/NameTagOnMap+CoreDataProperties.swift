//
//  NameTagOnMap+CoreDataProperties.swift
//  Day78_NameTagOnTheMap
//
//  Created by Lee McCormick on 6/23/22.
//
//

import Foundation
import CoreData
import CoreLocation

extension NameTagOnMap {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<NameTagOnMap> {
        return NSFetchRequest<NameTagOnMap>(entityName: "NameTagOnMap")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
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
    
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension NameTagOnMap : Identifiable {
    
}
