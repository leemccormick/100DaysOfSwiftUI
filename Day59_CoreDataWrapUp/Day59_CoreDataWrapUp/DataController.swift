//
//  DataController.swift
//  Day59_CoreDataWrapUp
//
//  Created by Lee McCormick on 5/9/22.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "CoreDataWrapUp")
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
            print("Core Data Failed to load : \(error.localizedDescription)")
            return
            }
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
}
