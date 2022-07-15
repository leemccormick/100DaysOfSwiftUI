//
//  SkiDetailsView.swift
//  Day97_SnowSeeker_Part2
//
//  Created by Lee McCormick on 7/15/22.
//

import SwiftUI

// MARK: - SkiDetailsView
struct SkiDetailsView: View {
    let resort: Resort
    
    // MARK: - Body
    var body: some View {
        Group {
            VStack {
                Text("Elevation")
                    .font(.caption.bold())
                Text("\(resort.elevation)")
                    .font(.title3)
            }
            VStack {
                Text("Snow")
                    .font(.caption.bold())
                Text("\(resort.snowDepth)cm")
                    .font(.title3)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - PreviewProvider
struct SkiDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SkiDetailsView(resort: Resort.example)
    }
}
