//
//  ContentView.swift
//  Day92_Geometry_Part1
//
//  Created by Lee McCormick on 7/12/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                NavigationLink {
                    IntroView()
                } label: {
                    Text("Layout and geometry: Introduction")
                        .font(.headline)
                        .padding()
                }
                NavigationLink {
                    LayoutView()
                } label: {
                    Text("How layout works in SwiftUI")
                        .font(.headline)
                        .padding()
                }
                NavigationLink {
                    AlignmentView()
                } label: {
                    Text("Alignment and alignment guides")
                        .font(.headline)
                        .padding()
                }
                NavigationLink {
                    CustomAlignmentView()
                } label: {
                    Text("How to create a custom alignment guide")
                        .font(.headline)
                        .padding()
                }
                NavigationLink {
                    FontView()
                } label: {
                    Text("Example Font in SwiftUI")
                        .font(.headline)
                        .padding()
                }
            }
            .navigationTitle("Day92 : Geometry Part 1")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
