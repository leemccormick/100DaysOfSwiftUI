//
//  ContentView.swift
//  Day59_CoreDataWrapUp
//
//  Created by Lee McCormick on 5/9/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var lastNameFilter = "A"
    let sorted =  [NSSortDescriptor(key: "lastName", ascending: true)]
    var body: some View {
        VStack {
            /* Challenge 1) Make it accept a string parameter that controls which predicate is applied.
             FilteredList(predicate: "BEGINSWITH", filterKey: "lastName", filterValue: lastNameFilter) { (developer : Developer) in
                Text("\(developer.wrappedFirstName) \(developer.wrappedLastName)")
             }
             */
            /* Challenge 2) Modify the predicate string parameter to be an enum such as
            FilteredList(predicate: Predicates.befinswithCaseInsensitive, filterKey: "lastName", filterValue: lastNameFilter) { (developer : Developer) in
                Text("\(developer.wrappedFirstName) \(developer.wrappedLastName)")
            }
            */
            // Challenge 3) Make FilteredList accept an array of SortDescriptor objects to get used in its fetch request.
            FilteredList(predicate: Predicates.befinswithCaseInsensitive, filterKey: "lastName", filterValue: lastNameFilter, sortDescription: sorted) { (developer : Developer) in
                Text("\(developer.wrappedFirstName) \(developer.wrappedLastName)")
            }
            Button("Add Developer") {
                let lee = Developer(context: moc)
                lee.firstName = "Lee"
                lee.lastName = "McCormick"
                let donny = Developer(context: moc)
                donny.firstName = "Donny"
                donny.lastName = "McCormick"
                let taylor = Developer(context: moc)
                taylor.firstName = "Taylor"
                taylor.lastName = "Swift"
                let ed = Developer(context: moc)
                ed.firstName = "Ed"
                ed.lastName = "Sheeran"
                let adele = Developer(context: moc)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
