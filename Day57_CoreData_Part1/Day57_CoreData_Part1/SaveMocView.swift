//
//  SaveMocView.swift
//  Day57_CoreData_Part1
//
//  Created by Lee McCormick on 5/7/22.
//

import SwiftUI

struct SaveMocView: View {
    @Environment(\.managedObjectContext) var moc
    var body: some View {
        Form {
            Text("Conditional saving of NSManagedObjectContext")
                .font(.headline.bold())
            Button("Save") { // Fortunately, we can check for changes in two ways. First, every managed object is given a hasChanges property, that is true when the object has unsaved changes. And, the entire context also contains a hasChanges property that checks whether any object owned by the context has changes.
                if moc.hasChanges {
                    try? moc.save()
                }
            }
            Text("Fortunately, we can check for changes in two ways. First, every managed object is given a hasChanges property, that is true when the object has unsaved changes. And, the entire context also contains a hasChanges property that checks whether any object owned by the context has changes. if moc.hasChanges try? moc.save()")
        }
    }
}

struct SaveMocView_Previews: PreviewProvider {
    static var previews: some View {
        SaveMocView()
    }
}
