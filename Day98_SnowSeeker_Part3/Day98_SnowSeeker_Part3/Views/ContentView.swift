//
//  ContentView.swift
//  Day98_SnowSeeker_Part3
//
//  Created by Lee McCormick on 7/15/22.
//

import SwiftUI

// MARK: - ContentView
struct ContentView: View {
    // MARK: - Properties
    let resort: [Resort] = Bundle.main.decode("resorts.json")
    @State private var searchText = ""
    @StateObject var favorites = Favorites() // We need to create a Favorites instance in ContentView and inject it into the environment so all views can share it. So, add this new property to ContentView.
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            // List of Resort and Link
            List(filtersResort) { resort in
                NavigationLink {
                    ResortView(resort: resort)
                } label: {
                    HStack { // To fix this, we need to tell SwiftUI explicitly that the content of our NavigationLink is a plain old HStack, so it will size everything appropriately. So, wrap the entire contents of the NavigationLink label – everything from the Image down to the new condition wrapping the heart icon – inside a HStack to fix the problem.
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay( RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 1))
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundColor(.secondary)
                        }
                        
                        // Favorite --> Now we can show a colored heart icon next to favorite resorts in ContentView by adding this to the end of the label for our NavigationLink:
                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort.")
                                .foregroundColor(.red) // Tip: As you can see, the foregroundColor() modifier works great here because our image uses SF Symbols.
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .searchable(text: $searchText, prompt: "Search for a resort")
            
            // Welcome View
            WelcomeView()
        }
        .environmentObject(favorites) // Now inject it into the environment by adding this modifier to the NavigationView
        .phoneOnlyNavigationView()
    }
    
    // MARK: - FilteredResorts
    var filtersResort : [Resort] {
        if searchText.isEmpty {
            return resort
        } else {
            return resort.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

// MARK: - PreviewProvider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
