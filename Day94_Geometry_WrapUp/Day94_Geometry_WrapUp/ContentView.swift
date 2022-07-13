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
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
    @State private var colorHue: Double = 0.0
    
    var body: some View {
        GeometryReader { fullView in
            ScrollView {
                ForEach(0..<50) { index in
                    GeometryReader { geo in
                        Text("Row # \(index)")
                            .font(.title)
                        // Challenge 2 : Make views adjust their scale depending on their vertical position, with views near the bottom being large and views near the top being small. I would suggest going no smaller than 50% of the regular size.
                            .frame(maxWidth: .infinity, maxHeight: abs(CGFloat(geo.frame(in: .global).maxY) * 0.15))
                            .background(colors[index % 7])
                            .rotation3DEffect(.degrees(geo.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x:0 ,y:1, z:0))
                        // Challenge 1 : Make views near the top of the scroll view fade out to 0 opacity – I would suggest starting at about 200 points from the top.
                            .opacity(geo.frame(in: .global).minY > 200 ? 1.0 : geo.frame(in: .global).minY > 150 ? 0.4 :
                                        geo.frame(in: .global).minY > 100 ? 0.2 :
                                        geo.frame(in: .global).minY > 50 ? 0.1 :
                                        geo.frame(in: .global).minY > 25 ? 0.05 :
                                        geo.frame(in: .global).minY > 0 ? 0.02 : 0)
                            .onTapGesture {
                                print("Color : \(colors[index % 7]) | Index : \(index)")
                                print("FullView.frame(in: .global) --> minY : \(fullView.frame(in: .global).minY) | midY : \(fullView.frame(in: .global).midY) | maxY : \(fullView.frame(in: .global).maxY)")
                                print("Geo.frame(in: .global)  --> minY : \(geo.frame(in: .global).minY) | midY : \(geo.frame(in: .global).midY) | maxY : \(geo.frame(in: .global).maxY)")
                                print("FullView.frame(in: .global) --> minX : \(fullView.frame(in: .global).minX) | midX : \(fullView.frame(in: .global).midX) | maxX : \(fullView.frame(in: .global).maxX)")
                                print("Geo.frame(in: .global) --> minX : \(geo.frame(in: .global).minX) | midX : \(geo.frame(in: .global).midY) | maxX : \(geo.frame(in: .global).maxX)")
                                print("FullView.frame(in: .local) --> minY : \(fullView.frame(in: .local).minY) | midY : \(fullView.frame(in: .local).midY) | maxY : \(fullView.frame(in: .local).maxY)")
                                print("Geo.frame(in: .local) --> minY : \(geo.frame(in: .local).minY) | midY : \(geo.frame(in: .local).midY) | maxY : \(geo.frame(in: .local).maxY)")
                                print("FullView.frame(in: .local) --> minX : \(fullView.frame(in: .local).minX) | midX : \(fullView.frame(in: .local).midX) | maxX : \(fullView.frame(in: .local).maxX)")
                                print("Geo.frame(in: .local) --> minX : \(geo.frame(in: .local).minX) | midX : \(geo.frame(in: .local).midY) | maxX : \(geo.frame(in: .local).maxX)")
                            }
                    }
                    .frame(height: 75)
                }
            }
            // Challenge 3 : For a real challenge make the views change color as you scroll. For the best effect, you should create colors using the Color(hue:saturation:brightness:) initializer, feeding in varying values for the hue.
            .onReceive(timer) { time in
                for i in 0..<colors.count {
                    if colorHue < 6 {
                        colorHue += 1
                    } else {
                        colorHue = 0
                    }
                    if colorHue == 0 {
                        colors[i] = Color.init(hue: 3.5/6, saturation: 1.0, brightness: 1.0, opacity: 1.0)
                    } else {
                        colors[i] = Color.init(hue: colorHue/6, saturation: 1.0, brightness: 1.0, opacity: 1.0)
                    }
                }
            }
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        colors.shuffle()
                    })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
