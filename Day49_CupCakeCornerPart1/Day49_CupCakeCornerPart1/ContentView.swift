//
//  ContentView.swift
//  Day49_CupCakeCornerPart1
//
//  Created by Lee McCormick on 4/18/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                NavigationLink {
                    CupCakeCornerIntroView()
                } label: {
                    Text("Cupcake Corner: Introduction")
                }
                NavigationLink {
                    CodableConformanceView()
                } label: {
                    Text("Adding Codable conformance for @Published properties")
                }
                NavigationLink {
                    SendReceiveDataView()
                } label: {
                    Text("Sending and receiving Codable data with URLSession and SwiftUI")
                }
                NavigationLink {
                    LoadImageView()
                } label: {
                    Text("Loading an image from a remote server")
                }
                NavigationLink {
                    ValidateFormView()
                } label: {
                    Text("Validating and disabling forms")
                }
            }
            .navigationTitle("Day49 : Cupcake Corner Part1")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

