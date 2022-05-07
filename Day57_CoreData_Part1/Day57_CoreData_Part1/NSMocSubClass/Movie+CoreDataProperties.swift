//
//  Movie+CoreDataProperties.swift
//  Day57_CoreData_Part1
//
//  Created by Lee McCormick on 5/7/22.
//
//

import Foundation
import CoreData // CoreData is lazy, lazy load when you need it.


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }
    /*
     In that tiny slice of code you can see three things:

     1. This is where our optional problem stems from.
     2. year is not optional, which means Core Data will assume a default value for us.
     3. It uses @NSManaged on all three properties.

     However, you might notice something strange: even though our properties aren’t optional any more, it’s still possible to create an instance of the Movie class without providing those values. This ought to be impossible: these properties aren’t optional, which means they must have values all the time, and yet we can create them without values.

     What’s happening here is a little of that @NSManaged magic leaking out – remember, these aren’t real properties, and as a result @NSManaged is letting us do things that ought not to work. The fact that it does work is neat, and for small Core Data projects and/or learners I think removing the optionality is a great idea. However, there’s a deeper problem: Core Data is lazy.

     Remember Swift’s lazy keyword, and how it lets us delay work until we actually need it? Core Data does much the same thing, except with data: sometimes it looks like some data has been loaded when it really hasn’t been because Core Data is trying to minimize its memory impact. Core Data calls these faults, in the sense of a “fault line” – a line between where something exists and where something is just a placeholder.
     */
    @NSManaged public var title: String?
    @NSManaged public var director: String? // You can delete the optional, but CoreData still make this varible optional
    @NSManaged public var year: Int16
    
    public var wrappedTittle: String { // Instead, you might want to consider adding computed properties that help us access the optional values safely, while also letting us store your nil coalescing code all in one place. For example, adding this as a property on Movie ensures that we always have a valid title string to work with:
        title ?? "Unknown Title"
    }
}

extension Movie : Identifiable {

}
