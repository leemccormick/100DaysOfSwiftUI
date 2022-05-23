//
//  EditView.swift
//  Day71_BucketList_Part4
//
//  Created by Lee McCormick on 5/22/22.
//

import SwiftUI

struct EditView: View {
    
    enum LoadingState { // This means conditionally showing different UI depending on the current load state, and that means defining an enum that actually stores the current load state otherwise we don’t know what to show.
        case loading, loaded, failed
    }
    
    @Environment(\.dismiss) var dismiss
    var location: Location
    var onSave: (Location) -> Void
    @State private var name: String
    @State private var description: String
    
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
                
                // Before we tackle the network request itself, we have one last easy job to do: adding to our Form a new section to show pages if they have loaded, or status text views otherwise. We can put these if/else if conditions or a switch statement right into the Section and SwiftUI will figure it out.
                Section("Nearby...") {
                    switch loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description) // That completes EditView – it lets us edit the two properties of our annotation views, it downloads and sorts data from Wikipedia, it shows different UI depending on how the network request is going, and it even carefully looks through the Wikipedia content to decide what can be shown.
                            // + Text("Page description here")
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place Details")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await fetchNearbyPlaces()
            }
        }
    }
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
    
    /*
     Tip: Notice how we can use + to add text views together? This lets us create larger text views that mix and match different kinds of formatting. That “Page description here” is just temporary – we’ll replace it soon.
     
     Now for the part that really brings all this together: we need to fetch some data from Wikipedia, decode it into a Result, assign its pages to our pages property, then set loadingState to .loaded. If the fetch fails, we’ll set loadingState to .failed, and SwiftUI will load the appropriate UI.
     
     Warning: The Wikipedia URL we need to load is really long, so rather than try to type it in you might want to copy and paste from the text or from my GitHub gist: http://bit.ly/swiftwiki.
     */
    func fetchNearbyPlaces() async {
        let urlString  = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        guard let url = URL(string: urlString) else {
            print("Bad URL : \(urlString)")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data) // we got some data back!
            // Now that Swift understands how to sort pages, it will automatically gives us a parameter-less sorted() method on page arrays. This means when we set self.pages in fetchNearbyPlaces() we can now add sorted() to the end, like this:
            pages = items.query.pages.values.sorted() // {$0.title < $1.title} // success – convert the array values to our pages array
            loadingState = .loaded
        } catch {
            loadingState = .failed // if we're still here it means the request failed somehow
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}
