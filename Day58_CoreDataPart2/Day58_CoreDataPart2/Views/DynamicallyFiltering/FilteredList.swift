//
//  FilteredList.swift
//  Day58_CoreDataPart2
//
//  Created by Lee McCormick on 5/7/22.
//
import CoreData
import SwiftUI

struct FilteredList<T: NSManagedObject, Content: View>: View {
    @FetchRequest var fetchRequest: FetchedResults<T>
    let content: (T) -> Content   // this is our content closure; we'll call this once for each item in the list
    var body: some View {
        List(fetchRequest, id: \.self) { item in
            self.content(item)
        }
    }
    init(filterKey: String, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
        // @ViewBuilder lets our containing view (whatever is using the list) send in multiple views if they want.
        // @escaping says the closure will be stored away and used later, which means Swift needs to take care of its memory.
        // To resolve this, NSPredicate has a special symbol that can be used to replace attribute names: %K, for “key”. This will insert values we provide, but won’t add quote marks around them. The correct predicate is this:
        _fetchRequest = FetchRequest<T>(sortDescriptors: [], predicate: NSPredicate(format: "%K BEGINSWITH %@", filterKey, filterValue))
        self.content = content
    }
}

/*
 Want to go further?
 For more flexibility, we could improve our FilteredList view so that it works with any kind of entity, and can filter on any field. To make this work properly, we need to make a few changes:

 Rather than specifically referencing the Singer class, we’re going to use generics with a constraint that whatever is passed in must be an NSManagedObject.
 We need to accept a second parameter to decide which key name we want to filter on, because we might be using an entity that doesn’t have a lastName attribute.
 Because we don’t know ahead of time what each entity will contain, we’re going to let our containing view decide. So, rather than just using a text view of a singer’s name, we’re instead going to ask for a closure that can be run to configure the view however they want.
 There are two complex parts in there. The first is the closure that decides the content of each list row, because it needs to use two important pieces of syntax. We looked at these towards the end of our earlier technique project on views and modifiers, but if you missed them:

 @ViewBuilder lets our containing view (whatever is using the list) send in multiple views if they want.
 @escaping says the closure will be stored away and used later, which means Swift needs to take care of its memory.
 The second complex part is how we let our container view customize the search key. Previously we controlled the filter value like this:
 */

/*
 That will run a fetch request using the current managed object context. Because this view will be used inside ContentView, we don’t even need to inject a managed object context into the environment – it will inherit the context from ContentView.

 Did you notice how there’s an underscore at the start of _fetchRequest? That’s intentional. You see, we’re not writing to the fetched results object inside our fetch request, but instead writing a wholly new fetch request.

 To understand this, think about the @State property wrapper. Behind this scenes this is implemented as a struct called State, which contains whatever value we put inside – an integer, for example. If we have an @State property called score and assign the value 10 to it, we mean to put 10 into the integer inside the State property wrapper. However, we can also assign a value to _score – we can write a wholly new State struct in there, if needed.

 So, by assigning to _fetchRequest, we aren’t trying to say “here’s a whole bunch of new results we want to you to use,” but instead we’re telling Swift we want to change the whole fetch request itself.
 */

/*
struct FilteredList: View {
    @FetchRequest var fetchRequest: FetchedResults<Singer>
    var body: some View {
        List(fetchRequest, id: \.self) { singer in
            Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
        }
    }
    init(filter: String) {
        _fetchRequest = FetchRequest<Singer>(sortDescriptors: [], predicate: NSPredicate(format: "lastName BEGINSWITH %@", filter))
    }
}

struct FilteredList_Previews: PreviewProvider {
    static var previews: some View {
        FilteredList()
    }
}
*/
