//
//  CoreDataView.swift
//  Day53_Bookworm_Part1
//
//  Created by Lee McCormick on 4/23/22.
//

import SwiftUI

/* // Using CoreData Instead..
 struct Student {
 var id : UUID
 var name : String
 }
 */

struct CoreDataView: View {
    @Environment(\.managedObjectContext) var moc // Anyway, when it comes to adding and saving objects, we need access to the managed object context that it is in SwiftUI’s environment. This is another use for the @Environment property wrapper – we can ask it for the current managed object context, and assign it to a property for our use. So, add this property to ContentView now:
    @FetchRequest(sortDescriptors: []) var students: FetchedResults<Student> // SwiftUI has a solution for this, and – you guessed it – it’s another property wrapper. This time it’s called @FetchRequest and it takes at least one parameter describing how we want the results to be sorted. It has quite a specific format, so let’s start by adding a fetch request for our students – please add this property to ContentView now:
    var body: some View {
        VStack {
            List(students) { student in
                Text(student.name ?? "Unknown")
            }
            // Note: Inevitably there are people that will complain about me force unwrapping those calls to randomElement(), but we literally just hand-created the arrays to have values – it will always succeed. If you desperately hate force unwraps, perhaps replace them with nil coalescing and default values. Now for the interesting part: we’re going to create a Student object, using the class Core Data generated for us. This needs to be attached to a managed object context, so the object knows where it should be stored. We can then assign values to it just like we normally would for a struct. So, add these three lines to the button’s action closure now:
            Button("Add") {
                let firstNames = ["Ginny", "Harry", "Hermione", "Luna", "Ron"]
                let lastNames = ["Granger", "Lovegood", "Potter", "Weasley"]
                let chosenFirstName = firstNames.randomElement()!
                let chosenLastName = lastNames.randomElement()!
                let student = Student(context: moc)
                student.id = UUID()
                student.name = "\(chosenFirstName) \(chosenLastName)"
                try? moc.save() // Finally we need to ask our managed object context to save itself, which means it will write its changes to the persistent store. This is a throwing function call, because in theory it might fail. In practice, nothing about what we’ve done has any chance of failing, so we can call this using try? – we don’t care about catching errors.
            }
        }
        .navigationBarTitle("Core Data")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CoreDataView_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataView()
    }
}
