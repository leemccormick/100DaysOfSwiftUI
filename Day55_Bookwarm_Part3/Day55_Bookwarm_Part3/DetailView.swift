//
//  DetailView.swift
//  Day55_Bookwarm_Part3
//
//  Created by Lee McCormick on 4/24/22.
//

import SwiftUI

struct DetailView: View {
    // To demonstrate this, we’re going to add one last feature to our app that deletes whatever book the user is currently looking at. To do this we need to show an alert asking the user if they really want to delete the book, then delete the book from the current managed object context if that’s what they want. Once that’s done, there’s no point staying on the current screen because its associated book doesn’t exist any more, so we’re going to pop the current view – remove it from the top of the NavigationView stack, so we move back to the previous screen. First, we need three new properties in our DetailView struct: one to hold our Core Data managed object context (so we can delete stuff), one to hold our dismiss action (so we can pop the view off the navigation stack), and one to control whether we’re showing the delete confirmation alert or not.
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    let book: Book
    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                Image(book.genre ?? "Fantasy")
                    .resizable()
                    .scaledToFit()
                Text(book.genre?.uppercased() ?? "FANTASY")
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
            }
            
            Text(book.author ?? "Unknown Author")
                .font(.title)
                .foregroundColor(.secondary)
            Text(book.review ?? "No Review")
                .padding()
            RatingView(rating: .constant(Int(book.rating)))
                .font(.largeTitle)
        }
        .navigationTitle(book.title ?? "Unknown Title")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete book?", isPresented: $showingDeleteAlert) { // The third step is to add an alert() modifier that watches showingDeleteAlert, and asks the user to confirm the action. So far we’ve been using simple alerts with a dismiss button, but here we need two buttons: one button to delete the book, and another to cancel. Both of these have specific button roles that automatically make them look correct, so we’ll use those. Apple provides very clear guidance on how we should label alert text, but it comes down to this: if it’s a simple “I understand” acceptance then “OK” is good, but if you want users to make a choice then you should avoid titles like “Yes” and “No” and instead use verbs such as “Ignore”, “Reply”, and “Confirm”. In this instance, we’re going to use “Delete” for the destructive button, then provide a cancel button next to it so users can back out of deleting if they want. So, add this modifier to the ScrollView in DetailView:
            Button("Delete", role: .destructive, action: deleteBook)
            Button("Cancel", role: .cancel) {}
        } message : {
            Text("Are you sure?")
        }
        .toolbar {
            Button {
                showingDeleteAlert = true
            } label: {
                Label("Delete this book", systemImage: "trash")
            }
        }
    }
    // The second step is writing a method that deletes the current book from our managed object context, and dismisses the current view. It doesn’t matter that this view is being shown using a navigation link rather than a sheet – we still use the same dismiss() code.
    func deleteBook() {
        moc.delete(book)
        try? moc.save()
        dismiss()
    }
}

/* We don't need preview because don't want to pass Book from CoreData here..
 struct DetailView_Previews: PreviewProvider {
 static var previews: some View {
 DetailView()
 }
 }
 */
