//
//  ContentView.swift
//  Day48_ExpandingYourHorizons
//
//  Created by Lee McCormick on 4/19/22.
//

import SwiftUI
struct DetailView: View {
    let text : String
    var body: some View {
        ScrollView {
            Text(text)
        }
    }
}

struct ContentView: View {
    @State private var detailData = DetailData()
    var body: some View {
        NavigationView {
            Form {
                NavigationLink {
                    DetailView(text: detailData.valueType)
                } label: {
                    Text("Value Types")
                }
                NavigationLink {
                    DetailView(text: detailData.optionals)
                } label: {
                    Text("Optional")
                }
                NavigationLink {
                    DetailView(text: detailData.protocols)
                } label: {
                    Text("Protocols")
                }
                NavigationLink {
                    DetailView(text: detailData.forceUnwrap)
                } label: {
                    Text("Force upwraps")
                }
                NavigationLink {
                    DetailView(text: detailData.architecture)
                } label: {
                    Text("Architecture")
                }
            }
            .navigationBarTitle("Day48: Expanding Your Horizons")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
