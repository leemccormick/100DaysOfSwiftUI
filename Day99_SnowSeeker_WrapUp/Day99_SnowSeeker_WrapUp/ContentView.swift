//
//  ContentView.swift
//  Day99_SnowSeeker_WrapUp
//
//  Created by Lee McCormick on 7/15/22.
//

import SwiftUI
/*
 *** Challenge ***
 One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on.

 1) Add a photo credit over the ResortView image. The data is already loaded from the JSON for this purpose, so you just need to make it look good in the UI.
 2) Fill in the loading and saving methods for Favorites.
 3) For a real challenge, let the user sort the resorts in ContentView either using the default order, alphabetical order, or country order.
 */

// MARK: - ContentView
struct ContentView: View {
    // MARK: - Properties
    let resorts : [Resort] = (Bundle.main.decoded("resorts.json"))
    @State private var searchText = ""
    @StateObject var favorites = Favorites()
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            return resorts
        } else {
            return  resorts.filter {$0.name.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List(filteredResorts) { resort in
                NavigationLink {
                    ResortView(resort: resort)
                } label: {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 1))
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundColor(.secondary)
                        }
                        if favorites.contain(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort.")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .searchable(text: $searchText, prompt: "Search for a resort")
            WelcomeView()
        }
        .environmentObject(favorites)
        .phoneOnlyNavigationView()
    }
}

// MARK: - PreviewProvider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
