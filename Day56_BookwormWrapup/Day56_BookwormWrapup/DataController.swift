//
//  DataController.swift
//  Day56_BookwormWrapup
//
//  Created by Lee McCormick on 4/24/22.
//

import Foundation
import CoreData

class DatatController: ObservableObject {
    let container = NSPersistentContainer(name: "Bookworm")
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load : \(error.localizedDescription)")
            }
        }
    }
}
