//
//  ContentView.swift
//  Day44_DrawingPart2
//
//  Created by Lee McCormick on 4/14/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                Text("Day44 : Drawing Part2")
                    .font(.largeTitle.bold())
                    .padding()
                NavigationLink {
                    TransformShapeView()
                } label: {
                    Text("Transforming shapes using CGAffineTransform and even-odd fills")
                }
                NavigationLink {
                    ImagePaintView()
                } label: {
                    Text("Creative borders and fills using ImagePaint")
                }
                NavigationLink {
                    DrawingGroupView()
                } label: {
                    Text("Enabling high-performance Metal rendering with drawingGroup()")
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
