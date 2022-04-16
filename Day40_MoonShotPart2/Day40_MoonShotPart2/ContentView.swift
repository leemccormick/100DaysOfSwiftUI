//
//  ContentView.swift
//  Day40_MoonShotPart2
//
//  Created by Lee McCormick on 4/9/22.
//

import SwiftUI

struct ContentView: View {
    // let astronauts = Bundle.main.decode("astronauts.json") // Add this property to the ContentView struct now:
    // We know it will still return a dictionary of astronauts because the actual underlying data hasn’t changed, but Swift doesn’t know that. Our problem is that decode() can return any type that conforms to Codable, but Swift needs more information – it wants to know exactly what type it will be. So, to fix this we need to use a type annotation so Swift knows exactly what astronauts will be:
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        //  Text("\(astronauts.count)")
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(missions) { mission in
                        NavigationLink {
                            Text("Detail view")
                        } label: {
                            VStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                
                                VStack {
                                    Text(mission.displayName)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    // Text(mission.launchDate ?? "N/A")
                                    Text(mission.formattedLaunchDate)
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
                                    .stroke(.lightBackground)) // Draw a line with stroke and overlay
                        .padding() // Next, I want to make the outer VStack – the one that is the whole label for our NavigationLink – look more like a box in our grid, which means drawing a line around it and clipping the shape just a little. To get that effect, add these modifiers to the end of it:
                    }
                }
                .padding([.horizontal, .bottom])
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark) // To fix this, we can tell SwiftUI our view prefers to be in dark mode always – this will cause the title to be in white no matter what, and will also darken other colors such as navigation bar backgrounds.
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
