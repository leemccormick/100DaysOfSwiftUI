//
//  ContentView.swift
//  Day39_MoonShotPart1
//
//  Created by Lee McCormick on 4/8/22.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            Form {
                NavigationLink {
                    GeometryReaderView()
                } label: {
                    Text("Resizing images to fit the screen using GeometryReader")
                }
                NavigationLink {
                    ScrollingDataView()
                } label: {
                    Text("How ScrollView lets us work with scrolling data")
                }
                NavigationLink {
                    PushViewNavigationLink()
                } label: {
                    Text("Pushing new views onto the stack using NavigationLink")
                }
                NavigationLink {
                    CodableDataView()
                } label: {
                    Text("Working with hierarchical Codable data")
                }
                NavigationLink {
                    ScrollingGridView()
                } label: {
                    Text("How to lay out views in a scrolling grid")
                }
            }
            .navigationTitle("Day38 MoonShot Part1")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
