//
//  AddBookView.swift
//  Day56_BookwormWrapup
//
//  Created by Lee McCormick on 4/24/22.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                Section {
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review")
                }
                Section {
                    Button("Save") {
                        let newBook = Book(context: moc)
                        newBook.id = UUID()
                        newBook.title = title
                        newBook.author = author
                        newBook.rating = Int16(rating)
                        newBook.genre = genre
                        newBook.review = review
                        newBook.date = Date()
                        try? moc.save()
                        dismiss()
                    }
                    .disabled(validData() == false)
                }
            }
            .navigationTitle("Add Book")
        }
    }
    func validData() -> Bool { /* Challenge 1 : , validating the form */
        if title.trimmingCharacters(in: .whitespaces) == ""  {
            return false
        }
        if author.trimmingCharacters(in: .whitespaces)  == "" {
            return false
        }
        if genre.trimmingCharacters(in: .whitespaces)  == "" {
            return false
        }
        if review.trimmingCharacters(in: .whitespaces)  == "" {
            return false
        }
        return true
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
