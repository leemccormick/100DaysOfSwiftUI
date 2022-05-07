//
//  UniqueObjectView.swift
//  Day57_CoreData_Part1
//
//  Created by Lee McCormick on 5/7/22.
//

import SwiftUI

struct UniqueObjectView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var wizards: FetchedResults<Wizard>
    let uniqueInfo =
    """
    To help resolve this, Core Data gives us constraints: we can make one attribute constrained so that it must always be unique. We can then go ahead and make as many objects as we want, unique or otherwise, but as soon as we ask Core Data to save those objects it will resolve duplicates so that only one piece of data gets written. Even better, if there was some data already written that clashes with our constraint, we can choose how it should handle merging the data.
    To try this out, create a new entity called Wizard, with one string attribute called “name”. Now select the Wizard entity, look in the data model inspector for Constraints, and press the + button directly below. You should see “comma,separated,properties” appear, giving us an example to work from. Select that and press enter to rename it, and give it the text “name” instead – that makes our name attribute unique. Remember to press Cmd+S to save your change!
    You can see that has a list for showing wizards, one button for adding wizards, and a second button for saving. When you run the app you’ll find that you can press Add multiple times to see “Harry Potter” slide into the table, but when you press “Save” we get an error instead – Core Data has detected the collision and is refusing to save the changes.
    If you want Core Data to write the changes, you need to open DataController.swift and adjust the loadPersistentStores() completion handler to specify how data should be merged in this situation:
    That asks Core Data to merge duplicate objects based on their properties – it tries to intelligently overwrite the version in its database using properties from the new version. If you run the code again you’ll see something quite brilliant: you can press Add as many times as you want, but when you press Save it will all collapse down into a single row because Core Data strips out the duplicates.
"""
    
    var body: some View {
        Form {
            Text("Ensuring Core Data Object are unique using constraints.")
                .font(.title.bold())
            List(wizards, id: \.self) { wizard in
                Text(wizard.name ?? "Unknown")
            }
            Button("Add") {
                let wizard = Wizard(context: moc)
                wizard.name = "Harry Potter"
            }
            Button("Save") {
                do {
                    try moc.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
            NavigationLink {
                ScrollView {
                    Text(uniqueInfo)
                }
            } label: {
                Text("How to ensuring Core Data Object are unique using constraints.")
            }
        }
    }
}

struct UniqueObjectView_Previews: PreviewProvider {
    static var previews: some View {
        UniqueObjectView()
    }
}
