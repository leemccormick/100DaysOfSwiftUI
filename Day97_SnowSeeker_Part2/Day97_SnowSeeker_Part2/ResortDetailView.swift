//
//  ResortDetailView.swift
//  Day97_SnowSeeker_Part2
//
//  Created by Lee McCormick on 7/15/22.
//

import SwiftUI

// MARK: - ResortDetailView
struct ResortDetailView: View {
    // MARK: - Properties
    let resort: Resort
    var size: String {
        //  ["Small", "Average", "Large"][resort.size - 1] --> This work but the app might crash if invalid value was use.
        switch resort.size {
        case 1:
            return "Small"
        case 2:
            return "Average"
        default:
            return "Large"
        }
    }
    var price: String {
        String(repeating: "$", count: resort.price) // Create the new string by repeating a substring a certain number of times.
    }
    
    // MARK: - Body
    var body: some View {
        Group { // Giving the whole Group an infinite maximum width means these views will spread out horizontally.
            VStack {
                Text("Size")
                    .font(.caption.bold())
                Text(size)
                    .font(.title3)
            }
            VStack {
                Text("Price")
                    .font(.caption.bold())
                Text(price)
                    .font(.title3)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - PreviewProvider
struct ResortDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ResortDetailView(resort: Resort.example)
    }
}
