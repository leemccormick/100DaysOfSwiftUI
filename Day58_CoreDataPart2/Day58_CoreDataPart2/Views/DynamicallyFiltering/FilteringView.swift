//
//  FilteringView.swift
//  Day58_CoreDataPart2
//
//  Created by Lee McCormick on 4/27/22.
//

import CoreData
import SwiftUI

struct FilteringView: View { // That will store our fetch request, so that we can loop over it inside the body. However, we don’t create the fetch request here, because we still don’t know what we’re searching for. Instead, we’re going to create a custom initializer that accepts a filter string and uses that to set the fetchRequest property.
    @Environment(\.managedObjectContext) var moc
    @State private var lastNameFilter = "A"
    var body: some View {
        VStack {
        Text("Dynamically filtering @FetchRequest with SwiftUI")
            .font(.title.bold())
           //  FilteredList(filter: lastNameFilter)
            FilteredList(filterKey: "lastName", filterValue: lastNameFilter) { (singer: Singer) in  // Notice how I’ve specifically used (singer: Singer) as the closure’s parameter – this is required so that Swift understands how FilteredList is being used. Remember, we said it could be any type of NSManagedObject, but in order for Swift to know exactly what type of managed object it is we need to be explicit.
                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
            }
            
            Button("Add Example") {
                let taylor = Singer(context: moc)
                taylor.firstName = "Taylor"
                taylor.lastName = "Swift"
                let ed = Singer(context: moc)
                ed.firstName = "Ed"
                ed.lastName = "Sheeran"
                let adele = Singer(context: moc)
                adele.firstName = "Adele"
                adele.lastName = "Adkins"
                try? moc.save()
            }
            Button("Show A") {
                lastNameFilter = "A"
            }
            Button("Show S") {
                lastNameFilter = "S"
            }
        }
    }
}

struct FilteringView_Previews: PreviewProvider {
    static var previews: some View {
        FilteringView()
    }
}
