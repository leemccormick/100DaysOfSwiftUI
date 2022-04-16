//
//  MissionView.swift
//  Day42_MoonShotWrapUp
//
//  Created by Lee McCormick on 4/11/22.
//

import SwiftUI

struct CrewMember {
    let role : String
    let astronaut : Astronaut
}

struct MissionView: View {
    let mission : Mission
    let crews : [CrewMember]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack{
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.8)
                        .padding(.top)
                    Text(mission.formattedLunchDateComplete) // Challenge 1 : Add the launch date
                        .font(.body.bold())
                        .padding(10)
                    Underline()
                    VStack(alignment: .leading) {
                        HStack {
                            TextTitle(titleString: "Crew") // Challenge 2 : New SwiftUI View
                                .padding(.trailing, 5)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(crews, id: \.role)  { crew in
                                        NavigationLink {
                                            AstronautView(astronaut: crew.astronaut)
                                        } label: {
                                            Image(crew.astronaut.id)
                                                .resizable()
                                                .frame(width: 100, height: 70)
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(.white.opacity(5)))
                                            VStack(alignment: .leading) {
                                                Text(crew.astronaut.name)
                                                    .foregroundColor(.white)
                                                    .font(.headline)
                                                Text(crew.role)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.lightBackground))
                                        .padding(10)
                                        .background(.lightBackground)
                                        .cornerRadius(10)
                                    }
                                }
                            }
                        }
                    }
                    Underline()  // Challenge 2 : New SwiftUI View
                    TextTitle(titleString: "Mission Hilight")  // Challenge 2 : New SwiftUI View
                    TextBody(bodyString: mission.description)  // Challenge 2 : New SwiftUI View
                    Underline()  // Challenge 2 : New SwiftUI View
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .navigationTitle("\(mission.displayName)")
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
    
    init(mission: Mission, astronuats: [String : Astronaut]) {
        self.mission = mission
        self.crews = mission.crew.map { member in
            if let astronaut = astronuats[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        }
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions : [Mission] = Bundle.main.decode("missions.json")
    static  let astronauts : [String : Astronaut] = Bundle.main.decode("astronauts.json")
    static var previews: some View {
        MissionView(mission: missions[0], astronuats: astronauts)
            .preferredColorScheme(.dark)
    }
}
