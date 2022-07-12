//
//  CustomAlignmentView.swift
//  Day92_Geometry_Part1
//
//  Created by Lee McCormick on 7/12/22.
//

import SwiftUI

// MARK: - VerticalAlignment
extension VerticalAlignment {
    //  Now, I mentioned that using an enum is preferable to a struct, and here’s why: we just created a new struct called MidAccountAndName, which means we could (if we wanted) create an instance of that struct even though doing so doesn’t make sense because it doesn’t have any functionality. If you replace struct MidAccountAndName with enum MidAccountAndName then you can’t make an instance of it any more – it becomes clearer that this thing exists only to house some functionality.
    enum MidAccountAndName: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[.top]
        }
    }
    static let midAccountAndName = VerticalAlignment(MidAccountAndName.self)
}

// MARK: - CustomAlignmentView
struct CustomAlignmentView: View {
    let topic = "How to create a custom alignment guide"
    let info =
    """
    SwiftUI gives us alignment guides for the various edges of our views (.leading, .trailing, .top, and so on) plus .center and two baseline options to help with text alignment. However, none of these work well when you’re working with views that are split across disparate views – if you have to make two views aligned the same when they are in entirely different parts of your user interface.
    
    To fix this, SwiftUI lets us create custom alignment guides, and use those guides in views across our UI. It doesn’t matter what comes before or after these views; they will still line up.
    
    For example, here’s a layout that shows my Twitter account name and my profile picture on the left, and on the right shows “Full name:” plus “Paul Hudson” in a large font:
    
    struct ContentView: View {
        var body: some View {
            HStack {
                VStack {
                    Text("@twostraws")
                    Image("paul-hudson")
                        .resizable()
                        .frame(width: 64, height: 64)
                }
    
                VStack {
                    Text("Full name:")
                    Text("PAUL HUDSON")
                        .font(.largeTitle)
                }
            }
        }
    }
    If you want “@twostraws” and “Paul Hudson” to be vertically aligned together, you’ll have a hard time right now. The horizontal stack contains two vertical stacks inside it, so there’s no built-in way to get the alignment you want – things like HStack(alignment: .top) just won’t come close.
    
    To fix this we need to define a custom layout guide. This should be an extension on either VerticalAlignment or HorizontalAlignment, and be a custom type that conforms to the AlignmentID protocol.
    
    When I say “custom type” you might be thinking of a struct, but it’s actually a good idea to implement this as an enum instead as I’ll explain shortly. The AlignmentID protocol has only one requirement, which is that the conforming type must provide a static defaultValue(in:) method that accepts a ViewDimensions object and returns a CGFloat specifying how a view should be aligned if it doesn’t have an alignmentGuide() modifier. You’ll be given the existing ViewDimensions object for the view, so you can either pick one of those for your default or use a hard-coded value.
    
    Let’s write out the code so you can see how it looks:
    
    extension VerticalAlignment {
        struct MidAccountAndName: AlignmentID {
            static func defaultValue(in d: ViewDimensions) -> CGFloat {
                d[.top]
            }
        }
    
        static let midAccountAndName = VerticalAlignment(MidAccountAndName.self)
    }
    You can see I’ve used the .top view dimension by default, and I’ve also created a static constant called midAccountAndName to make the custom alignment easier to use.
    
    Now, I mentioned that using an enum is preferable to a struct, and here’s why: we just created a new struct called MidAccountAndName, which means we could (if we wanted) create an instance of that struct even though doing so doesn’t make sense because it doesn’t have any functionality. If you replace struct MidAccountAndName with enum MidAccountAndName then you can’t make an instance of it any more – it becomes clearer that this thing exists only to house some functionality.
    
    Regardless of whether you choose an enum or a struct, its usage stays the same: set it as the alignment for your stack, then use alignmentGuide() to activate it on any views you want to align together. This is only a guide: it helps you align views along a single line, but doesn’t say how they should be aligned. This means you still need to provide the closure to alignmentGuide() that positions the views along that guide as you want.
    
    For example, we could update our Twitter code to use .midAccountAndName, then tell the account and name to use their center position for the guide. To be clear, that means “align these two views so their centers are both on the .midAccountAndName guide”.
    
    Here’s how that looks in code:
    
    HStack(alignment: .midAccountAndName) {
        VStack {
            Text("@twostraws")
                .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
            Image("paul-hudson")
                .resizable()
                .frame(width: 64, height: 64)
        }
    
        VStack {
            Text("Full name:")
            Text("PAUL HUDSON")
                .alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
                .font(.largeTitle)
        }
    }
    That will make sure they are vertically aligned regardless of what comes before or after. I suggest you try adding some more text views before and after our examples – SwiftUI will reposition everything to make sure the two we aligned stay that way.
    """
    
    // MARK: - Body
    var body: some View {
        VStack {
            // Topic
            Text(topic)
                .font(.largeTitle)
                .padding()
            
            // HStatck Example
            HStack(alignment: .midAccountAndName) {
                VStack {
                    Text("@LeeMcCormick")
                        .alignmentGuide(.midAccountAndName) { dimentions in dimentions[VerticalAlignment.center] }
                    Image("LeeMccormick")
                        .resizable()
                        .frame(width: 64, height: 64)
                    Text("TEST")
                    Text("TEST")
                    Text("TEST")
                    Text("TEST")
                    Text("TEST")
                    Text("TEST")
                }
                VStack {
                    Text("TEST")
                    Text("TEST")
                    Text("TEST")
                    Text("TEST")
                    Text("TEST")
                    Text("TEST")
                    Text("Full Name : ")
                    Text("Lee McCormick")
                        .alignmentGuide(.midAccountAndName) { dimentions in dimentions[VerticalAlignment.center] }
                        .font(.largeTitle)
                }
            }
            
            // Info
            ScrollView {
                Text(info)
                    .font(.body)
                    .padding()
            }
        }
    }
}

// MARK: - PreviewProvider
struct CustomAlignmentView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlignmentView()
    }
}
