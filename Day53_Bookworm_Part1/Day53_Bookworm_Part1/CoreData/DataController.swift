//
//  DataController.swift
//  Day53_Bookworm_Part1
//
//  Created by Lee McCormick on 4/24/22.
//

import CoreData
import Foundation

// We’re going to start by creating a new class called DataController, making it conform to ObservableObject so that we can use it with the @StateObject property wrapper – we want to create one of these when our app launches, then keep it alive for as long as our app runs. Inside this class we’ll add a single property of the type NSPersistentContainer, which is the Core Data type responsible for loading a data model and giving us access to the data inside. From a modern point of view this sounds strange, but the “NS” part is short for “NeXTSTEP”, which was a huge operating system that Apple acquired when they brought Steve Jobs back into the fold in 1997 – Core Data has some really old foundations!
class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Bookworm")
    
    init() { // To actually load the data model we need to call loadPersistentStores() on our container, which tells Core Data to access our saved data according to the data model in Bookworm.xcdatamodeld. This doesn’t load all the data into memory at the same time, because that would be wasteful, but at least Core Data can see all the information we have.
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load : \(error.localizedDescription)")
            }
        }
    }
}
