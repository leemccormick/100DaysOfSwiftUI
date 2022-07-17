//
//  ResortView.swift
//  Day99_SnowSeeker_WrapUp
//
//  Created by Lee McCormick on 7/15/22.
//

import SwiftUI

// MARK: - ResortView
struct ResortView: View {
    // MARK: - Properties
    let resort: Resort
    @EnvironmentObject var favorites: Favorites
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.dynamicTypeSize) var typeSize
    @State private var selectedFacility: Facility?
    @State private var showingFacility = false
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Image
                ZStack {
                    Image(decorative: resort.id)
                        .resizable()
                        .scaledToFit()
                    
                    //  Challenge 1 : Add a photo credit over the ResortView image. The data is already loaded from the JSON for this purpose, so you just need to make it look good in the UI.
                    VStack {
                        HStack {
                            Spacer()
                            Text("Photo By :  \(resort.imageCredit)")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(5)
                                .background(.black.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                        Spacer()
                    }
                    .padding(5)
                }
                
                // Detail
                HStack {
                    if sizeClass == .compact && typeSize == .large {
                        VStack(spacing: 10) { ResortDetailView(resort: resort)}
                        VStack(spacing: 10) { SkiDetailView(resort: resort)}
                    } else {
                        ResortDetailView(resort: resort)
                        SkiDetailView(resort: resort)
                    }
                }
                .padding(.vertical)
                .background(Color.primary.opacity(0.1))
                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                
                // Group of Description and Facilities
                Group {
                    Text(resort.description)
                        .padding(.vertical)
                    Text("Facilities")
                        .font(.headline)
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
                    Button(favorites.contain(resort) ? "Remove from Favorite" : "Add to Favorite") {
                        if favorites.contain(resort) {
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
        .alert(selectedFacility?.name ?? "More information", isPresented: $showingFacility, presenting: selectedFacility) { _ in
        } message: { facility in
            Text(facility.description)
        }
    }
}

// MARK: - PreviewProvider
struct ResortView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ResortView(resort: Resort.example)
        }
        .environmentObject(Favorites())
    }
}
