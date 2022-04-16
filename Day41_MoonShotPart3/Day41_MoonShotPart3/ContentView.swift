//
//  ContentView.swift
//  Day41_MoonShotPart3
//
//  Created by Lee McCormick on 4/11/22.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let colunms = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: colunms) {
                    ForEach(missions) { mission in
                        NavigationLink {
                            // Text("Detail View For : \(mission.displayName)")
                            // We’ll make that NavigationLink do something more useful shortly, but first we need to modify the NavigationLink in ContentView – it pushes to Text("Detail View") right now, but please replace it with this:
                            MissionView(mission: mission, astronauts: astronauts)
                        } label : {
                            VStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100, alignment: .center)
                                VStack {
                                    Text(mission.displayName)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text(mission.formattedLunchDate)
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(.lightBackground)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(.lightBackground))
                        .padding()
                    }
                }
                .padding([.horizontal, .bottom])
            }
            .navigationBarTitle("MoonShot Part3")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

