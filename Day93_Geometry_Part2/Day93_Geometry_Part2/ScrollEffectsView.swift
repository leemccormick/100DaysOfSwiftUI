//
//  ScrollEffectsView.swift
//  Day93_Geometry_Part2
//
//  Created by Lee McCormick on 7/12/22.
//

import SwiftUI

struct ScrollEffectsView: View {
    let topic = "ScrollView effects using GeometryReader"
    let info = """
    When we use the frame(in:) method of a GeometryProxy, SwiftUI will calculate the view’s current position in the coordinate space we ask for. However, as the view moves those values will change, and SwiftUI will automatically make sure GeometryReader stays updated.
    
    Previously we used DragGesture to store a width and height as an @State property, because it allowed us to adjust other properties based on the drag amount to create neat effects. However, with GeometryReader we can grab values from a view’s environment dynamically, feeding in its absolute or relative position into various modifiers. Even better, you can nest geometry readers if needed, so that one can read the geometry for a higher-up view and the other can read the geometry for something further down the tree.
    
    To try some effects with GeometryReader, we could create a spinning helix effect by creating 50 text views in a vertical scroll view, each of which an infinite maximum width so they take up all the screen space, then apply a 3D rotation effect based on their own position.
    
    Start by making a basic ScrollView of text views with varying background colors:
    
    struct ContentView: View {
        let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
    
        var body: some View {
            ScrollView {
                ForEach(0..<50) { index in
                    GeometryReader { geo in
                        Text("Row #\'(index)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .background(colors[index % 7])
                    }
                    .frame(height: 40)
                }
            }
        }
    }
    To apply a helix-style spinning effect, place this rotation3DEffect() directly below the background() modifier:
    
    .rotation3DEffect(.degrees(geo.frame(in: .global).minY / 5), axis: (x: 0, y: 1, z: 0))
    When you run that back you’ll see that text views at the bottom of the screen are flipped, those at the center are rotated about 90 degrees, and those at the very top are normal. More importantly, as you scroll around they all rotate as you move in the scroll view.
    
    That’s a neat effect, but it’s also problematic because the views only reach their natural orientation when they are at the very top – it’s really hard to read. To fix this, we can apply a more complex rotation3DEffect() that subtracts half the height of the main view, but that means using a second GeometryReader to get the size of the main view:
    
    struct ContentView: View {
        let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
    
        var body: some View {
            GeometryReader { fullView in
                ScrollView {
                    ForEach(0..<50) { index in
                        GeometryReader { geo in
                            Text("Row #\'(index)")
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .background(colors[index % 7])
                                .rotation3DEffect(.degrees(geo.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x: 0, y: 1, z: 0))
                        }
                        .frame(height: 40)
                    }
                }
            }
        }
    }
    With that in place, the views will reach a natural orientation nearer the center of the screen, which will look better.
    
    We can use a similar technique to create CoverFlow-style scrolling rectangles:
    
    struct ContentView: View {
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(1..<20) { num in
                        GeometryReader { geo in
                            Text("Number \'(num)")
                                .font(.largeTitle)
                                .padding()
                                .background(.red)
                                .rotation3DEffect(.degrees(-geo.frame(in: .global).minX) / 8, axis: (x: 0, y: 1, z: 0))
                                .frame(width: 200, height: 200)
                        }
                        .frame(width: 200, height: 200)
                    }
                }
            }
        }
    }
    There are so many interesting and creative ways to make special effects with GeometryReader – I hope you can take the time to experiment!
    
    
    """
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]
    
    var body: some View {
        VStack {
            // Topic
            Text(topic)
                .font(.largeTitle)
            
            // Vertical ScrollView
            GeometryReader { fullView in
                ScrollView {
                    // Row
                    ForEach(0..<50) { index in
                        GeometryReader { geo in
                            Text("Row # \(index)")
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .background(colors[index % 7])
                                .rotation3DEffect(.degrees(geo.frame(in: .global).minY - fullView.size.height / 2)  / 5, axis: (x: 0, y: 1, z: 0))
                        }
                        .frame(height: 40)
                    }
                    // Info
                    Text(info)
                        .font(.body)
                        .padding()
                }
            }
            
            // Horizontal ScrollView
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(1..<20) { num in
                        GeometryReader { geo in
                            Text("Number \(num)")
                                .font(.largeTitle)
                                .padding()
                                .background(.red)
                                .rotation3DEffect(.degrees(-geo.frame(in: .global).minX) / 8, axis: (x: 0, y: 1, z: 0))
                                .frame(width: 200, height: 200)
                        }
                        .frame(width: 200, height: 200)
                    }
                }
            }
        }
    }
}

struct ScrollEffectsView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollEffectsView()
    }
}
