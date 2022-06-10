//
//  MoonshotContentView.swift
//  Day76_Accessibility_WrapUp
//
//  Created by Lee McCormick on 6/9/22.
//

import SwiftUI

/*
 *** Challenge ***
 3) Do a full accessibility review of Moonshot – what changes do you need to make so that it’s fully accessible?
 */

struct ListMission: View {
    let missions: [Mission]
    let astronauts: [String: Astronaut]
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                ForEach(missions) { mission in
                    NavigationLink {
                        MissionView(mission: mission, astronuats: astronauts)
                    } label: {
                        HStack(alignment: .center, spacing: 10) {
                            Image(mission.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60, alignment: .center)
                                .padding()
                            VStack(spacing: 10) {
                                Text(mission.displayName)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                Text(mission.formattedLunchDate)
                                    .foregroundColor(.white.opacity(0.5))
                                    .font(.caption)
                            }
                            .frame(width: geometry.size.width * 0.6, height: geometry.size.height * 0.1, alignment: .center)
                            .background(.lightBackground)
                            .cornerRadius(10)
                            .padding(5)
                        }
                        // Challenge 3 : Do a full accessibility review of Moonshot – what changes do you need to make so that it’s fully accessible?
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("\(mission.displayName). Lunch Date on : \(mission.formattedLunchDate)")
                    }
                }
            }
            .frame(width: geometry.size.width, alignment: .center)
        }
    }
}

struct GridMission: View {
    let columns: [GridItem]
    let missions: [Mission]
    let astronauts: [String: Astronaut]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(missions) { mission in
                    NavigationLink  {
                        MissionView(mission: mission, astronuats: astronauts)
                    } label : {
                        VStack {
                            Image(mission.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100, alignment: .center)
                            VStack {
                                Text(mission.displayName)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                Text(mission.formattedLunchDate)
                                    .foregroundColor(.white.opacity(0.5))
                                    .font(.caption)
                            }
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background(.lightBackground)
                        }
                    }
                    // Challenge 3 : Do a full accessibility review of Moonshot – what changes do you need to make so that it’s fully accessible?
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("\(mission.displayName). Lunch Date on : \(mission.formattedLunchDate)")
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(.lightBackground))
                    .padding()
                }
            }
            .padding([.horizontal, .bottom])
        }
    }
}

struct MoonshotContentView: View {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    @State private var showGrid = true
    var body: some View {
        //  Challenge 3 : Toolbar Show Grid and List
        if showGrid {
            GridMission(columns: columns, missions: missions, astronauts: astronauts)
                .navigationTitle("Moon Shot Wrap Up")
                .background(.darkBackground)
                .preferredColorScheme(.dark)
                .toolbar {
                    Button() {
                        showGrid.toggle()
                    } label: {
                        Image(systemName: showGrid ? "square.grid.2x2" : "list.bullet.rectangle")
                            .foregroundColor(.white)
                    }
                }
        } else {
            ListMission(missions: missions, astronauts: astronauts)
                .navigationTitle("Moon Shot Wrap Up")
                .background(.darkBackground)
                .preferredColorScheme(.dark)
                .toolbar {
                    Button() {
                        showGrid.toggle()
                    } label: {
                        Image(systemName: showGrid ? "square.grid.2x2" : "list.bullet.rectangle")
                            .foregroundColor(.white)
                }
            }
        }
    }
}

struct MoonshotContentView_Previews: PreviewProvider {
    static var previews: some View {
        MoonshotContentView()
    }
}

