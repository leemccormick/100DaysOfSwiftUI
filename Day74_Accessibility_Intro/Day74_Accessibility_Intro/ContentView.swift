//
//  ContentView.swift
//  Day74_Accessibility_Intro
//
//  Created by Lee McCormick on 6/1/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                NavigationLink {
                    IntroView()
                } label: {
                    Text("Accessibility: Introduction")
                        .padding()
                }
                NavigationLink {
                    IdentifyView()
                } label: {
                    Text("Identifying views with useful labels")
                        .padding()
                }
                NavigationLink {
                    HidingAndGroupingView()
                } label: {
                    Text("Hiding and grouping accessibility data")
                        .padding()
                }
                NavigationLink {
                    ReadingView()
                } label: {
                    Text("Reading the value of controls")
                        .padding()
                }
            }
            .navigationTitle("Day74 : Accessibility")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
