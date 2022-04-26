//
//  ContentView.swift
//  Day53_Bookworm_Part1
//
//  Created by Lee McCormick on 4/23/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                NavigationLink {
                    BindingView()
                } label : {
                    Text("Creating a custom component with @Binding")
                }
                NavigationLink {
                    MultilineInputView()
                } label : {
                    Text("Accepting multi-line text input with TextEditor")
                }
                NavigationLink {
                    CoreDataView()
                } label : {
                    Text("How to combine Core Data and SwiftUI")
                }
            }
            .navigationBarTitle("Day53 : Bookworm Part1")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

