//
//  ContentView.swift
//  Day94_Geometry_WrapUp
//
//  Created by Lee McCormick on 7/12/22.
//

import SwiftUI

/*
 *** Challenge  ***
 1) Make views near the top of the scroll view fade out to 0 opacity – I would suggest starting at about 200 points from the top.
 2) Make views adjust their scale depending on their vertical position, with views near the bottom being large and views near the top being small. I would suggest going no smaller than 50% of the regular size.
 3) For a real challenge make the views change color as you scroll. For the best effect, you should create colors using the Color(hue:saturation:brightness:) initializer, feeding in varying values for the hue.
 
 - Each of those will require a little trial and error from you to find values that work well. Regardless, you should use max() to handle the scaling so that views don’t go smaller than half their size, and use min() with the hue so that hue values don’t go beyond 1.0.
 */

struct ContentView: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
  
    var body: some View {
        GeometryReader { fullView in
            ScrollView {
                ForEach(0..<50) { index in
                    GeometryReader { geo in
                        Text("Row # \(index)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .background(colors[index % 7])
                            .rotation3DEffect(.degrees(geo.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x:0 ,y:1, z:0))
                            // Challenge 1 : Make views near the top of the scroll view fade out to 0 opacity – I would suggest starting at about 200 points from the top.
                            .opacity(geo.frame(in: .global).minY > 200 ? 1.0 : geo.frame(in: .global).minY > 150 ? 0.4 :
                                geo.frame(in: .global).minY > 100 ? 0.2 :
                                geo.frame(in: .global).minY > 50 ? 0.1 : 0.05 )
                    }
                    .frame(height: 40)
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
