//
//  Day88_Flashzilla_Part3App.swift
//  Day88_Flashzilla_Part3
//
//  Created by Lee McCormick on 7/10/22.
//

import SwiftUI

@main
struct Day88_Flashzilla_Part3App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 17, part 3 --> https://www.hackingwithswift.com/100/swiftui/88
 When Steve Jobs announced the very first iPhone back in January 2007, he talked about how users would interact with their new device. Take a look at what he said:

 “We’re going to use the best pointing device in the world. We’re going to use a pointing device that we’re all born with – born with ten of them. We’re going to use our fingers. We’re going to touch this with our fingers. And we have invented a new technology called multi-touch, which is phenomenal – it works like magic.”

 It’s a mark of how impactful the iPhone was on our industry that those words seem obvious today – of course we use our fingers to swipe around, what else would we use? I still have a Windows Mobile phone from the same year that the first iPhone shipped, and it has a hardware keyboard (actual physical keys you press), along with a tiny stylus that you need to use to tap the screen. Even something like scrolling around requires you to grab a scrollbar with the stylus and drag it around, and this thing shipped after the iPhone.

 Bethany Bongiorno (who, along with Toby Paterson, led the software engineering program for the first iPad), recently said they would “sit in our offices for hours playing with full-screen Google Street View on the iPad tethered units we were using for development… it was one of the moments that I remember us saying out loud – wow, this is going to blow people away.”

 We’re going to start our app implementation today by building draggable cards, and I hope you can stop to appreciate how good it feels to manipulate on-screen UI using your fingers. The iPhone is almost entirely a massive sheet of glass, and great gestures help make our apps feel real – use them wisely!

 Today you have three topics to work through, in which you’ll build a card stack, add gestures, then use those gestures to control the rest of your user interface.

 - Designing a single card view
 - Building a stack of cards
 - Moving views with DragGesture and offset()
 */

/* Designing a single card view
 In this project we want users to see a card with some prompt text for whatever they want to learn, such as “What is the capital city of Scotland?”, and when they tap it we’ll reveal the answer, which in this case is of course Edinburgh.

 A sensible place to start for most projects is to define the data model we want to work with: what does one card of information look like? If you wanted to take this app further you could store some interesting statistics such as number of times shown and number of times correct, but here we’re only going to store a string for the prompt and a string for the answer. To make our lives easier, we’re also going to add an example card as a static property, so we have some test data for previewing and prototyping.

 So, create a new Swift file called Card.swift and give it this code:

 struct Card {
     let prompt: String
     let answer: String

     static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
 }
 In terms of showing that in a SwiftUI view, we need something slightly more complicated: yes there will be two text labels shown one above the other, but we also need to show a white card behind them to bring our UI to life, then add just a touch of padding to the text so it doesn’t quite go to the edge of the card behind it. In SwiftUI terms this means a VStack for the two labels, inside a ZStack with a white RoundedRectangle.

 I don’t know if you’ve used flashcards to learn before, but they have a very particular shape that makes them wider than they are high. This makes sense if you think about it: you’re usually only writing two or three lines of text, so it’s more natural to write long-ways than short-ways.

 All our apps so far haven’t really cared about device orientation, but we’re going to make this one work only in landscape. This gives us more room to draw our cards, and it will also work better once we introduce gestures later on.

 To force landscape mode, go to your target options in the Info tab, open the disclosure indicator for the key “Supported interface orientations (iPhone)” and delete the portrait option so it leaves just the two landscape options.

 With that done we can take our first pass at a view to represent one card in our app. Create a new SwiftUI view called “CardView” and give it this code:

 struct CardView: View {
     let card: Card

     var body: some View {
         ZStack {
             RoundedRectangle(cornerRadius: 25, style: .continuous)
                 .fill(.white)

             VStack {
                 Text(card.prompt)
                     .font(.largeTitle)
                     .foregroundColor(.black)

                 Text(card.answer)
                     .font(.title)
                     .foregroundColor(.gray)
             }
             .padding(20)
             .multilineTextAlignment(.center)
         }
         .frame(width: 450, height: 250)
     }
 }
 Tip: A width of 450 is no accident: the smallest iPhones have a landscape width of 480 points, so this means our card will be fully visible on all devices.

 That will break the CardView_Previews struct because it requires a card parameter to be passed in, but we already added a static example directly to the Card struct for this very purpose. So, update the CardView_Previews struct to this:

 struct CardView_Previews: PreviewProvider {
     static var previews: some View {
         CardView(card: Card.example)
     }
 }
 If you take a look at the preview you should see our example card showing, but you can’t actually see that it’s a card – it has a white background, and so does it doesn’t stand out against the default background of our view. This will become doubly problematic when we have a stack of cards to work through, because they’ll all have white backgrounds and kind of blend into each other.

 There’s a simple fix for this: we can add a shadow to the RoundedRectangle so we get a gentle depth effect. This will help us right now by making our white card stand out from the white background, but when we start adding more cards it will look even better because the shadows will add up.

 So, add this modifier below the fill(.white):

 .shadow(radius: 10)
 Now, right now you can see both the prompt and the answer at the same time, but obviously that isn’t going to help anyone learn. So, to finish this step we’re going to hide the answer label by default, and toggle its visibility whenever the card is tapped.

 So, start by adding this new @State property to CardView:

 @State private var isShowingAnswer = false
 Now wrap the answer view in a condition for that Boolean, like this:

 if isShowingAnswer {
     Text(card.answer)
         .font(.title)
         .foregroundColor(.gray)
 }
 That simple change means it will only show the answer when isShowingAnswer is true.

 The final step is to add an onTapGesture() modifier to the ZStack, by putting this code after the frame() modifier:

 .onTapGesture {
     isShowingAnswer.toggle()
 }
 That’s our card view done for the time being, so if you want to see it in action go back to ContentView.swift and replace its body property with this:

 var body: some View {
     CardView(card: Card.example)
 }
 When you run the project you’ll see the app jumps into landscape mode automatically, and our default card appears – a good start!
 */

