//
//  Day54_Bookworm_Part2App.swift
//  Day54_Bookworm_Part2
//
//  Created by Lee McCormick on 4/23/22.
//

import SwiftUI

@main
struct Day54_Bookworm_Part2App: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}

/* Project 11, part 2
 Today we’re going to start applying the new techniques you learned to build our app, using Core Data to create books and a custom RatingView component to let users store how much they liked each book, built using @Binding.

 The way we handle data is critically important to our work. Sometimes it’s as simple as figuring out what should be a an integer and what should be a string; other times it requires a little theory, such as being able to choose between arrays and sets; and still other times it means we need to think about how objects relate to each other.

 A quote from Linus Torvalds that I love very much is this one: “Bad programmers worry about the code; good programmers worry about data structures and their relationships.” I like it partly because it re-enforces the view that designing good data structures is critically important, but also because it’s a reminder that once you master one language it’s relatively easy to move to others – the syntax might be different, but the data structures are usually the same if not very similar.

 Today you have three topics to work through, in which you’ll apply your new-found Core Data skills with List, @Binding, and more.

 - Creating books with Core Data
 - Adding a custom star rating component
 - Building a list with @FetchRequest
 
 Don’t forget to tell others about your progress – you’re building your own Core Data models and SwiftUI components now, and it helps keep you accountable.
 */

/* Creating books with Core Data
 Our first task in this project will be to design a Core Data model for our books, then creating a new view to add books to the database.

 First, the model: open Bookworm.xcdatamodeld and add a new entity called “Book” – we’ll create one new object in there for each book the user has read. In terms of what constitutes a book, I’d like you to add the following attributes:

 id, UUID – a guaranteed unique identifier we can use to distinguish between books
 title, String – the title of the book
 author, String – the name of whoever wrote the book
 genre, String – one of several strings from the genres in our app
 review, String – a brief overview of what the user thought of the book
 rating, Integer 16 – the user’s rating for this book
 Most of those should make sense, but the last one is an odd one: “integer 16”. What is the 16? And how come there are also Integer 32 and Integer 64? Well, just like Float and Double the difference is how much data they can store: Integer 16 uses 16 binary digits (“bits”) to store numbers, so it can hold values from -32,768 up to 32,767, whereas Integer 32 uses 32 bits to store numbers, so it hold values from -2,147,483,648 up to 2,147,483,647. As for Integer 64… well, that’s a really large number – about 9 quintillion.

 The point is that these values aren’t interchangeable: you can’t take the value from a 64-bit number and try to store it in a 16-bit number, because you’d probably lose data. On the other hand, it’s a waste of space to use 64-bit integers for values we know will always be small. As a result, Core Data gives us the option to choose just how much storage we want.

 Our next step is to write a form that can create new entries. This will combine so many of the skills you’ve learned so far: Form, @State, @Environment, TextField, TextEditor, Picker, sheet(), and more, plus all your new Core Data knowledge.

 Start by creating a new SwiftUI view called “AddBookView”. In terms of properties, we need an environment property to store our managed object context:

 @Environment(\.managedObjectContext) var moc
 As this form is going to store all the data required to make up a book, we need @State properties for each of the book’s values except id, which we can generate dynamically. So, add these properties next:

 @State private var title = ""
 @State private var author = ""
 @State private var rating = 3
 @State private var genre = ""
 @State private var review = ""
 Finally, we need one more property to store all possible genre options, so we can make a picker using ForEach. Add this last property to AddBookView now:

 let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
 We can now take a first pass at the form itself – we’ll improve it soon, but this is enough for now. Replace the current body with this:

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

             Picker("Rating", selection: $rating) {
                 ForEach(0..<6) {
                     Text(String($0))
                 }
             }
         } header: {
             Text("Write a review")
         }

         Section {
             Button("Save") {
                 // add the book
             }
         }
     }
     .navigationTitle("Add Book")
 }
 When it comes to filling in the button’s action, we’re going to create an instance of the Book class using our managed object context, copy in all the values from our form (converting rating to an Int16 to match Core Data), then save the managed object context.

 Most of this work is just copying one value into another, with the only vaguely interesting thing being how we convert from an Int to an Int16 for the rating. Even that is pretty guessable: Int16(someInt) does it all.

 Add this code in place of the // add the book comment:

 let newBook = Book(context: moc)
 newBook.id = UUID()
 newBook.title = title
 newBook.author = author
 newBook.rating = Int16(rating)
 newBook.genre = genre
 newBook.review = review

 try? moc.save()
 That completes the form for now, but we still need a way to show and hide it when books are being added.

 Showing AddBookView involves returning to ContentView.swift and following the usual steps for a sheet:

 Adding an @State property to track whether the sheet is showing.
 Add some sort of button – in the toolbar, in this case – to toggle that property.
 A sheet() modifier that shows AddBookView when the property becomes true.
 Enough talk – let’s start writing some more code. Please start by adding these three properties to ContentView:

 @Environment(\.managedObjectContext) var moc
 @FetchRequest(sortDescriptors: []) var books: FetchedResults<Book>

 @State private var showingAddScreen = false
 That gives us a managed object context we can use later on to delete books, a fetch request reading all the books we have (so we can test everything worked), and a Boolean that tracks whether the add screen is showing or not.

 For the ContentView body, we’re going to use a navigation view so we can add a title plus a button in its top-right corner, but otherwise it will just hold some text showing how many items we have in the books array – just so we can be sure everything is working. Remember, this is where we need to add our sheet() modifier to show an AddBookView as needed.

 Replace the existing body property of ContentView with this:

  NavigationView {
     Text("Count: \(books.count)")
         .navigationTitle("Bookworm")
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
 Tip: That explicitly specifies a trailing navigation bar placement so that we can add a second button later.

 Bear with me – we’re almost done! We’ve now designed our Core Data model, created a form to add data, then updated ContentView so that it can present the form and pass in its managed object context. The final step is to to make the form dismiss itself when the user adds a book.

 We’ve done this before, so hopefully you know the drill. We need to start by adding another environment property to AddBookView to be able to dismiss the current view:

 @Environment(\.dismiss) var dismiss
 Finally, add a call to dismiss() to the end of your button’s action closure.

 You should be able to run the app now and add an example book just fine. When AddBookView slides away the count label should update itself to 1.
 */

