//
//  SkiDetailView.swift
//  Day99_SnowSeeker_WrapUp
//
//  Created by Lee McCormick on 7/15/22.
//

import SwiftUI

// MARK: - SkiDetailView
struct SkiDetailView: View {
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
struct SkiDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SkiDetailView(resort: Resort.example)
    }
}