/* Building a stack of cards
 Now that we’ve designed one card and its associated card view, the next step is to build a stack of those cards to represent the things our user is trying to learn. This stack will change as the app is used because the user will be able to remove cards, so we need to mark it with @State.

 Right now we don’t have any way of adding cards, so we’re going to add a stack of 10 using our example card. Swift’s arrays have a helpful initializer, init(repeating:count:), which takes one value and repeats it a number of times to create the array. In our case we can use that with our example Card to create a simple test array.

 So, start by adding this property to ContentView:

 @State private var cards = [Card](repeating: Card.example, count: 10)
 Our main ContentView is going to contain a number of overlapping elements inside stacks, but for now we’re just going to put in a rough skeleton:

 Our stack of cards will be placed inside a ZStack so we can make them partially overlap with a neat 3D effect.
 Around that ZStack will be a VStack. Right now that VStack won’t do much, but later on it will allow us to place a timer above our cards.
 Around that VStack will be another ZStack, so we can place our cards and timer on top of a background.
 Right now these stacks probably feel like overkill, but it will make more sense as we progress.

 The only complex part of our next code is how we position the cards inside the card stack so they have slight overlapping. I’ve said it before, but the best way to write SwiftUI code is to carve off any messy calculations so they are handled as methods or modifiers.

 In this case we’re going to create a new stacked() modifier that takes a position in an array along with the total size of the array, and offsets a view by some amount based on those values. This will allow us to create an attractive card stack where each card is a little further down the screen than the ones before it.

 Add this extension to ContentView.swift, outside of the ContentView struct:

 extension View {
     func stacked(at position: Int, in total: Int) -> some View {
         let offset = Double(total - position)
         return self.offset(x: 0, y: offset * 10)
     }
 }
 As you can see, that pushes views down by 10 points for each place they are in the array: 0, then 10, 20, 30, and so on.

 With that simple modifier we can now build a really nice card stack effect using the layout I described earlier. Replace your current body property in ContentView with this:

 var body: some View {
     ZStack {
         VStack {
             ZStack {
                 ForEach(0..<cards.count, id: \.self) { index in
                     CardView(card: cards[index])
                         .stacked(at: index, in: cards.count)
                 }
             }
         }
     }
 }
 When you run that back you’ll see what I mean about the shadows building up as the card depth increases. It looks quite stark against a white background, but if we add a background picture you’ll see it looks better.

 In the GitHub files for this project you’ll see background@2x.jpg and background@3x.jpg – please drag those both into your asset catalog so we can use them.

 Now add this Image view into ContentView, just inside the initial ZStack:

 Image("background")
     .resizable()
     .ignoresSafeArea()
 Adding a background image is only a small change, but I think it makes the whole app look better!
 */

