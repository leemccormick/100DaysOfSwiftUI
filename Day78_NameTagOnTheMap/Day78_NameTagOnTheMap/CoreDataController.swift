//
//  CoreDataController.swift
//  Day78_NameTagOnTheMap
//
//  Created by Lee McCormick on 6/23/22.
//
import CoreData
import Foundation

class CoreDataController : ObservableObject {
    let container = NSPersistentContainer(name: "NameTagLocation")
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load : \(error.localizedDescription)")
            }
        }
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
}
