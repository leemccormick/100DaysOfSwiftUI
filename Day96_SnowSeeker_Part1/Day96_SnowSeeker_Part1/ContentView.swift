//
//  ContentView.swift
//  Day96_SnowSeeker_Part1
//
//  Created by Lee McCormick on 7/15/22.
//

import SwiftUI

// MARK: - ContentView
struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                NavigationLink {
                    IntroView()
                } label: {
                    Text("SnowSeeker: Introduction")
                        .padding()
                }
                NavigationLink {
                    TwoSideView()
                } label: {
                    Text("Working with two side by side views in SwiftUI")
                        .padding()
                }
                NavigationLink {
                    AlertSheetView()
                } label: {
                    Text("Using alert() and sheet() with optionals")
                        .padding()
                }
                NavigationLink {
                    TransparentLayoutView()
                } label: {
                    Text("Using groups as transparent layout containers")
                        .padding()
                }
                NavigationLink {
                    SearchableView()
                } label: {
                    Text("Making a SwiftUI view searchable")
                        .padding()
                }
            }
            .navigationTitle("Day96 SnowSeeker : Part1")
        }
    }
}

// MARK: - PreviewProvider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
