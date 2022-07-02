//
//  ContentView.swift
//  Day81_HotProspects_Part3
//
//  Created by Lee McCormick on 6/29/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                NavigationLink {
                    ContextMenuView()
                } label: {
                    Text("Creating context menus")
                        .padding()
                }
                NavigationLink {
                    RowSwipeView()
                } label: {
                    Text("Adding custom row swipe actions to a List")
                        .padding()
                }
                NavigationLink {
                    NotificationView()
                } label: {
                    Text("Scheduling local notifications")
                        .padding()
                }
                NavigationLink {
                    PackageDependenciesView()
                } label: {
                    Text("Adding Swift package dependencies in Xcode")
                        .padding()
                }
            }
            .navigationTitle("Day 81 : HotProspects : Part3")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
