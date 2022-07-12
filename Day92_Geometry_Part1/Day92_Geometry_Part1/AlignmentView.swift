//
//  AlignmentView.swift
//  Day92_Geometry_Part1
//
//  Created by Lee McCormick on 7/12/22.
//

import SwiftUI

struct AlignmentView: View {
    let topic = "Alignment and alignment guides"
    let info =
    """
    SwiftUI gives us a number of valuable ways of controlling the way views are aligned, and I want to walk you through each of them so you can see them in action.
    
    The simplest alignment option is to use the alignment parameter of a frame() modifier. Remember, a text view always uses the exact width and height required to show its text, but when we place a frame around it that can be any size. As the parent doesn’t have a say in the final size of the child, code like this will create a 300x300 frame with a smaller text view centered inside it:
    
    Text("Live long and prosper")
        .frame(width: 300, height: 300)
    If you don’t want the text to be centered, use the alignment parameter of the frame(). For example, this code places the view in the top-left corner when running on a left-to-right environment
    
        .frame(width: 300, height: 300, alignment: .topLeading)
    You can then use offset(x:y:) to move the text around inside that frame.
    
    The next option up is to use the alignment parameter of a stack. For example, here are four text views of varying sizes arranged in a HStack:
    
    HStack {
        Text("Live")
            .font(.caption)
        Text("long")
        Text("and")
            .font(.title)
        Text("prosper")
            .font(.largeTitle)
    }
    We haven’t specified an alignment there, so they will be centered by default. That doesn’t look great, so you might think to align them all to one edge to get a neater line, like this:
    
    HStack(alignment: .bottom) {
    However, that also looks bad: because each of the text views has a different size, they also have a different baseline – that’s the name for where letters such as “abcde” sit on a line, which excludes letters that go below the line such as “gjpy”. As a result, the bottom of the small text sits lower than the bottom of the bigger text.
    
    Fortunately, SwiftUI has two special alignments that align text on the baseline of either the first child or the last child. This will cause all views in a stack to be aligned on a single unified baseline, regardless of their font:
    
    HStack(alignment: .lastTextBaseline) {
    Moving on, for more fine-grained control we can customize what “alignment” means for each individual view. To get a really good idea of how this works we’re going to start with this code:
    
    struct ContentView: View {
        var body: some View {
            VStack(alignment: .leading) {
                Text("Hello, world!")
                Text("This is a longer line of text")
            }
            .background(.red)
            .frame(width: 400, height: 400)
            .background(.blue)
        }
    }
    When that runs you’ll see the VStack sits tightly around its two text views with a red background. The two text views have different lengths, but because we used the .leading alignment they will both be aligned to their left edge in a left-to-right environment. Outside of that there’s a larger frame that has a blue background. Because the frame is larger than the VStack, the VStack is centered in the middle.
    
    Now, when the VStack comes to aligning each of those text views, it asks them to provide their leading edge. By default this is obvious: it uses either the left or right edge of the view, depending on the system language. But what if we wanted to change that – what if we wanted to make one view have a custom alignment?
    
    SwiftUI provides us with the alignmentGuide() modifier for just this purpose. This takes two parameters: the guide we want to change, and a closure that returns a new alignment. The closure is given a ViewDimensions object that contains the width and height of its view, along with the ability to read its various edges.
    
    By default, the .leading alignment guide for a view is its leading alignment guide – I know that sounds obvious, but its effectively equivalent to this:
    
    VStack(alignment: .leading) {
        Text("Hello, world!")
            .alignmentGuide(.leading) { d in d[.leading] }
        Text("This is a longer line of text")
    }
    We could rewrite that alignment guide to use the view’s trailing edge for its leading alignment guide, like this:
    
    VStack(alignment: .leading) {
        Text("Hello, world!")
            .alignmentGuide(.leading) { d in d[.trailing] }
        Text("This is a longer line of text")
    }
    And now you’ll see why I added colors: the first text view will move to the left so that its right edge sits directly above the left edge of the view below, the VStack will expand to contain it, and the whole thing will still be centered within the blue frame.
    
    This result is different from using the offset() modifier: if you offset a text its original dimensions don’t actually change, even though the resulting view is rendered in a different location. If we had offset the first text view rather than changing its alignment guide, the VStack wouldn’t expand to contain it.
    
    Although the alignment guide closure is passed your view’s dimensions, you don’t need to use them if you don’t want to – you can send back a hard-coded number, or create some other calculation. For example, this creates a tiered effect for 10 text views by multiplying their position by -10:
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0..<10) { position in
                Text("Number \'(position)")
                    .alignmentGuide(.leading) { _ in CGFloat(position) * -10 }
            }
        }
        .background(.red)
        .frame(width: 400, height: 400)
        .background(.blue)
    }
    For complete control over your alignment guides you need to create a custom alignment guide. And I think that deserves a mini chapter all of its own…
    """
    var body: some View {
        ScrollView {
            // Topic
            Text(topic)
                .font(.largeTitle)
                .frame(width: 300, height: 100) // The text is center
                .multilineTextAlignment(.center)
                .background(.red)
            
            // Alignment with TopLeading
            Text("Alignment with TopLeading.")
                .frame(width: 300, height: 300, alignment: .topLeading)
                .offset(x: 50, y: 50) // Move to position x, y
                .background(.blue)
            
            // HStack Aligment Example
            // HStack(alignment: .bottom) { --> Do not look good !, so use lastTextBaseline.
            HStack(alignment: .lastTextBaseline) {
                Text("HStack")
                Text("Caption")
                    .font(.caption)
                Text("Title")
                    .font(.title)
                Text("Body")
                    .font(.body)
                Text("Headline")
                    .font(.headline)
            }
            .background(.gray)
            
            // AlignmentGuide VS Offset Example
            VStack(alignment: .leading) {
                Text("VStack")
                    .alignmentGuide(.leading) { dimentions in
                        // dimentions[.leading]
                        dimentions[.trailing] // To Change to trailing dimention
                    }
                Text("with leading alignment and 2 Texts")
                    .offset(x: 0, y: 100) // Use offset, the text out of VStack
            }
            .padding()
            .background(.red)
            .frame(width: 400, height: 400)
            .background(.blue)
            
            // AlignmentGuide Example
            VStack(alignment: .leading) {
                ForEach(0..<10) { position in
                    Text("Number \(position)")
                        .alignmentGuide(.leading) { _ in
                            Double(position) * -10
                        }
                }
            }
            .padding()
            .background(.red)
            .frame(width: 400, height: 400)
            .background(.blue)
            
            // Info
            Text(info)
                .padding()
        }
    }
}

struct AlignmentView_Previews: PreviewProvider {
    static var previews: some View {
        AlignmentView()
    }
}
