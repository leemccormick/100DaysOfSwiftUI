//
//  CoreDataController.swift
//  Day61_FriendFaceCoreData
//
//  Created by Lee McCormick on 5/14/22.
//

import Foundation
import CoreData

class CoreDataController : ObservableObject {
    let container = NSPersistentContainer(name: "FriendFace")
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load : \(error.localizedDescription)")
            }
        }
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
}
