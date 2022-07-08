//
//  ContentView.swift
//  Day85_HotProspects_WrapUp
//
//  Created by Lee McCormick on 7/7/22.
//

import SwiftUI

/*
 *** Challenge ***
 One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on.
 
 1) Add an icon to the “Everyone” screen showing whether a prospect was contacted or not.
 2) Use JSON and the documents directory for saving and loading our user data.
 3) Use a confirmation dialog to customize the way users are sorted in each tab – by name or by most recent.
 */

struct ContentView: View {
    @StateObject var prospects = Prospects()
    var body: some View {
        TabView {
            ProspectsView(filter: .none)
                .tabItem {
                    Label("Everyone", systemImage: "person.3")
                }
            ProspectsView(filter: .contacted)
                .tabItem {
                    Label("Contacted", systemImage: "checkmark.circle")
                }
            ProspectsView(filter: .uncontacted)
                .tabItem {
                    Label("Uncontacted", systemImage: "questionmark.diamond")
                }
            MeView()
                .tabItem {
                    Label("Me", systemImage: "person.crop.square")
                }
        }
        .environmentObject(prospects)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
