//
//  AbsolutePositionView.swift
//  Day93_Geometry_Part2
//
//  Created by Lee McCormick on 7/12/22.
//

import SwiftUI

struct AbsolutePositionView: View {
    let topic = "Absolute positioning for SwiftUI views"
    let info = """
    SwiftUI gives us two ways of positioning views: absolute positions using position(), and relative positions using offset(). They might seem similar, but once you understand how SwiftUI places views inside frames the underlying differences between position() and offset() become clearer.
    
    A simple SwiftUI view looks like this:
    
    struct ContentView: View {
        var body: some View {
            Text("Hello, world!")
        }
    }
    SwiftUI offers the full available space to ContentView, which in turn passes it on to the text view. The text view automatically uses only as much as space as its text needs, so it passes that back up to ContentView, which is always and exactly the same size as its body (so it directly fits around the text). As a result, SwiftUI centers ContentView in the available space, which from a user’s perspective is what places the text in the center.
    
    If you want to absolutely position a SwiftUI view you should use the position() modifier like this:
    
    Text("Hello, world!")
        .position(x: 100, y: 100)
    That will position the text view at x:100 y:100 within its parent. Now, to really see what’s happening here I want you to add a background color:
    
    Text("Hello, world!")
        .background(.red)
        .position(x: 100, y: 100)
    You’ll see the text has a red background tightly fitted around it. Now try moving the background() modifier below the position() modifier, like this:
    
    Text("Hello, world!")
        .position(x: 100, y: 100)
        .background(.red)
    Now you’ll see the text is in the same location, but the whole safe area is colored red.
    
    To understand what’s happening here you need to remember the three step layout process of SwiftUI:
    
    A parent view proposes a size for its child.
    Based on that information, the child then chooses its own size and the parent must respect that choice.
    The parent then positions the child in its coordinate space.
    So, the parent is responsible for positioning the child, not the child. This causes a problem, because we’ve just told our text view to be at an exact position – how can SwiftUI resolve this?
    
    The answer to this is also why our background() color made the whole safe area red: when we use position() we get back a new view that takes up all available space, so it can position its child (the text) at the correct location.
    
    When we use text, position, then background the position will take up all available space so it can position its text correctly, then the background will use that size for itself. When we use text, background, then position, the background will use the text size for its size, then the position will take up all available space and place the background in the correct location.
    
    When discussing the offset() modifier earlier, I said “if you offset some text its original dimensions don’t actually change, even though the resulting view is rendered in a different location.” With that in mind, try running this code:
    
    var body: some View {
        Text("Hello, world!")
            .offset(x: 100, y: 100)
            .background(.red)
    }
    You’ll see the text appears in one place and the background in another. I’m going to explain why that is, but first I want you to think about it yourself because if you understand that then you really understand how SwiftUI’s layout system works.
    
    When we use the offset() modifier, we’re changing the location where a view should be rendered without actually changing its underlying geometry. This means when we apply background() afterwards it uses the original position of the text, not its offset. If you move the modifier order so that background() comes before offset() then things work more like you might have expected, showing once again that modifier order matters.
    """
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            Text(topic)
                .font(.largeTitle)
            
            // Background then offset --> If you move the modifier order so that background() comes before offset() then things work more like you might have expected, showing once again that modifier order matters.
            VStack {
                Text("backgroundRed + offset5050")
                .background(.red) // Red over text
                .offset(x: 50, y: 50)
            }
            .frame(width: 200, height: 200)
            .background(.gray)
            
            // Backgroun then position --> When we use text, background, then position, the background will use the text size for its size, then the position will take up all available space and place the background in the correct location.
            VStack {
                Text("backgroundBlue + position5050")
                .background(.blue) // Blue over text
                .position(x: 50, y: 50)
            }
            .frame(width: 200, height: 200)
            .background(.gray)
            
            // Position then background -->  When we use text, position, then background the position will take up all available space so it can position its text correctly, then the background will use that size for itself.
            VStack {
                Text("position5050 + backgroundYellow")
                    .position(x: 50, y: 50)
                    .background(.yellow) // Yellow cover the whole screen
            }
            .frame(width: 200, height: 200)
            .background(.gray)
            
            // Offset then background -->  When we use the offset() modifier, we’re changing the location where a view should be rendered without actually changing its underlying geometry. This means when we apply background() afterwards it uses the original position of the text, not its offset.
            VStack {
                Text("offset5050 + backgroundGreen")
                .offset(x: 50, y: 50)
                .background(.green) // Green cover the offset area
            }
            .frame(width: 200, height: 200)
            .background(.gray)
            
            // Info
            VStack {
                Text(info)
                    .padding()
            }
        }
    }
}

struct AbsolutePositionView_Previews: PreviewProvider {
    static var previews: some View {
        AbsolutePositionView()
    }
}
