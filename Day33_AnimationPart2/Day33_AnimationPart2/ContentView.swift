//
//  ContentView.swift
//  Day33_AnimationPart2
//
//  Created by Lee McCormick on 4/2/22.
//

import SwiftUI

// Building custom transitions using ViewModifier
struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct ContentView: View {
    @State private var isShowingRed = false

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)

            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }
        .onTapGesture {
            withAnimation {
                isShowingRed.toggle()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/* Showing and hiding views with transitions
struct ContentView: View {
    @State private var isShowingRed = false
    var body: some View {
        VStack {
            Button("Tap Me") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }
            if isShowingRed {
            Rectangle()
                .fill(.red)
                .frame(width: 200, height: 200)
                .transition(.asymmetric(insertion: .scale, removal: .opacity))
                // .transition(.scale)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
 */

/* Animating gestures
struct ContentView: View {
    let letters = Array("Hello SwiftUI")
        @State private var enabled = false
        @State private var dragAmount = CGSize.zero

        var body: some View {
            HStack(spacing: 0) {
                ForEach(0..<letters.count) { num in
                    Text(String(letters[num]))
                        .padding(5)
                        .font(.title)
                        .background(enabled ? .blue : .red)
                        .offset(dragAmount)
                        .animation(.default.delay(Double(num) / 20), value: dragAmount)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { dragAmount = $0.translation }
                    .onEnded { _ in
                        dragAmount = .zero
                        enabled.toggle()
                    }
            )
        }
    }    /* @State private var dragAmount = CGSize.zere
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: 300, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .offset(dragAmount)
            .gesture(
                DragGesture()
                    .onChanged { dragAmount = $0.translation }
                    .onEnded { _ in
                        withAnimation(.spring()) {
                            dragAmount = .zero
                        }
                    }
                // .onEnded { _ in dragAmount = .zero }
            )
        
        // .animation(.spring(), value: dragAmount)
    } */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/

/* Controlling the animation stack
struct ContentView: View {
    @State private var enabled = false
    var body: some View {
        Button("Tap Me") {
            // do nothing
            enabled.toggle()
        }
        .frame(width: 200, height: 200)
        // .background(.blue)
        .background(enabled ? .blue : .red)
        .animation(nil, value: enabled)
        // .animation(.default, value: enabled)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
        .animation(.interpolatingSpring(stiffness: 10, damping: 1), value: enabled)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/

/* Project 6, part 2
 Today we’re going to be getting into more advanced animations, and it’s where you’ll start to get a deeper understanding of how animations work and how you can customize them to a remarkable degree.

 There’s a famous industrial designer from Germany called Dieter Rams. You might not have heard of him, but you’ve certainly seen his work – his designs have hugely inspired Apple’s own designs for years, from the iPod to the iMac and the Mac Pro. He once said, “good design is making something intelligible and memorable; great design is making something memorable and meaningful.”

 SwiftUI’s powerful animations system lets us create memorable animations easily enough, but the meaningful part is up to you – does your animation merely look good, or does it convey extra information to the user?

 That’s not to say animations can’t just look good; there’s always some room for whimsy in app development. But when important changes are happening, it’s important we try to help user understand what’s changing and why. In SwiftUI, this is largely the job of transitions, which you’ll meet today.

 Today you have four topics to work through, in which you’ll learn about multiple animations, gesture animations, transitions, and more.

 - Controlling the animation stack
 - Animating gestures
 - Showing and hiding views with transitions
 - Building custom transitions using ViewModifier
 */

/* Controlling the animation stack
 At this point, I want to put together two things that you already understand individually, but together might hurt your head a little.

 Previously we looked at how the order of modifiers matters. So, if we wrote code like this:

 Button("Tap Me") {
     // do nothing
 }
 .background(.blue)
 .frame(width: 200, height: 200)
 .foregroundColor(.white)
 The result would look different from code like this:

 Button("Tap Me") {
     // do nothing
 }
 .frame(width: 200, height: 200)
 .background(.blue)
 .foregroundColor(.white)
 This is because if we color the background before adjusting the frame, only the original space is colored rather than the expanded space. If you recall, the underlying reason for this is the way SwiftUI wraps views with modifiers, allowing us to apply the same modifier multiple times – we repeated background() and padding() several times to create a striped border effect.

 That’s concept one: modifier order matters, because SwiftUI wraps views with modifiers in the order they are applied.

 Concept two is that we can apply an animation() modifier to a view in order to have it implicitly animate changes.

 To demonstrate this, we could modify our button code so that it shows different colors depending on some state. First, we define the state:

 @State private var enabled = false
 We can toggle that between true and false inside our button’s action:

 enabled.toggle()
 Then we can use a conditional value inside the background() modifier so the button is either blue or red:

 .background(enabled ? .blue : .red)
 Finally, we add the animation() modifier to the button to make those changes animate:

 .animation(.default, value: enabled)
 If you run the code you’ll see that tapping the button animates its color between blue and red.

 So: order modifier matters and we can attach one modifier several times to a view, and we can cause implicit animations to occur with the animation() modifier. All clear so far?

 Right. Brace yourself, because this might hurt.

 You can attach the animation() modifier several times, and the order in which you use it matters.

 To demonstrate this, I’d like you to add this modifier to your button, after all the other modifiers:

 .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
 That will cause the button to move between a square and a rounded rectangle depending on the state of the enabled Boolean.

 When you run the program, you’ll see that tapping the button causes it to animate between red and blue, but jump between square and rounded rectangle – that part doesn’t animate.

 Hopefully you can see where we’re going next: I’d like you to move the clipShape() modifier before the animation, like this:

 .frame(width: 200, height: 200)
 .background(enabled ? .blue : .red)
 .foregroundColor(.white)
 .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
 .animation(.default, value: enabled)
 And now when you run the code both the background color and clip shape animate.

 So, the order in which we apply animations matters: only changes that occur before the animation() modifier get animated.

 Now for the fun part: if we apply multiple animation() modifiers, each one controls everything before it up to the next animation. This allows us to animate state changes in all sorts of different ways rather than uniformly for all properties.

 For example, we could make the color change happen with the default animation, but use an interpolating spring for the clip shape:

 Button("Tap Me") {
     enabled.toggle()
 }
 .frame(width: 200, height: 200)
 .background(enabled ? .blue : .red)
 .animation(.default, value: enabled)
 .foregroundColor(.white)
 .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
 .animation(.interpolatingSpring(stiffness: 10, damping: 1), value: enabled)
 You can have as many animation() modifiers as you need to construct your design, which lets us split one state change into as many segments as we need.

 For even more control, it’s possible to disable animations entirely by passing nil to the modifier. For example, you might want the color change to happen immediately but the clip shape to retain its animation, in which case you’d write this:

 Button("Tap Me") {
     enabled.toggle()
 }
 .frame(width: 200, height: 200)
 .background(enabled ? .blue : .red)
 .animation(nil, value: enabled)
 .foregroundColor(.white)
 .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
 .animation(.interpolatingSpring(stiffness: 10, damping: 1), value: enabled)
 That kind of control wouldn’t be possible without multiple animation() modifiers – if you tried to move background() after the animation you’d find that it would just undo the work of clipShape().
 */

/* Animating gestures
 
 */

/* Showing and hiding views with transitions

 */

/* Building custom transitions using ViewModifier
 
 */
