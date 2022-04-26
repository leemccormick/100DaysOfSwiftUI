//
//  DataController.swift
//  Day55_Bookwarm_Part3
//
//  Created by Lee McCormick on 4/24/22.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Bookworm")
    init() {
        container.loadPersistentStores { description, error in
            if let error = error  {
                print("Core Data failed to load : \(error.localizedDescription)")
            }
        }
    }
}
