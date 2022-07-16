//
//  ResortView.swift
//  Day98_SnowSeeker_Part3
//
//  Created by Lee McCormick on 7/15/22.
//

import SwiftUI

// MARK: - ResortView
struct ResortView: View {
    // MARK: - Properties
    let resort: Resort
    
    // Because that’s attached to the navigation view, every view the navigation view presents will also gain that Favorites instance to work with. So, we can load it from inside ResortView by adding this new property:
    @EnvironmentObject var favorites: Favorites
    
    /*
     That will tell us whether we have a regular or compact size class. Very roughly:
     
     - All iPhones in portrait have compact width and regular height.
     - Most iPhones in landscape have compact width and compact height.
     - Large iPhones (Plus-sized and Max devices) in landscape have regular width and compact height.
     - All iPads in both orientations have regular width and regular height when your app is running with the full screen.
     */
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.dynamicTypeSize) var typeSize // To make this even better we can combine a check for the app’s current horizontal size class with a check for the user’s Dynamic Type setting so that we use the flat horizontal layout unless space really is tight – if the user has a compact size class and a larger Dynamic Type setting.
    
    // Using the optional form of alert() this starts easily enough – add two new properties to ResortView, one to store the currently selected facility, and one to store whether an alert should currently be shown or not:
    @State private var selectedFacility: Facility?
    @State private var showingFacility = false
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Image
                Image(decorative: resort.id)
                    .resizable()
                    .scaledToFit()
                
                // Detail
                HStack {
                    // Fortunately, to begin with all we care about are these two horizontal options: do we have lots of horizontal space (regular) or is space restricted (compact). If we have a regular amount of space, we’re going to keep the current HStack approach so that everything its neatly on one line, but if space is restricted we’ll ditch that and place each of the views into a VStack.
                    if sizeClass == .compact && typeSize > .large {
                        VStack(spacing: 10) { ResortDetailView(resort: resort) }
                        VStack(spacing: 10) { SkiDetailView(resort: resort) }
                    } else {
                        ResortDetailView(resort: resort)
                        SkiDetailView(resort: resort)
                    }
                }
                .padding(.vertical)
                .background(Color.primary.opacity(0.1))
                .dynamicTypeSize(...DynamicTypeSize.xxxLarge) // You can limit the range of Dynamic Type sizes supported by a particular view. For example, you might have worked hard to support as wide a range of sizes as possible, but found that anything larger than the “extra extra extra large” setting just looks bad. In that situation you can use the dynamicTypeSize() modifier on a view. That’s a one-sided range, meaning that any size up to and including .xxxLarge is fine, but nothing larger. Obviously it’s best to avoid setting these limits where possible, but it’s not a problem if you use it judiciously – both TabView and NavigationView, for example, limit the size of their text labels so the UI doesn’t break.
                
                // Group of Description and Facilities
                Group {
                    Text(resort.description)
                        .padding(.vertical)
                    Text("Facilities")
                        .font(.headline)
                    
                    // Change Text To Icons
                    /*Text(resort.facilities, format: .list(type: .and))
                     .padding(.vertical)*/
                    HStack {
                        ForEach(resort.facilityType) { facility in
                            Button {
                                selectedFacility = facility
                                showingFacility = true
                            } label: {
                                facility.icon
                                    .font(.title)
                            }
                        }
                    }
                    
                    // Favorite --> This is easy enough to fix: we’re going to add a button at the end of the scrollview in ResortView so that users can either add or remove the resort from their favorites, then display a heart icon in ContentView for favorite resorts.
                    Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
                        if favorites.contains(resort) {
                            favorites.remove(resort)
                        } else {
                            favorites.add(resort)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("\(resort.name), \(resort.country)")
        .navigationBarTitleDisplayMode(.inline)
        /*You see, the selectedFacility property is optional, so we need to handle it carefully:
         
         - We can’t use it as the only title for our alert, because we must provide a non-optional string. We can fix that with nil coalescing.
         - We always want to make sure the alert reads from our optional selectedFacility, so it passes in the unwrapped value from there.
         - We don’t need any buttons in this alert, so we can let the system provide a default OK button.
         - We need to provide an alert message based on the unwrapped facility data, calling the new message(for:) method we just wrote.
         */
        .alert(selectedFacility?.name ?? "More information", isPresented: $showingFacility, presenting: selectedFacility) { _ in // Notice how we’re using _ in for the alert’s action closure because we don’t actually care about getting the unwrapped Facility instance there, but it is important in the message closure so we can display the correct description.
        } message: { facility in
            Text(facility.description)
        }
    }
}

// MARK: - PreviewProvider
struct ResortView_Previews: PreviewProvider {
    static var previews: some View {
        // Tip: Make sure you modify your ResortView preview to inject an example Favorites object into the environment, so your SwiftUI preview carries on working. This will work fine: .environmentObject(Favorites()).
        NavigationView {
            ResortView(resort: Resort.example)
        }
        .environmentObject(Favorites())
    }
}