/* Adding a custom star rating component
 SwiftUI makes it really easy to create custom UI components, because they are effectively just views that have some sort of @Binding exposed for us to read.

 To demonstrate this, we’re going to build a star rating view that lets the user enter scores between 1 and 5 by tapping images. Although we could just make this view simple enough to work for our exact use case, it’s often better to add some flexibility where appropriate so it can be used elsewhere too. Here, that means we’re going to make six customizable properties:

 What label should be placed before the rating (default: an empty string)
 The maximum integer rating (default: 5)
 The off and on images, which dictate the images to use when the star is highlighted or not (default: nil for the off image, and a filled star for the on image; if we find nil in the off image we’ll use the on image there too)
 The off and on colors, which dictate the colors to use when the star is highlighted or not (default: gray for off, yellow for on)
 We also need one extra property to store an @Binding integer, so we can report back the user’s selection to whatever is using the star rating.

 So, create a new SwiftUI view called “RatingView”, and start by giving it these properties:

 @Binding var rating: Int

 var label = ""

 var maximumRating = 5

 var offImage: Image?
 var onImage = Image(systemName: "star.fill")

 var offColor = Color.gray
 var onColor = Color.yellow
 Before we fill in the body property, please try building the code – you should find that it fails, because our RatingView_Previews struct doesn’t pass in a binding to use for rating.

 SwiftUI has a specific and simple solution for this called constant bindings. These are bindings that have fixed values, which on the one hand means they can’t be changed in the UI, but also means we can create them trivially – they are perfect for previews.

 So, replace the existing previews property with this:

 static var previews: some View {
     RatingView(rating: .constant(4))
 }
 Now let’s turn to the body property. This is going to be a HStack containing any label that was provided, plus as many stars as have been requested – although, of course, they can choose any image they want, so it might not be a star at all.

 The logic for choosing which image to show is pretty simple, but it’s perfect for carving off into its own method to reduce the complexity of our code. The logic is this:

 If the number that was passed in is greater than the current rating, return the off image if it was set, otherwise return the on image.
 If the number that was passed in is equal to or less than the current rating, return the on image.
 We can encapsulate that in a single method, so add this to RatingView now:

 func image(for number: Int) -> Image {
     if number > rating {
         return offImage ?? onImage
     } else {
         return onImage
     }
 }
 And now implementing the body property is surprisingly easy: if the label has any text use it, then use ForEach to count from 1 to the maximum rating plus 1 and call image(for:) repeatedly. We’ll also apply a foreground color depending on the rating, and add a tap gesture that adjusts the rating.

 Replace your existing body property with this:

 HStack {
     if label.isEmpty == false {
         Text(label)
     }

     ForEach(1..<maximumRating + 1, id: \.self) { number in
         image(for: number)
             .foregroundColor(number > rating ? offColor : onColor)
             .onTapGesture {
                 rating = number
             }
     }
 }
 That completes our rating view already, so to put it into action go back to AddBookView and replace the second section with this:

 Section {
     TextEditor(text: $review)
     RatingView(rating: $rating)
 } header: {
     Text("Write a review")
 }
 That’s all it takes – our default values are sensible, so it looks great out of the box. And the result is much nicer to use: there’s no need to tap into a detail view with a picker here, because star ratings are more natural and more common.
 */

