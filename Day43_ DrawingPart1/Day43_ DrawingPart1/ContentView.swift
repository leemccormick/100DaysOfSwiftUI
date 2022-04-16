//
//  ContentView.swift
//  Day43_ DrawingPart1
//
//  Created by Lee McCormick on 4/13/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                Text("Day43 : Drawing Part1")
                    .font(.largeTitle.bold())
                    .padding()
                NavigationLink {
                   DrawingIntroView()
                } label: {
                    Text("Drawing: Introduction")
                }
                NavigationLink {
                    CustomPathView()
                } label: {
                    Text("Creating custom paths with SwiftUI")
                }
                NavigationLink {
                    PathsVsShapesView()
                } label: {
                    Text("Paths vs shapes in SwiftUI")
                }
                NavigationLink {
                    StrokeBorderView()
                } label: {
                    Text("Adding strokeBorder() support with InsettableShape")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
