//
//  ContentView.swift
//  Day62_Instafilter_Part1
//
//  Created by Lee McCormick on 5/14/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                NavigationLink {
                    InstaFilterIntroView()
                } label: {
                    Text("Instafilter: Introduction")
                }
                NavigationLink {
                    StructPropertyWrapperView()
                } label: {
                    Text("How property wrappers become structs")
                }
                NavigationLink {
                    OnChangeView()
                } label: {
                    Text("Responding to state changes using onChange()")
                }
                NavigationLink {
                    ConfirmationDialogView()
                } label: {
                    Text("Showing multiple options with confirmationDialog()")
                }
            }
            .navigationTitle("Day62 : InstaFilter Part1")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
