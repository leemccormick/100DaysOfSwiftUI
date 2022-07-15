//
//  ResortView.swift
//  Day97_SnowSeeker_Part2
//
//  Created by Lee McCormick on 7/15/22.
//

import SwiftUI

// MARK: - ResortView
struct ResortView: View {
    let resort: Resort
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Image
                Image(decorative: resort.id) // If you create these images using something like Image("star") the screen reader will read them out as part of its standard UI pass. A better idea is to create them using using the Image(decorative:) initializer, which tells SwiftUI the image shouldn’t be exposed to the screen reader.
                    .resizable()
                    .scaledToFit()
                
                // Resort Detail View and Ski Detail View
                HStack {
                    ResortDetailView(resort: resort)
                    SkiDetailsView(resort: resort)
                }
                .padding(.vertical)
                .background(Color.primary.opacity(0.1))
                
                // Group of Description and Facilities
                Group {
                    Text(resort.description)
                        .padding(.vertical)
                    Text("Facilities")
                        .font(.headline)
                    Text(resort.facilities, format: .list(type: .and)) // This is similar to using joined(separator:), but rather than sending back “A, B, C” like we have right now, we get back “A, B, and C” – it’s more natural to read. Notice how the .and type is there? That’s because you can also use .or to get “A, B, or C” if that’s what you want.
                        .padding(.vertical)  // == Text(resort.facilities.joined(separator: ", "))
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("\(resort.name), \(resort.country)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - PreviewProvider
struct ResortView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ResortView(resort: Resort.example)
        }
    }
}
