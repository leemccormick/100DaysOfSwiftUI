//
//  ContentView.swift
//  Day54_Bookworm_Part2
//
//  Created by Lee McCormick on 4/23/22.
//

import SwiftUI
/*
 Showing AddBookView involves returning to ContentView.swift and following the usual steps for a sheet:
 1) Adding an @State property to track whether the sheet is showing.
 2) Add some sort of button – in the toolbar, in this case – to toggle that property.
 3) A sheet() modifier that shows AddBookView when the property becomes true.
 */
struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var books: FetchedResults<Book>
    @State private var showingAddScreen = false
    var body: some View {
        NavigationView{
            //  Text("Count : \(books.count)")
            List {
                ForEach(books) { book in
                    NavigationLink {
                        Text(book.title ?? "Unknown Title")
                    } label: {
                        /*
                         Now we can return to ContentView and do a first pass of its UI. This will replace the existing text view with a list and a ForEach over books. We don’t need to provide an identifier for the ForEach because all Core Data’s managed object class conform to Identifiable automatically, but things are trickier when it comes to creating views inside the ForEach.
                         
                         You see, all the properties of our Core Data entity are optional, which means we need to make heavy use of nil coalescing in order to make our code work. We’ll look at an alternative to this soon, but for now we’ll just be scattering ?? around.
                         
                         Inside the list we’re going to have a NavigationLink that will eventually point to a detail view, and inside that we’ll have our new EmojiRatingView, plus the book’s title and author. So, replace the existing text view with this:
                         */
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text(book.title ?? "Unknown Title")
                                    .font(.headline)
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Bookworm Part2")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddScreen.toggle()
                    } label: {
                        Label("Add Book", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
