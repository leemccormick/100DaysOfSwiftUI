//
//  ContentView.swift
//  Day55_Bookwarm_Part3
//
//  Created by Lee McCormick on 4/23/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
       //  SortDescriptor(\.title, order: .reverse) ==>  Fetch request sorting is performed using a new type called SortDescriptor, and we can create them from either one or two values: the attribute we want to sort on, and optionally whether it should be reversed or not. For example, we can alphabetically sort on the title attribute like this:
        SortDescriptor(\.title),
        SortDescriptor(\.author) // You can specify more than one sort descriptor, and they will be applied in the order you provide them. For example, if the user added the book “Forever” by Pete Hamill, then added “Forever” by Judy Blume – an entirely different book that just happens to have the same title – then specifying a second sort field is helpful. So, we might ask for book title to be sorted ascending first, followed by book author ascending second, like this:
    ]) var books : FetchedResults<Book>
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in
                    NavigationLink {
                        // Text(book.title ?? "Unknown Title")
                        DetailView(book: book)
                    } label: {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                            VStack(alignment: .leading) {
                                Text(book.title ?? "Unknown Title")
                                    .font(.headline)
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("Bookworm Part3")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddScreen.toggle()
                    } label: {
                        Label("Add Book", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                   EditButton() // That gets us swipe to delete, and we can go one better by adding an Edit/Done button too. Find the toolbar() modifier in ContentView, and add another ToolbarItem:
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
            }
        }
    }
    func deleteBooks(at offsets: IndexSet) { // Just as with regular arrays of data, most of the work is done by attaching an onDelete(perform:) modifier to ForEach, but rather than just removing items from an array we instead need to find the requested object in our fetch request then use it to call delete() on our managed object context. Once all the objects are deleted we can trigger another save of the context; without that the changes won’t actually be written out to disk.
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
       try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
