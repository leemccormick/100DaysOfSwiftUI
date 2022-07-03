//
//  ContentView.swift
//  Day82_HotProspects_Part4
//
//  Created by Lee McCormick on 7/2/22.
//

import SwiftUI

struct ContentView: View {
    // Now, we want all our ProspectsView instances to share a single instance of the Prospects class, so they are all pointing to the same data. If we were writing UIKit code here I’d go into long explanation about how difficult this is to get right and how careful we need to be to ensure all changes get propagated cleanly, but with SwiftUI it requires just three steps.
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
        .environmentObject(prospects) // Second, we need to post that property into the SwiftUI environment, so that all child views can access it. Because tabs are considered children of the tab view they are inside, if we add it to the environment for the TabView then all our ProspectsView instances will get that object.
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
