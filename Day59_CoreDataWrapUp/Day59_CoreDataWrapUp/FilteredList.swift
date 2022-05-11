//
//  FilteredList.swift
//  Day59_CoreDataWrapUp
//
//  Created by Lee McCormick on 5/9/22.
//
import CoreData
import SwiftUI

/* Challenge
 All three of these tasks require you to modify the FilteredList view we made:
 1) Make it accept a string parameter that controls which predicate is applied. You can use Swift’s string interpolation to place this in the predicate.
 2) Modify the predicate string parameter to be an enum such as .beginsWith, then make that enum get resolved to a string inside the initializer.
 3) Make FilteredList accept an array of SortDescriptor objects to get used in its fetch request.
 */

//  Challenge 2) Modify the predicate string parameter to be an enum such as
enum Predicates : String {
    case equal = "=="
    case lessThan = "<"
    case beginswith = "BEGINSWITH"
    case befinswithCaseInsensitive = "BEGINSWITH[c]"
    case containCaseInsensitive = "CONTAINS[c]"
}

struct FilteredList<T: NSManagedObject, Content: View>: View {
    @FetchRequest var fetchRequest: FetchedResults<T>
    let content: (T) -> Content
    var body: some View {
        List(fetchRequest, id: \.self) { item in
            self.content(item)
        }
    }
    
    // Challenge 3) Make FilteredList accept an array of SortDescriptor objects to get used in its fetch request.
    init(predicate: Predicates, filterKey: String, filterValue: String , sortDescription: [NSSortDescriptor], @ViewBuilder content: @escaping (T) -> Content) {
        _fetchRequest = FetchRequest<T>(sortDescriptors: sortDescription, predicate: NSPredicate(format: "%K \(predicate.rawValue) %@", filterKey, filterValue))
        self.content = content
    }
}

/*
     // Challenge 2) Modify the predicate string parameter to be an enum such as
    init(predicate: Predicates, filterKey: String, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
        _fetchRequest = FetchRequest<T>(sortDescriptors: [], predicate: NSPredicate(format: "%K \(predicate.rawValue) %@", filterKey, filterValue))
        self.content = content
    }

     // Challenge 1) Make it accept a string parameter that controls which predicate is applied.
    init(predicate: String, filterKey: String, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
        _fetchRequest = FetchRequest<T>(sortDescriptors: [], predicate: NSPredicate(format: "%K \(predicate) %@", filterKey, filterValue))
        self.content = content
    }
*/

