//
//  Day92_Geometry_Part1App.swift
//  Day92_Geometry_Part1
//
//  Created by Lee McCormick on 7/12/22.
//

import SwiftUI

@main
struct Day92_Geometry_Part1App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 18, part 1 --> https://www.hackingwithswift.com/100/swiftui/92
 In our final technique project for these 100 days, we’ll be looking at how SwiftUI handles layout and geometry. Yes, I realize you might have expected this kind of thing to be covered much earlier, but one of the great things about SwiftUI is that it does so much work for us – that this kind of tutorial appears so late in this series is testament to how good SwiftUI’s standard layout is.

 Randall Munroe, author of the xkcd comic, once said “if you really hate someone, teach them to recognize bad kerning.” If you weren’t already aware, kerning is the spacing between letters, and bad kerning is surprisingly common – once you learn to spot it, you realize it’s everywhere.

 Today you’re going to look at alignment, and this is another thing that is hard to ignore when you know about it. Sure, it’s easy to spot when one thing is centered and another thing isn’t, but what if two things are aligned to slightly different leading edges? It’s invisible until you know about, but when you start noticing it’s impossible to stop!

 Today you have four topics to work through, in which you’ll learn about the rules of layout, alignment, custom guides, and more.

 - Layout and geometry: Introduction
 - How layout works in SwiftUI
 - Alignment and alignment guides
 - How to create a custom alignment guide
 */

/* Layout and geometry: Introduction
 In this technique project we’re going to explore how SwiftUI handles layout. Some of these things have been explained a little already, some of them you might have figured out yourself, but many more are things you might just have taken for granted to this point, so I hope a detailed exploration will really shed some light on how SwiftUI works.

 Along the way you’ll also learn about creating more advanced layout alignments, building special effects using GeometryReader, and more – some real power features that I know you’ll be keen to deploy in your own apps.

 Go ahead and create a new iOS project using the App template, naming it LayoutAndGeometry. You’ll need an image in your asset catalog in order to follow the chapter on custom alignment guides, but it can be anything you want – it’s just a placeholder really.
 */

