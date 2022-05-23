//
//  Day71_BucketList_Part4App.swift
//  Day71_BucketList_Part4
//
//  Created by Lee McCormick on 5/22/22.
//

import SwiftUI

@main
struct Day71_BucketList_Part4App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 14, part 4
 It’s taken a while to get to this point, but today you’re going to put in place some app features using remarkably little code – this should be a relatively easy day!

 More specifically, you’ll see how to show different UI based on an enum’s value, how to add custom Comparable conformance to some data we fetched from a network request, and more. There are some important techniques here, but they really do take our app up a notch.

 If you’re finding it hard, you’d do well to remember what William Eardley once said: “ambition is the path to success, persistence is the vehicle you arrive in.” You showed ambition for starting this course, and now you’ve made it to day 71 you’re clearly showing persistence too!

 Today you have two topics to work through, in which you’ll make network calls, add Comparable conformance, and more.

 - Downloading data from Wikipedia
 - Sorting Wikipedia results
 */

/* Downloading data from Wikipedia
 To make this whole app more useful, we’re going to modify our EditView screen so that it shows interesting places. After all, if visiting London is on your bucket list, you’d probably want some suggestions for things to see nearby. This might sound hard to do, but actually we can query Wikipedia using GPS coordinates, and it will send back a list of places that are nearby.

 Wikipedia’s API sends back JSON data in a precise format, so we need to do a little work to define Codable structs capable of storing it all. The structure is this:

 The main result contains the result of our query in a key called “query”.
 Inside the query is a “pages” dictionary, with page IDs as the key and the Wikipedia pages themselves as values.
 Each page has a lot of information, including its coordinates, title, terms, and more.
 We can represent that using three linked structs, so create a new Swift file called Result.swift and give it this content:

 struct Result: Codable {
     let query: Query
 }

 struct Query: Codable {
     let pages: [Int: Page]
 }

 struct Page: Codable {
     let pageid: Int
     let title: String
     let terms: [String: [String]]?
 }
 We’re going to use that to store data we fetch from Wikipedia, then show it immediately in our UI. However, we need something to show while the fetch is happening – a text view saying “Loading” or similar ought to do the trick.

 This means conditionally showing different UI depending on the current load state, and that means defining an enum that actually stores the current load state otherwise we don’t know what to show.

 Start by adding this nested enum to EditView:

 enum LoadingState {
     case loading, loaded, failed
 }
 Those cover all the states we need to represent our network request.

 Next we’re going to add two properties to EditView: one to represent the loading state, and one to store an array of Wikipedia pages once the fetch has completed. So, add these two now:

 @State private var loadingState = LoadingState.loading
 @State private var pages = [Page]()
 Before we tackle the network request itself, we have one last easy job to do: adding to our Form a new section to show pages if they have loaded, or status text views otherwise. We can put these if/else if conditions or a switch statement right into the Section and SwiftUI will figure it out.

 So, put this section below the existing one:

 Section("Nearby…") {
     switch loadingState {
     case .loaded:
         ForEach(pages, id: \.pageid) { page in
             Text(page.title)
                 .font(.headline)
             + Text(": ") +
             Text("Page description here")
                 .italic()
         }
     case .loading:
         Text("Loading…")
     case .failed:
         Text("Please try again later.")
     }
 }
 Tip: Notice how we can use + to add text views together? This lets us create larger text views that mix and match different kinds of formatting. That “Page description here” is just temporary – we’ll replace it soon.

 Now for the part that really brings all this together: we need to fetch some data from Wikipedia, decode it into a Result, assign its pages to our pages property, then set loadingState to .loaded. If the fetch fails, we’ll set loadingState to .failed, and SwiftUI will load the appropriate UI.

 Warning: The Wikipedia URL we need to load is really long, so rather than try to type it in you might want to copy and paste from the text or from my GitHub gist: http://bit.ly/swiftwiki.

 Add this method to EditView:

 func fetchNearbyPlaces() async {
     let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

     guard let url = URL(string: urlString) else {
         print("Bad URL: \(urlString)")
         return
     }

     do {
         let (data, _) = try await URLSession.shared.data(from: url)

         // we got some data back!
         let items = try JSONDecoder().decode(Result.self, from: data)

         // success – convert the array values to our pages array
         pages = items.query.pages.values.sorted { $0.title < $1.title }
         loadingState = .loaded
     } catch {
         // if we're still here it means the request failed somehow
         loadingState = .failed
     }
 }
 That request should begin as soon as the view appears, so add this task() modifier after the existing toolbar() modifier:

 .task {
     await fetchNearbyPlaces()
 }
 Now go ahead and run the app again – you’ll find that as you drop a pin our EditView screen will slide up and show you all the places nearby. Nice!
 */

/* Sorting Wikipedia results
 Wikipedia’s results come back to us in an order that probably seems random, but it’s actually sorted according to their internal page ID. That doesn’t help us though, which is why we’re sorting results using a custom closure.

 There are lots of times when using a custom sorting function is exactly what you need, but more often than not there is one natural order to your data – maybe showing news stories newest first, or contacts last name first, etc. So, rather than just provide an inline closure to sorted() we are instead going to make our Page struct conform to Comparable. This is actually pretty easy to do, because we already have the sorting code written – it’s just a matter of moving it across to our Page struct.

 So, start by modifying the definition of the Page struct to this:

 struct Page: Codable, Comparable {
 If you recall, conforming to Comparable has only a single requirement: we must implement a < function that accepts two parameters of the type of our struct, and returns true if the first should be sorted before the second. In this case we can just pass the test directly onto the title strings, so add this method to the Page struct now:

 static func <(lhs: Page, rhs: Page) -> Bool {
     lhs.title < rhs.title
 }
 Now that Swift understands how to sort pages, it will automatically gives us a parameter-less sorted() method on page arrays. This means when we set self.pages in fetchNearbyPlaces() we can now add sorted() to the end, like this:

 pages = items.query.pages.values.sorted()
 Before we’re done with this screen, we need to replace the Text("Page description here") view with something real. Wikipedia’s JSON data does contain a description, but it’s buried: the terms dictionary might not be there, and if it is there it might not have a description key, and if it has a description key it might be an empty array rather than an array with some text inside.

 We don’t want this mess to plague our SwiftUI code, so again the best thing to do is make a computed property that returns the description if it exists, or a fixed string otherwise. Add this to the Page struct to finish it off:

 var description: String {
     terms?["description"]?.first ?? "No further information"
 }
 With that done you can replace Text("Page description here") with this:

 Text(page.description)
 That completes EditView – it lets us edit the two properties of our annotation views, it downloads and sorts data from Wikipedia, it shows different UI depending on how the network request is going, and it even carefully looks through the Wikipedia content to decide what can be shown.
 */
