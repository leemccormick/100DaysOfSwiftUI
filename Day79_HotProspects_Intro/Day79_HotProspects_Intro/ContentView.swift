//
//  ContentView.swift
//  Day79_HotProspects_Intro
//
//  Created by Lee McCormick on 6/28/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                NavigationLink {
                    HotSpospectsIntroView()
                } label: {
                    Text("Hot Prospects: Introduction")
                        .padding()
                }
                NavigationLink {
                    EnviromentView(user: User())
                } label: {
                    Text("Reading custom values from the environment with @EnvironmentObject")
                        .padding()
                }
                NavigationLink {
                    CreateTapView()
                } label: {
                    Text("Creating tabs with TabView and tabItem()")
                        .padding()
                }
            }
            .navigationTitle("Day 79: Hot Prospects : Intro")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
