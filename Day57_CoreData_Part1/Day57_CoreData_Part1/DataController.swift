//
//  DataController.swift
//  Day57_CoreData_Part1
//
//  Created by Lee McCormick on 5/7/22.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Day57CoreData")
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data Failed to load : \(error.localizedDescription)")
                return
            }
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump // That asks Core Data to merge duplicate objects based on their properties – it tries to intelligently overwrite the version in its database using properties from the new version. If you run the code again you’ll see something quite brilliant: you can press Add as many times as you want, but when you press Save it will all collapse down into a single row because Core Data strips out the duplicates.
        }
    }
}
