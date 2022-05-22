//
//  ContentView.swift
//  Day69_BucketList_Part2
//
//  Created by Lee McCormick on 5/20/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                NavigationLink {
                    MapView()
                } label : {
                    Text("Integrating MapKit with SwiftUI")
                        .padding()
                }
                NavigationLink {
                    LocalBiometricView()
                } label : {
                    Text("Using Touch ID and Face ID with SwiftUI")
                        .padding()
                }
            }
            .navigationTitle("Day69 : BuckleList Part2")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
