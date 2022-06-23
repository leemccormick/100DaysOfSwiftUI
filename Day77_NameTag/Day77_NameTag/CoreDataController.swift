//
//  CoreDataController.swift
//  Day77_NameTag
//
//  Created by Lee McCormick on 6/18/22.
//

import CoreData
import Foundation

class CoreDataController : ObservableObject {
    let container = NSPersistentContainer(name: "NameTag")
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load : \(error.localizedDescription)")
            }
        }
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
}
