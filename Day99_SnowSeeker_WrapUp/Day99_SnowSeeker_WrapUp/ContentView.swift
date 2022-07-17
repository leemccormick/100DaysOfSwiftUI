//
//  ContentView.swift
//  Day99_SnowSeeker_WrapUp
//
//  Created by Lee McCormick on 7/15/22.
//

import SwiftUI
/*
 *** Challenge ***
 1) Add a photo credit over the ResortView image. The data is already loaded from the JSON for this purpose, so you just need to make it look good in the UI.
 2) Fill in the loading and saving methods for Favorites.
 3) For a real challenge, let the user sort the resorts in ContentView either using the default order, alphabetical order, or country order.
 */

//  Challenge 3 : For a real challenge, let the user sort the resorts in ContentView either using the default order, alphabetical order, or country order.
enum SortedBy {
    case defaultOrder, alphabeticalOrder, countryOrder
}

// MARK: - ContentView
struct ContentView: View {
    // MARK: - Properties
    var resorts : [Resort] = (Bundle.main.decoded("resorts.json"))
    @State private var searchText = ""
    @StateObject var favorites = Favorites()
    
    //  Challenge 3 : For a real challenge, let the user sort the resorts in ContentView either using the default order, alphabetical order, or country order.
    @State private var isShowingSortingOption = false
    @State private var sortedBy: SortedBy = .defaultOrder
    var filteredAndSortedResorts: [Resort] {
        var filteredResorts: [Resort] = []
        // Filtered
        if searchText.isEmpty {
            filteredResorts = resorts
        } else {
            filteredResorts =  resorts.filter {$0.name.localizedCaseInsensitiveContains(searchText)}
        }
        // Sorted
        switch sortedBy {
        case .defaultOrder:
            return filteredResorts
        case .alphabeticalOrder:
            let  alphabeticalOrderResorts = filteredResorts.sorted {$0.name < $1.name}
            return alphabeticalOrderResorts
        case .countryOrder:
            let  countryOrderResorts = filteredResorts.sorted {$0.country < $1.country}
            return countryOrderResorts
        }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List(filteredAndSortedResorts) { resort in
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
            //  Challenge 3 : For a real challenge, let the user sort the resorts in ContentView either using the default order, alphabetical order, or country order.
            .toolbar {
                Button {
                    print("Sorting here")
                    isShowingSortingOption = true
                } label: {
                    Image(systemName: "arrow.up.arrow.down.square")
                }
            }
            .confirmationDialog("Sorted By : ", isPresented: $isShowingSortingOption) {
                Button("Default Order") {
                    sortedBy = .defaultOrder
                }
                Button("Sorted by Alphabetical Order") {
                    sortedBy = .alphabeticalOrder
                }
                Button("Sorted by Country Order") {
                    sortedBy = .countryOrder
                }
            }
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