/* How layout works in SwiftUI
 All SwiftUI layout happens in three simple steps, and understanding these steps is the key to getting great layouts every time. The steps are:

 A parent view proposes a size for its child.
 Based on that information, the child then chooses its own size and the parent must respect that choice.
 The parent then positions the child in its coordinate space.
 Behind the scenes, SwiftUI performs a fourth step: although it stores positions and sizes as floating-point numbers, when it comes to rendering SwiftUI rounds off any pixels to their nearest values so our graphics remain sharp.

 Those three rules might seem simple, but they allow us to create hugely complicated layouts where every view decides how and when it resizes without the parent having to get involved.

 To demonstrate these rules in action, I’d like you to modify the default SwiftUI template to add a background() modifier, like this:

 struct ContentView: View {
     var body: some View {
         Text("Hello, World!")
             .background(.red)
     }
 }
 You’ll see the background color sits tightly around the text itself – it takes up only enough space to fit the content we provided.

 Now, think about this question: how big is ContentView? As you can see, the body of ContentView – the thing that it renders – is some text with a background color. And so the size of ContentView is exactly and always the size of its body, no more and no less. This is called being layout neutral: ContentView doesn’t have any size of its own, and instead happily adjusts to fit whatever size is needed.

 Back in project 3 I explained to you that when you apply a modifier to a view we actually get back a new view type called ModifiedContent, which stores both our original view and its modifier. This means when we apply a modifier, the actual view that goes into the hierarchy is the modified view, not the original one.

 In our simple background() example, that means the top-level view inside ContentView is the background, and inside that is the text. Backgrounds are layout neutral just like ContentView, so it will just pass on any layout information as needed – you can end up with a chain of layout information being passed around until a definitive answer comes back.

 If we put this into the three-step layout system, we end up with a conversation a bit like this:

 SwiftUI: “Hey, ContentView, you have the whole screen to yourself – how much of it do you need?” (Parent view proposes a size)
 ContentView: “I don’t care; I’m layout neutral. Let me ask my child: hey, background, you have the whole screen to yourself – how much of it do you need?” (Parent view proposes a size)
 Background: “I also don’t care; I’m layout neutral too. Let me ask my child: hey, text, you can have the whole screen to yourself – how much of it do you need?” (Parent view proposes a size)
 Text: “Well, I have the letters ‘Hello, World’ in the default font, so I need exactly X pixels width by Y pixels height. I don’t need the whole screen, just that.” (Child chooses its size.)
 Background: “Got it. Hey, ContentView: I need X by Y pixels, please.”
 ContentView: “Right on. Hey, SwiftUI: I need X by Y pixels.”
 SwiftUI: “Nice. Well, that leaves lots of space, so I’m going to put you at your size in the center.” (Parent positions the child in its coordinate space.)
 So, when we say Text("Hello, World!").background(.red), the text view becomes a child of its background. SwiftUI effectively works its way from bottom to top when it comes to a view and its modifiers.

 Now consider this layout:

 Text("Hello, World!")
     .padding(20)
     .background(.red)
 This time the conversation is more complicated: padding() no longer offers all its space to its child, because it needs to subtract 20 points from each side to make sure there’s enough space for the padding. Then, when the answer comes back from the text view, padding() adds 20 points on each side to pad it out, as requested.

 So, it’s more like this:

 SwiftUI: You can have the whole screen, how much of it do you need, ContentView?
 ContentView: You can have the whole screen, how much of it do you need, background?
 Background: You can have the whole screen, how much of it do you need, padding?
 Padding: You can have the whole screen minus 20 points on each side, how much of it do you need, text?
 Text: I need X by Y.
 Padding: I need X by Y plus 20 points on each side.
 Background: I need X by Y plus 20 points on each side.
 ContentView: I need X by Y plus 20 points on each side.
 SwiftUI: OK; I’ll center you.
 If you remember, the order of our modifiers matters. That is, this code:

 Text("Hello, World!")
     .padding()
     .background(.red)
 And this code:

 Text("Hello, World!")
     .background(.red)
     .padding()
 Yield two different results. Hopefully now you can see why: background() is layout neutral, so it determines how much space it needs by asking its child how much space it needs and using that same value. If the child of background() is the text view then the background will fit snugly around the text, but if the child is padding() then it receive back the adjusted values that including the padding amount.

 There are two interesting side effects that come as a result of these layout rules.

 First, if your view hierarchy is wholly layout neutral, then it will automatically take up all available space. For example, shapes and colors are layout neutral, so if your view contains a color and nothing else it will automatically fill the screen like this:

 var body: some View {
     Color.red
 }
 Remember, Color.red is a view in its own right, but because it is layout neutral it can be drawn at any size. When we used it inside background() the abridged layout conversation worked like this:

 Background: Hey text, you can have the whole screen – how much of that do you want?
 Text: I need X by Y points; I don’t need the rest.
 Background: OK. Hey, Color.red: you can have X by Y points – how much of that do you want?
 Color.red: I don’t care; I’m layout neutral, so X by Y points sounds good to me.
 The second interesting side effect is one we faced earlier: if we use frame() on an image that isn’t resizable, we get a larger frame without the image inside changing size. This might have been confusing before, but it makes absolute sense once you think about the frame as being the parent of the image:

 ContentView offers the frame the whole screen.
 The frame reports back that it wants 300x300.
 The frame then asks the image inside it what size it wants.
 The image, not being resizable, reports back a fixed size of 64x64 (for example).
 The frame then positions that image in the center of itself.
 When you listen to Apple’s own SwiftUI engineers talk about modifiers, you’ll hear them refer them to as views – “the frame view”, “the background view”, and so on. I think that’s a great mental model to help understand exactly what’s going on: applying modifiers creates new views rather than just modifying existing views in-place.
 */

