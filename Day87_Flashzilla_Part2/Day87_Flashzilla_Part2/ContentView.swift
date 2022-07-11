//
//  ContentView.swift
//  Day87_Flashzilla_Part2
//
//  Created by Lee McCormick on 7/10/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TimerView()
                .tabItem {
                    Label("Timer", systemImage: "book")
                }
            NotifiedBackgroundView()
                .tabItem {
                    Label("Notify BG", systemImage: "house")
                }
            AccessibilityView()
                .tabItem {
                    Label("Accessibility", systemImage: "pencil")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
