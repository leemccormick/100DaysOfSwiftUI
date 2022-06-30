//
//  ContentView.swift
//  Day80_HotProspects_Part2
//
//  Created by Lee McCormick on 6/28/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                NavigationLink {
                    ObservableObjectChangeView()
                } label: {
                    Text("Manually publishing ObservableObject changes")
                        .padding()
                }
                NavigationLink {
                    SwiftResultView()
                } label: {
                    Text("Understanding Swift’s Result type")
                        .padding()
                }
                NavigationLink {
                    ImageInterpolationView()
                } label: {
                    Text("Controlling image interpolation in SwiftUI")
                        .padding()
                }
            }
            .navigationTitle("Day 80 : Hot Prospects : Part2")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
