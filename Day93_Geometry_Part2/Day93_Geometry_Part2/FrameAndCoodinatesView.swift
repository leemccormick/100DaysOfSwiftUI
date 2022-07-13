//
//  FrameAndCoodinatesView.swift
//  Day93_Geometry_Part2
//
//  Created by Lee McCormick on 7/12/22.
//

import SwiftUI

// MARK: - OuterView
struct OuterView: View {
    var body: some View {
        VStack {
            Text("Top")
            InnerView()
                .background(.green)
            Text("Bottom")
        }
    }
}

// MARK: - InnerView
struct InnerView: View {
    var body: some View {
        HStack {
            Text("Left")
            GeometryReader { geo in
                Text("Center")
                    .background(.blue)
                    .onTapGesture {
                        print("Global Center : \(geo.frame(in: .global).midX) x \(geo.frame(in: .global).midY)")
                        print("Local Center : \(geo.frame(in: .local).midX) x \(geo.frame(in: .local).midY)")
                        print("Custom Center : \(geo.frame(in: .named("Custom")).midX) x \(geo.frame(in: .named("Custom")).midY)")
                    }
            }
            .background(.orange)
            Text("Right")
        }
    }
}

// MARK: - FrameAndCoodinatesView
struct FrameAndCoodinatesView: View {
    let topic = "Understanding frames and coordinates inside GeometryReader"
    let info = """
    SwiftUI’s GeometryReader allows us to use its size and coordinates to determine a child view’s layout, and it’s the key to creating some of the most remarkable effects in SwiftUI.
    
    You should always keep in mind SwiftUI’s three-step layout system when working with GeometryReader: parent proposes a size for the child, the child uses that to determine its own size, and parent uses that to position the child appropriately.
    
    In its most basic usage, what GeometryReader does is let us read the size that was proposed by the parent, then use that to manipulate our view. For example, we could use GeometryReader to make a text view have 90% of all available width regardless of its content:
    
    struct ContentView: View {
        var body: some View {
            GeometryReader { geo in
                Text("Hello, World!")
                    .frame(width: geo.size.width * 0.9)
                    .background(.red)
            }
        }
    }
    That geo parameter that comes in is a GeometryProxy, and it contains the proposed size, any safe area insets that have been applied, plus a method for reading frame values that we’ll look at in a moment.
    
    GeometryReader has an interesting side effect that might catch you out at first: the view that gets returned has a flexible preferred size, which means it will expand to take up more space as needed. You can see this in action if you place the GeometryReader into a VStack then put some more text below it, like this:
    
    struct ContentView: View {
        var body: some View {
            VStack {
                GeometryReader { geo in
                    Text("Hello, World!")
                        .frame(width: geo.size.width * 0.9, height: 40)
                        .background(.red)
                }
    
                Text("More text")
                    .background(.blue)
            }
        }
    }
    You’ll see “More text” gets pushed right to the bottom of the screen, because the GeometryReader takes up all remaining space. To see it in action, add background(.green) as a modifier to the GeometryReader and you’ll see just how big it is. Note: This is a preferred size, not an absolute size, which means it’s still flexible depending on its parent.
    
    When it comes to reading the frame of a view, GeometryProxy provides a frame(in:) method rather than simple properties. This is because the concept of a “frame” includes X and Y coordinates, which don’t make any sense in isolation – do you want the view’s absolute X and Y coordinates, or their X and Y coordinates compared to their parent?
    
    SwiftUI calls these options coordinate spaces, and those two in particular are called the global space (measuring our view’s frame relative to the whole screen), and the local space (measuring our view’s frame relative to its parent). We can also create custom coordinate spaces by attaching the coordinateSpace() modifier to a view – any children of that can then read its frame relative to that coordinate space.
    
    To demonstrate how coordinate spaces work, we could create some example views in various stacks, attach a custom coordinate space to the outermost view, then add an onTapGesture to one of the views inside it so it can print out the frame globally, locally, and using the custom coordinate space.
    
    Try this code:
    
    struct OuterView: View {
        var body: some View {
            VStack {
                Text("Top")
                InnerView()
                    .background(.green)
                Text("Bottom")
            }
        }
    }
    
    struct InnerView: View {
        var body: some View {
            HStack {
                Text("Left")
                GeometryReader { geo in
                    Text("Center")
                        .background(.blue)
                        .onTapGesture {
                            print("Global center: \'(geo.frame(in: .global).midX) x \'(geo.frame(in: .global).midY)")
                            print("Custom center: \'(geo.frame(in: .named("Custom")).midX) x \'(geo.frame(in: .named("Custom")).midY)")
                            print("Local center: \'(geo.frame(in: .local).midX) x \'(geo.frame(in: .local).midY)")
                        }
                }
                .background(.orange)
                Text("Right")
            }
        }
    }
    
    struct ContentView: View {
        var body: some View {
            OuterView()
                .background(.red)
                .coordinateSpace(name: "Custom")
        }
    }
    The output you get when that code runs depends on the device you’re using, but here’s what I got:
    
    Global center: 189.83 x 430.60
    Custom center: 189.83 x 383.60
    Local center: 152.17 x 350.96
    Those sizes are mostly different, so hopefully you can see the full range of how these frame work:
    
    A global center X of 189 means that the center of the geometry reader is 189 points from the left edge of the screen.
    A global center Y of 430 means the center of the text view is 430 points from the top edge of the screen. This isn’t dead in the center of the screen because there is more safe area at the top than the bottom.
    A custom center X of 189 means the center of the text view is 189 points from the left edge of whichever view owns the “Custom” coordinate space, which in our case is OuterView because we attach it in ContentView. This number matches the global position because OuterView runs edge to edge horizontally.
    A custom center Y of 383 means the center of the text view is 383 points from the top edge of OuterView. This value is smaller than the global center Y because OuterView doesn’t extend into the safe area.
    A local center X of 152 means the center of the text view is 152 points from the left edge of its direct container, which in this case is the GeometryReader.
    A local center Y of 350 means the center of the text view is 350 points from the top edge of its direct container, which again is the GeometryReader.
    Which coordinate space you want to use depends on what question you want to answer:
    
    Want to know where this view is on the screen? Use the global space.
    Want to know where this view is relative to its parent? Use the local space.
    What to know where this view is relative to some other view? Use a custom space.
    """
    
    // MARK: - Body
    var body: some View {
        // Example GeometryReader With VStack
        VStack {
            GeometryReader { geo in
                Text(topic)
                    .font(.largeTitle)
                    .frame(width: geo.size.width * 0.9, height: 100)
                    .padding()
                    .background(.red)
            }
            .background(.green)
            ScrollView {
                Text(info)
                    .padding()
            }
            
            // Example of OuterView
            OuterView()
                .background(.red)
                .coordinateSpace(name: "Custom")
        }
    }
}

// MARK: - PreviewProvider
struct FrameAndCoodinatesView_Previews: PreviewProvider {
    static var previews: some View {
        FrameAndCoodinatesView()
    }
}
