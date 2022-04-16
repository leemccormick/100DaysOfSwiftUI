//
//  AstronautView.swift
//  Day42_MoonShotWrapUp
//
//  Created by Lee McCormick on 4/11/22.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                TextTitle(titleString: astronaut.name)
                Image(astronaut.id)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding(15)
                Spacer()
                VStack(alignment: .center, spacing: 20) {
                    TextBody(bodyString: astronaut.description)
                }
                .frame(width: geometry.size.width * 0.85)
                .padding(10)
                .background(.lightBackground)
                .cornerRadius(10)
            }
        }
        .navigationTitle("\(astronaut.id)")
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [String :Astronaut] = Bundle.main.decode("astronauts.json")
    static var previews: some View {
        AstronautView(astronaut: astronauts["aldrin"]!)
            .preferredColorScheme(.dark)
    }
}
