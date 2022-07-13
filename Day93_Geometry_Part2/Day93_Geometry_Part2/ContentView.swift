//
//  ContentView.swift
//  Day93_Geometry_Part2
//
//  Created by Lee McCormick on 7/12/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            AbsolutePositionView()
                .tabItem {
                    Label("Abs Position", systemImage: "book")
                }
            FrameAndCoodinatesView()
                .tabItem {
                    Label("Frame Coordinates", systemImage: "pencil")
                }
            ScrollEffectsView()
                .tabItem {
                    Label("Scroll Effects", systemImage: "square")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