/* Alignment and alignment guides
 All SwiftUI layout happens in three simple steps, and understanding these steps is the key to getting great layouts every time. The steps are:

 A parent view proposes a size for its child.
 Based on that information, the child then chooses its own size and the parent must respect that choice.
 The parent then positions the child in its coordinate space.
 Behind the scenes, SwiftUI performs a fourth step: although it stores positions and sizes as floating-point numbers, when it comes to rendering SwiftUI rounds off any pixels to their nearest values so our graphics remain sharp.

 Those three rules might seem simple, but they allow us to create hugely complicated layouts where every view decides how and when it resizes without the parent having to get involved.

 To demonstrate these rules in action, I’d like you to modify the default SwiftUI template to add a background() modifier, like this:

 struct ContentView: View {
     var body: some View {
         Text("Hello, World!")
             .background(.red)
     }
 }
 You’ll see the background color sits tightly around the text itself – it takes up only enough space to fit the content we provided.

 Now, think about this question: how big is ContentView? As you can see, the body of ContentView – the thing that it renders – is some text with a background color. And so the size of ContentView is exactly and always the size of its body, no more and no less. This is called being layout neutral: ContentView doesn’t have any size of its own, and instead happily adjusts to fit whatever size is needed.

 Back in project 3 I explained to you that when you apply a modifier to a view we actually get back a new view type called ModifiedContent, which stores both our original view and its modifier. This means when we apply a modifier, the actual view that goes into the hierarchy is the modified view, not the original one.

 In our simple background() example, that means the top-level view inside ContentView is the background, and inside that is the text. Backgrounds are layout neutral just like ContentView, so it will just pass on any layout information as needed – you can end up with a chain of layout information being passed around until a definitive answer comes back.

 If we put this into the three-step layout system, we end up with a conversation a bit like this:

 SwiftUI: “Hey, ContentView, you have the whole screen to yourself – how much of it do you need?” (Parent view proposes a size)
 ContentView: “I don’t care; I’m layout neutral. Let me ask my child: hey, background, you have the whole screen to yourself – how much of it do you need?” (Parent view proposes a size)
 Background: “I also don’t care; I’m layout neutral too. Let me ask my child: hey, text, you can have the whole screen to yourself – how much of it do you need?” (Parent view proposes a size)
 Text: “Well, I have the letters ‘Hello, World’ in the default font, so I need exactly X pixels width by Y pixels height. I don’t need the whole screen, just that.” (Child chooses its size.)
 Background: “Got it. Hey, ContentView: I need X by Y pixels, please.”
 ContentView: “Right on. Hey, SwiftUI: I need X by Y pixels.”
 SwiftUI: “Nice. Well, that leaves lots of space, so I’m going to put you at your size in the center.” (Parent positions the child in its coordinate space.)
 So, when we say Text("Hello, World!").background(.red), the text view becomes a child of its background. SwiftUI effectively works its way from bottom to top when it comes to a view and its modifiers.

 Now consider this layout:

 Text("Hello, World!")
     .padding(20)
     .background(.red)
 This time the conversation is more complicated: padding() no longer offers all its space to its child, because it needs to subtract 20 points from each side to make sure there’s enough space for the padding. Then, when the answer comes back from the text view, padding() adds 20 points on each side to pad it out, as requested.

 So, it’s more like this:

 SwiftUI: You can have the whole screen, how much of it do you need, ContentView?
 ContentView: You can have the whole screen, how much of it do you need, background?
 Background: You can have the whole screen, how much of it do you need, padding?
 Padding: You can have the whole screen minus 20 points on each side, how much of it do you need, text?
 Text: I need X by Y.
 Padding: I need X by Y plus 20 points on each side.
 Background: I need X by Y plus 20 points on each side.
 ContentView: I need X by Y plus 20 points on each side.
 SwiftUI: OK; I’ll center you.
 If you remember, the order of our modifiers matters. That is, this code:

 Text("Hello, World!")
     .padding()
     .background(.red)
 And this code:

 Text("Hello, World!")
     .background(.red)
     .padding()
 Yield two different results. Hopefully now you can see why: background() is layout neutral, so it determines how much space it needs by asking its child how much space it needs and using that same value. If the child of background() is the text view then the background will fit snugly around the text, but if the child is padding() then it receive back the adjusted values that including the padding amount.

 There are two interesting side effects that come as a result of these layout rules.

 First, if your view hierarchy is wholly layout neutral, then it will automatically take up all available space. For example, shapes and colors are layout neutral, so if your view contains a color and nothing else it will automatically fill the screen like this:

 var body: some View {
     Color.red
 }
 Remember, Color.red is a view in its own right, but because it is layout neutral it can be drawn at any size. When we used it inside background() the abridged layout conversation worked like this:

 Background: Hey text, you can have the whole screen – how much of that do you want?
 Text: I need X by Y points; I don’t need the rest.
 Background: OK. Hey, Color.red: you can have X by Y points – how much of that do you want?
 Color.red: I don’t care; I’m layout neutral, so X by Y points sounds good to me.
 The second interesting side effect is one we faced earlier: if we use frame() on an image that isn’t resizable, we get a larger frame without the image inside changing size. This might have been confusing before, but it makes absolute sense once you think about the frame as being the parent of the image:

 ContentView offers the frame the whole screen.
 The frame reports back that it wants 300x300.
 The frame then asks the image inside it what size it wants.
 The image, not being resizable, reports back a fixed size of 64x64 (for example).
 The frame then positions that image in the center of itself.
 When you listen to Apple’s own SwiftUI engineers talk about modifiers, you’ll hear them refer them to as views – “the frame view”, “the background view”, and so on. I think that’s a great mental model to help understand exactly what’s going on: applying modifiers creates new views rather than just modifying existing views in-place.
 */

/* How to create a custom alignment guide
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


 */
