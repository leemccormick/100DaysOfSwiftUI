//
//  ContentView.swift
//  Day86_Flashzilla_Intro
//
//  Created by Lee McCormick on 7/8/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            IntroView()
                .tabItem {
                    Label("Intro", systemImage: "star")
                }
            GesturesView()
                .tabItem {
                    Label("Gestures", systemImage: "circle")
                }
            VibrationsView()
                .tabItem {
                    Label("Vibrations", systemImage: "book")
                }
            AllowsHitTestingView()
                .tabItem {
                    Label("Hit", systemImage: "pencil")
                }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