/* Building a list with @FetchRequest
 Right now our ContentView has a fetch request property like this:

 @FetchRequest(sortDescriptors: []) var books: FetchedResults<Book>
 And we’re using it in body with this simple text view:

 Text("Count: \(books.count)")
 To bring this screen to life, we’re going to replace that text view with a List showing all the books that have been added, along with their rating and author.

 We could just use the same star rating view here that we made earlier, but it’s much more fun to try something else. Whereas the RatingView control can be used in any kind of project, we can make a new EmojiRatingView that displays a rating specific to this project. All it will do is show one of five different emoji depending on the rating, and it’s a great example of how straightforward view composition is in SwiftUI – it’s so easy to just pull out a small part of your views in this way.

 So, make a new SwiftUI view called “EmojiRatingView”, and give it the following code:

 struct EmojiRatingView: View {
     let rating: Int16

     var body: some View {
         switch rating {
         case 1:
             Text("1")
         case 2:
             Text("2")
         case 3:
             Text("3")
         case 4:
             Text("4")
         default:
             Text("5")
         }
     }
 }

 struct EmojiRatingView_Previews: PreviewProvider {
     static var previews: some View {
         EmojiRatingView(rating: 3)
     }
 }
 Tip: I used numbers in my text because emoji can cause havoc with e-readers, but you should replace those with whatever emoji you think represent the various ratings.

 Notice how that specifically uses Int16, which makes interfacing with Core Data easier. And that’s the entire view done – it really is that simple.

 Now we can return to ContentView and do a first pass of its UI. This will replace the existing text view with a list and a ForEach over books. We don’t need to provide an identifier for the ForEach because all Core Data’s managed object class conform to Identifiable automatically, but things are trickier when it comes to creating views inside the ForEach.

 You see, all the properties of our Core Data entity are optional, which means we need to make heavy use of nil coalescing in order to make our code work. We’ll look at an alternative to this soon, but for now we’ll just be scattering ?? around.

 Inside the list we’re going to have a NavigationLink that will eventually point to a detail view, and inside that we’ll have our new EmojiRatingView, plus the book’s title and author. So, replace the existing text view with this:

 List {
     ForEach(books) { book in
         NavigationLink {
             Text(book.title ?? "Unknown Title")
         } label: {
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
 We’ll come back to this screen soon enough, but first let’s build the detail view…


 */
