//
//  AstronautView.swift
//  Day41_MoonShotPart3
//
//  Created by Lee McCormick on 4/11/22.
//

import SwiftUI

// Start by making a new SwiftUI view called AstronautView. This will have a single Astronaut property so it knows what to show, then it will lay that out using a similar ScrollView/VStack combination as we had in MissionView. Give it this code:
struct AstronautView: View {
    let astronaut: Astronaut
    var body: some View {
        ScrollView {
            VStack {
                Image(astronaut.id)
                    .resizable()
                    .scaledToFit()
                Text(astronaut.description)
                    .padding()
            }
        }
        .background(.darkBackground)
        .navigationTitle(astronaut.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Once again we need to update the preview so that it creates its view with some data:
struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    static var previews: some View {
        AstronautView(astronaut: astronauts["aldrin"]!)
            .preferredColorScheme(.dark)
    }
}
