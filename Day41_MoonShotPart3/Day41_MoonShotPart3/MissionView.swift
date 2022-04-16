//
//  MissionView.swift
//  Day41_MoonShotPart3
//
//  Created by Lee McCormick on 4/11/22.
//

import SwiftUI

// So, what we need to do is make our MissionView accept the mission that got tapped, along with our full astronauts dictionary, then have it figure out which astronauts actually took part in the launch.
struct CrewMember {
    let role: String
    let astronaut: Astronaut
}

// In terms of layout, this thing needs to have a scrolling VStack with a resizable image for the mission badge, then a text view. We’ll use GeometryReader to set the maximum width of the mission image, although through some trial and error I found that the mission badge worked best when it wasn’t full width – somewhere between 50% and 70% width looked better, to avoid it becoming weirdly big on the screen.
struct MissionView: View {
    let mission: Mission
    let crew: [CrewMember] // Now for the tricky part: we need to add a property to MissionView that stores an array of CrewMember objects – these are the fully resolved role / astronaut pairings. At first that’s as simple as adding another property:
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.6)
                        .padding(.top)
                    VStack(alignment: .leading) {
                        // To finish up this view, I’m going to add a title before our crew, but this needs to be done carefully. You see, although this relates to the scroll view, it needs to have the same padding as the rest of our text. So, the best place for this is inside the VStack, directly after the previous rectangle:
                        VStack(alignment: .leading) {
                            Text("Crew : ")
                                .font(.title.bold())
                                .padding(.bottom, 5)
                            // Now that we have all our astronaut data, we can show this directly below the mission description using a horizontal scroll view. We’re also going to add a little extra styling to the astronaut pictures to make them look better, using a capsule clip shape and overlay.
                            ScrollView(.horizontal, showsIndicators: false) {
                                
                                HStack {
                                    ForEach(crew, id: \.role) { crewMember in
                                        NavigationLink {
                                            // Text("Astronaut details")
                                            AstronautView(astronaut: crewMember.astronaut)
                                        } label: {
                                            HStack {
                                                Image(crewMember.astronaut.id)
                                                    .resizable()
                                                    .frame(width: 104, height: 72)
                                                    .clipShape(Circle())
                                                    .overlay(Circle().stroke(.white, lineWidth: 1))
                                                //.clipShape(Capsule())
                                                // .overlay(Capsule().stroke(.white, lineWidth: 1))
                                                VStack(alignment: .leading) {
                                                    Text(crewMember.astronaut.name)
                                                        .foregroundColor(.white)
                                                        .font(.headline)
                                                    Text(crewMember.role)
                                                        .foregroundColor(.secondary)
                                                }
                                            }
                                            .padding()
                                        }
                                    }
                                }
                            }
                        }
                        // SwiftUI does provide a dedicated Divider view for creating a visual divide in your layout, but it’s not customizable – it’s always just a skinny line. So, to get something a little more useful, I’m going to draw a custom divider to break up our view.
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.lightBackground)
                            .padding(.vertical)
                        // Another detail not in scrollview horizatal
                        Text("Mission Highlights : ")
                            .font(.title.bold())
                            .padding(.bottom, 5)
                        Text(mission.description)
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.lightBackground)
                            .padding(.vertical) // Now place another one of those – the same code – directly after the mission.description text. Much better!
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
    
    // But then how do we set that property? Well, think about it: if we make this view be handed its mission and all astronauts, we can loop over the mission crew, then for each crew member look in the dictionary to find the one that has a matching ID. When we find one we can convert that and their role into a CrewMember object, but if we don’t it means somehow we have a crew role with an invalid or unknown name. That latter case should never happen. To be clear, if you’ve added some JSON to your project that points to missing data in your app, you’ve made a fundamental mistake – it’s not the kind of thing you should try to write error handling for at runtime, because it should never be allowed to happen in the first place. So, this is a great example of where fatalError() is useful: if we can’t find an astronaut using their ID, we should exit immediately and complain loudly. Let’s put all that into code, using a custom initializer for MissionView. Like I said, this will accept the mission it represents along with all the astronauts, and its job is to store the mission away then figure out the array of resolved astronauts.
    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.mission = mission
        self.crew = mission.crew.map { member in
            if let astronaut = astronauts[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        }
    }
}

// Anyway, with that new view in place the code will no longer build, all because of the previews struct below it – that thing needs a Mission object passed in so it has something to render. Fortunately, our Bundle extension is available here as well:
struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")// As soon as that code is in, our preview struct will stop working again because it needs more information. So, add a second call to decode() there so it loads all the astronauts, then passes those in too:
    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts)
            .preferredColorScheme(.dark)
        // Tip: This view will automatically have a dark color scheme because it’s applied to the NavigationView in ContentView, but the MissionView preview doesn’t know that so we need to enable it by hand.
    }
}