/* Moving views with DragGesture and offset()
 SwiftUI lets us attach custom gestures to any view, then use the values created by those gestures to manipulate the rest of our views. To demonstrate this, we’re going to attach a DragGesture to CardView so that it can be moved around, and we’ll also use the values generated by that gesture to control the opacity and rotation of the view – it will curve away and fade out as it’s dragged. This takes surprisingly little code, because SwiftUI does so much for us; I think you’ll be really impressed!

 First, add this new @State property to CardView, to track how far the user has dragged:

 @State private var offset = CGSize.zero
 Next we’re going to add three modifiers to CardView, placed directly below the frame() modifier. Remember: the order in which you apply modifiers matters, and nowhere is this more true than when working with offsets and rotations.

 If we rotate then offset, then the offset is applied based on the rotated axis of our view. For example, if we move something 100 pixels to its left then rotate 90 degrees, we’d end up with it being 100 pixels to the left and rotated 90 degrees. But if we rotated 90 degrees then moved it 100 pixels to its left, we’d end up with something rotated 90 degrees and moved 100 pixels directly down, because its concept of “left” got rotated.

 Where things get doubly tricky is when you factor in how SwiftUI creates new views by wrapping modifiers. When it comes to moving and rotating, this means if we want a view to slide directly to true west (regardless of its rotation) while also rotating it, we need to put the rotation first then the offset.

 Now, offset.width will contain how far the user dragged our card, but we don’t want to use that for our rotation because the card would spin too fast So, instead add this modifier below frame(), so we use 1/5th of the drag amount:

 .rotationEffect(.degrees(Double(offset.width / 5)))
 Next we’re going to apply our movement, so the card slides relative to the horizontal drag amount. Again, we’re not going to use the original value of offset.width because it would require the user to drag a long way to get any meaningful results, so instead we’re going to multiply it by 5 so the cards can be swiped away with small gestures.

 Add this modifier below the previous one:

 .offset(x: offset.width * 5, y: 0)
 While we’re here, I want to add one more modifier based on the drag gesture: we’re going to make the card fade out as it’s dragged further away.

 Now, the calculation for this view takes a little thinking, and I wouldn’t blame you if you wanted to spin this off into a method rather than putting it inline. Here’s how it works:

 We’re going to take 1/50th of the drag amount, so the card doesn’t fade out too quickly.
 We don’t care whether they have moved to the left (negative numbers) or to the right (positive numbers), so we’ll put our value through the abs() function. If this is given a positive number it returns the same number, but if it’s given a negative number it removes the negative sign and returns the same value as a positive number.
 We then use this result to subtract from 2.
 The use of 2 there is intentional, because it allows the card to stay opaque while being dragged just a little. So, if the user hasn’t dragged at all the opacity is 2.0, which is identical to the opacity being 1. If they drag it 50 points left or right, we divide that by 50 to get 1, and subtract that from 2 to get 1, so the opacity is still 1 – the card is still fully opaque. But beyond 50 points we start to fade out the card, until at 100 points left or right the opacity is 0.

 Add this modifier below the previous two:

 .opacity(2 - Double(abs(offset.width / 50)))
 So, we’ve created a property to store the drag amount, and added three modifiers that use the drag amount to change the way the view is rendered. What remains is the most important part: we need to actually attach a DragGesture to our card so that it updates offset as the user drags the card around. Drag gestures have two useful modifiers of their own, letting us attach functions to be triggered when the gesture has changed (called every time they move their finger), and when the gesture has ended (called when they lift their finger).

 Both of these functions are handed the current gesture state to evaluate. In our case we’ll be reading the translation property to see where the user has dragged to, and we’ll be using that to set our offset property, but you can also read the start location, predicted end location, and more. When it comes to the ended function, we’ll be checking whether the user moved it more than 100 points in either direction so we can prepare to remove the card, but if they haven’t we’ll set offset back to 0.

 Add this gesture() modifier below the previous three:

 .gesture(
     DragGesture()
         .onChanged { gesture in
             offset = gesture.translation
         }
         .onEnded { _ in
             if abs(offset.width) > 100 {
                 // remove the card
             } else {
                 offset = .zero
             }
         }
 )
 Go ahead and run the app now: you should find the cards move, rotate, and fade away as they are dragged, and if you drag more than a certain distance they stay away rather than jumping back to their original location.

 This works well, but to really finish this step we need to fill in the // remove the card comment so the card actually gets removed in the parent view. Now, we don’t want CardView to call up to ContentView and manipulate its data directly, because that causes spaghetti code. Instead, a better idea is to store a closure parameter inside CardView that can be filled with whatever code we want later on – it means we have the flexibility to get a callback in ContentView without explicitly tying the two views together.

 So, add this new property to CardView below its existing card property:

 var removal: (() -> Void)? = nil
 As you can see, that’s a closure that accepts no parameters and sends nothing back, defaulting to nil so we don’t need to provide it unless it’s explicitly needed.

 Now we can replace // remove the card with a call to that closure:

 removal?()
 Tip: That question mark in there means the closure will only be called if it has been set.

 Back in ContentView we can now write a method to handle removing a card, then connect it to that closure.

 First, add this method that takes an index in our cards array and removes that item:

 func removeCard(at index: Int) {
     cards.remove(at: index)
 }
 Finally, we can update the way we create CardView so that we use trailing closure syntax to remove the card when it’s dragged more than 100 points. This is just a matter of calling the removeCard(at:) method we just wrote, but if we wrap that inside a withAnimation() call then the other cards will automatically slide up.

 Here’s how your code should look:

 ForEach(0..<cards.count, id: \.self) { index in
     CardView(card: cards[index]) {
        withAnimation {
            removeCard(at: index)
        }
     }
     .stacked(at: index, in: cards.count)
 }
 Go ahead and run the app now – I think the result really looks great, and you can now swipe your way through all the cards in the stack until you reach the end!
 */
