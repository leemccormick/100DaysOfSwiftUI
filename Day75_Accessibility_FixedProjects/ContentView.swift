//
//  ContentView.swift
//  Day75_Accessibility_FixedProjects
//
//  Created by Lee McCormick on 6/6/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                NavigationLink {
                    GuessTheFlagContentView()
                } label: {
                    Text("Fixing Guess the Flag")
                }
                NavigationLink {
                    WordScrambleContentView()
                } label: {
                    Text("Fixing Word Scramble")
                }
                NavigationLink {
                    BookWormContentView()
                } label: {
                    Text("Fixing Bookworm")
                }
            }
            .navigationTitle("Day75 : Accessibility_Fixing Projects")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
