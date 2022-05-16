//
//  ContentView.swift
//  Day64_InstaFilter_Part3
//
//  Created by Lee McCormick on 5/15/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                NavigationLink {
                    CoordinatorView()
                } label: {
                    Text("Using coordinators to manage SwiftUI view controllers")
                }
                NavigationLink {
                    SaveImageView()
                } label: {
                    Text("How to save images to the user’s photo library")
                }
            }
            .navigationTitle("Day64 : InstaFilter Part3")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
