//
//  GesturesView.swift
//  Day86_Flashzilla_Intro
//
//  Created by Lee McCormick on 7/8/22.
//

import SwiftUI

struct GesturesView: View {
    @State private var currentAmount = 0.0
    @State private var finalAmount = 1.0
    @State private var currentAmountAngle = Angle.zero
    @State private var finalAmountAngle  = Angle.zero
    @State private var offset = CGSize.zero // how far the circle has been dragged
    @State private var isDragging = false // whether it is currently being dragged or not
    let info =
    """
    SwiftUI gives us lots of gestures for working with views, and does a great job of taking away most of the hard work so we can focus on the parts that matter. Easily the most common is our friend onTapGesture(), but there are several others, and there are also interesting ways of combining gestures together that are worth trying out.
    
    I’m going to skip past the simple onTapGesture() because we’ve covered it before so many times, but before we try bigger things I do want to add that you can pass a count parameter to these to make them handle double taps, triple taps, and more, like this:
    
    Text("Hello, World!")
        .onTapGesture(count: 2) {
            print("Double tapped!")
        }
    OK, let’s look at something more interesting than simple taps. For handling long presses you can use onLongPressGesture(), like this:
    
    Text("Hello, World!")
        .onLongPressGesture {
            print("Long pressed!")
        }
    Like tap gestures, long press gestures are also customizable. For example, you can specify a minimum duration for the press, so your action closure only triggers after a specific number of seconds have passed. For example, this will trigger only after two seconds:
    
    Text("Hello, World!")
        .onLongPressGesture(minimumDuration: 2) {
            print("Long pressed!")
        }
    You can even add a second closure that triggers whenever the state of the gesture has changed. This will be given a single Boolean parameter as input, and it will work like this:
    
    As soon as you press down the change closure will be called with its parameter set to true.
    If you release before the gesture has been recognized (so, if you release after 1 second when using a 2-second recognizer), the change closure will be called with its parameter set to false.
    If you hold down for the full length of the recognizer, then the change closure will be called with its parameter set to false (because the gesture is no longer in flight), and your completion closure will be called too.
    Use code like this to try it out for yourself:
    
    Text("Hello, World!")
        .onLongPressGesture(minimumDuration: 1) {
            print("Long pressed!")
        } onPressingChanged: { inProgress in
            print("In progress: inProgress!")
        }
    For more advanced gestures you should use the gesture() modifier with one of the gesture structs: DragGesture, LongPressGesture, MagnificationGesture, RotationGesture, and TapGesture. These all have special modifiers, usually onEnded() and often onChanged() too, and you can use them to take action when the gestures are in-flight (for onChanged()) or completed (for onEnded()).
    
    As an example, we could attach a magnification gesture to a view so that pinching in and out scales the view up and down. This can be done by creating two @State properties to store the scale amount, using that inside a scaleEffect() modifier, then setting those values in the gesture, like this:
    
    struct ContentView: View {
        @State private var currentAmount = 0.0
        @State private var finalAmount = 1.0
    
        var body: some View {
            Text("Hello, World!")
                .scaleEffect(finalAmount + currentAmount)
                .gesture(
                    MagnificationGesture()
                        .onChanged { amount in
                            currentAmount = amount - 1
                        }
                        .onEnded { amount in
                            finalAmount += currentAmount
                            currentAmount = 0
                        }
                )
        }
    }
    Exactly the same approach can be taken for rotating views using RotationGesture, except now we’re using the rotationEffect() modifier:
    
    struct ContentView: View {
        @State private var currentAmount = Angle.zero
        @State private var finalAmount = Angle.zero
    
        var body: some View {
            Text("Hello, World!")
                .rotationEffect(currentAmount + finalAmount)
                .gesture(
                    RotationGesture()
                        .onChanged { angle in
                            currentAmount = angle
                        }
                        .onEnded { angle in
                            finalAmount += currentAmount
                            currentAmount = .zero
                        }
                )
        }
    }
    Where things start to get more interesting is when gestures clash – when you have two or more gestures that might be recognized at the same time, such as if you have one gesture attached to a view and the same gesture attached to its parent.
    
    For example, this attaches an onTapGesture() to a text view and its parent:
    
    struct ContentView: View {
        var body: some View {
            VStack {
                Text("Hello, World!")
                    .onTapGesture {
                        print("Text tapped")
                    }
            }
            .onTapGesture {
                print("VStack tapped")
            }
        }
    }
    In this situation SwiftUI will always give the child’s gesture priority, which means when you tap the text view above you’ll see “Text tapped”. However, if you want to change that you can use the highPriorityGesture() modifier to force the parent’s gesture to trigger instead, like this:
    
    struct ContentView: View {
        var body: some View {
            VStack {
                Text("Hello, World!")
                    .onTapGesture {
                        print("Text tapped")
                    }
            }
            .highPriorityGesture(
                TapGesture()
                    .onEnded { _ in
                        print("VStack tapped")
                    }
            )
        }
    }
    Alternatively, you can use the simultaneousGesture() modifier to tell SwiftUI you want both the parent and child gestures to trigger at the same time, like this:
    
    struct ContentView: View {
        var body: some View {
            VStack {
                Text("Hello, World!")
                    .onTapGesture {
                        print("Text tapped")
                    }
            }
            .simultaneousGesture(
                TapGesture()
                    .onEnded { _ in
                        print("VStack tapped")
                    }
            )
        }
    }
    That will print both “Text tapped” and “VStack tapped”.
    
    Finally, SwiftUI lets us create gesture sequences, where one gesture will only become active if another gesture has first succeeded. This takes a little more thinking because the gestures need to be able to reference each other, so you can’t just attach them directly to a view.
    
    Here’s an example that shows gesture sequencing, where you can drag a circle around but only if you long press on it first:
    
    struct ContentView: View {
        // how far the circle has been dragged
        @State private var offset = CGSize.zero
    
        // whether it is currently being dragged or not
        @State private var isDragging = false
    
        var body: some View {
            // a drag gesture that updates offset and isDragging as it moves around
            let dragGesture = DragGesture()
                .onChanged { value in offset = value.translation }
                .onEnded { _ in
                    withAnimation {
                        offset = .zero
                        isDragging = false
                    }
                }
    
            // a long press gesture that enables isDragging
            let pressGesture = LongPressGesture()
                .onEnded { value in
                    withAnimation {
                        isDragging = true
                    }
                }
    
            // a combined gesture that forces the user to long press then drag
            let combined = pressGesture.sequenced(before: dragGesture)
    
            // a 64x64 circle that scales up when it's dragged, sets its offset to whatever we had back from the drag gesture, and uses our combined gesture
            Circle()
                .fill(.red)
                .frame(width: 64, height: 64)
                .scaleEffect(isDragging ? 1.5 : 1)
                .offset(offset)
                .gesture(combined)
        }
    }
    Gestures are a really great way to make fluid, interesting user interfaces, but make sure you show users how they work otherwise they can just be confusing!
    """
    var body: some View {
        // a drag gesture that updates offset and isDragging as it moves around
        let dragGesture = DragGesture()
            .onChanged { value in
                offset = value.translation
            }
            .onEnded { _ in
                withAnimation {
                    offset = .zero
                    isDragging = false
                }
            }
        // a long press gesture that enables isDragging
        let pressGesture = LongPressGesture()
            .onEnded { value in
                withAnimation {
                    isDragging = true
                }
            }
        // a combined gesture that forces the user to long press then drag
        let combined = pressGesture.sequenced(before: dragGesture)
        
        VStack {
            Text("How to use gestures in SwiftUI")
                .font(.largeTitle)
                .padding()
            
            // a 64x64 circle that scales up when it's dragged, sets its offset to whatever we had back from the drag gesture, and uses our combined gesture
            Circle()
                .fill(.red)
                .frame(width: 64, height: 64, alignment: .center)
                .scaleEffect(isDragging ? 1.5 : 1)
                .offset(offset)
                .gesture(combined)
            
            VStack {
                Text("Hello, Child Gesture.")
                    .onTapGesture {
                        print("Text --> Child Gesture tapped.") // This is priority
                    }
            }
            .simultaneousGesture(
                TapGesture()
                    .onEnded {
                        print("VStact with simultaneousGesture --> Parent Gesture tapped.") // This will be printed out because we assign highPriorityGesture at the same time allow Child Gesture to activate as well.
                    }
            )
            /*
             .highPriorityGesture(
             TapGesture()
             .onEnded {
             print("VStact with highPriorityGesture --> Parent Gesture tapped.") // This will be printed out because we assign highPriorityGesture.
             }
             )
             .onTapGesture {
             print("VStact --> Parent Gesture tapped.") // This will not print out.
             }
             */
            // Use option key on the key board to test the code below
            /* Examples of Custom Gestures
             Text("Test Use RotationGesture")
             .padding()
             .rotationEffect(finalAmountAngle + currentAmountAngle)
             .gesture(
             RotationGesture()
             .onChanged { angle in
             currentAmountAngle = angle
             }
             .onEnded{ angle in
             finalAmountAngle += currentAmountAngle
             currentAmountAngle = .zero
             })
             
             Text("Test Use MagnificationGesture ")
             .padding()
             .scaleEffect(finalAmount + currentAmount)
             .gesture(
             MagnificationGesture()
             .onChanged { amount in
             currentAmount = amount - 1
             }
             .onEnded{ amount in
             finalAmount += currentAmount
             currentAmount = 0
             })
             */
            /* Examples of Gestures
             .onTapGesture(count: 2) {
             print("Double tapped !")
             }
             .onLongPressGesture(minimumDuration: 1) {
             print("Long pressed! --> minimunDuration  1 section, with onPressingChanged")
             } onPressingChanged: { inProgress in
             print("In progress : \(inProgress)")
             }
             .onLongPressGesture {
             print("Long pressed!")
             }
             .onLongPressGesture(minimumDuration: 2) {
             print("Long pressed! --> minimunDuration 2 section")
             }
             */
            ScrollView {
                Text(info)
                    .font(.body)
                    .padding()
            }
        }
    }
}

struct GesturesView_Previews: PreviewProvider {
    static var previews: some View {
        GesturesView()
    }
}
