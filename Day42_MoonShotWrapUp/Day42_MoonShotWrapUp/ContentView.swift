//
//  ContentView.swift
//  Day42_MoonShotWrapUp
//
//  Created by Lee McCormick on 4/11/22.
//
/*
 *** Challenge ***
 1) Add the launch date to MissionView, below the mission badge. You might choose to format this differently given that more space is available, but it’s down to you.
 2) Extract one or two pieces of view code into their own new SwiftUI views – the horizontal scroll view in MissionView is a great candidate, but if you followed my styling then you could also move the Rectangle dividers out too.
 3) For a tough challenge, add a toolbar item to ContentView that toggles between showing missions as a grid and as a list.
 */
import SwiftUI

//  Challenge 3 : Toolbar Show Grid and List
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
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(.lightBackground))
                    .padding()
                }
            }
            .padding([.horizontal, .bottom])
        }
    }
}

struct ContentView: View {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    @State private var showGrid = true
    var body: some View {
        //  Challenge 3 : Toolbar Show Grid and List
        if showGrid {
            NavigationView {
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
            }
        } else {
            NavigationView {
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
