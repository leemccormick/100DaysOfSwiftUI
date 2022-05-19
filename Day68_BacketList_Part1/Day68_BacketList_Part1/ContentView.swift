//
//  ContentView.swift
//  Day68_BacketList_Part1
//
//  Created by Lee McCormick on 5/18/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                NavigationLink {
                    IntroductionView()
                } label : {
                    Text("Bucket List: Introduction")
                        .padding()
                }
                NavigationLink {
                    ComparableView()
                } label : {
                    Text("Adding conformance to Comparable for custom types")
                        .padding()
                }
                NavigationLink {
                    DocDirectoryView()
                } label : {
                    Text("Writing data to the documents directory")
                        .padding()
                }
                NavigationLink {
                    ViewStateEnumView()
                } label : {
                    Text("Switching view states with enums")
                        .padding()
                }
            }
            .navigationTitle("Day68 : Backet List Part1")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
