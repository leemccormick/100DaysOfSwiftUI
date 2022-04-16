//
//  ContentView.swift
//  Day45_DrawingPart3
//
//  Created by Lee McCormick on 4/14/22.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        NavigationView {
            Form {
                Text("Day45 : Drawing Part 3")
                    .font(.largeTitle.bold())

            NavigationLink {
                BlurBlendingView()
            } label: {
                Text("Special effects in SwiftUI: blurs, blending, and more")
            }
            NavigationLink {
                AnimationDataView()
            } label: {
                Text("Animating simple shapes with animatableData")
            }
            NavigationLink {
                AnimatablePairView()
            } label: {
                Text("Animating complex shapes with AnimatablePair")
            }
            NavigationLink {
                SpirographView()
            } label: {
                Text("Creating a spirograph with SwiftUI")
            }
            }
        }
       // .navigationBarTitle("Day45 : Drawing Part3")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

