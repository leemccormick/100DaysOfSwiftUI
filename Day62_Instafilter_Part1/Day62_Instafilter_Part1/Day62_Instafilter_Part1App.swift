//
//  Day62_Instafilter_Part1App.swift
//  Day62_Instafilter_Part1
//
//  Created by Lee McCormick on 5/14/22.
//

import SwiftUI

@main
struct Day62_Instafilter_Part1App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 13, part 1
 This is the first of two projects that start looking at how we push beyond the boundaries of SwiftUI so that we can connect it to Apple’s other frameworks. Apple has provided approaches for us to do this, but it takes a little thinking – it’s very different from the regular SwiftUI code you’ve been writing so far, and it’s even quite different from the kind of code UIKit developers are used to!

 Don’t worry, we’ll be tackling it step by step. I’ll provide the tutorials and a project to work towards; all you need to do is bring your brain and the willpower to push through. Remember, as the writer John Ortberg says, “if you want to walk on water, you have to get out of the boat”!

 Today you have four topics to work through, in which you’ll learn about responding to state changes, showing confirmation dialogs, and more.

 - Instafilter: Introduction
 - How property wrappers become structs
 - Responding to state changes using onChange()
 - Showing multiple options with confirmationDialog()
 */

/* Instafilter: Introduction
 In this project we’re going to build an app that lets the user import photos from their library, then modify them using various image effects. We’ll cover a number of new techniques, but at the center of it all are one useful app development skill – using Apple’s Core Image framework – and one important SwiftUI skill – integrating with UIKit. There are other things too, but those two are the big takeaways.

 Core Image is Apple’s high-performance framework for manipulating images, and it’s extraordinarily powerful. Apple has designed dozens of example image filters for us, providing things like blurs, color shifts, pixellation, and more, and all are optimized to take full advantage of the graphics processing unit (GPU) on iOS devices.

 Tip: Although you can run your Core Image app in the simulator, don’t be surprised if most things are really slow – you’ll only get great performance when you run on a physical device.

 As for integrating with UIKit, you might wonder why this is needed – after all, SwiftUI is designed to replace UIKit, right? Well, sort of. Before SwiftUI launched, almost every iOS app was built with UIKit, which means that there are probably several billion lines of UIKit code out there. So, if you want to integrate SwiftUI into an existing project you’ll need to learn how to make the two work well together.

 But there’s another reason, and I’m hoping it won’t always be a reason: many parts of Apple’s frameworks don’t have SwiftUI wrappers yet, which means if you want to integrate MapKit, Safari, or other important APIs, you need to know how to wrap their code for use with SwiftUI. I’ll be honest, the code required to make this work isn’t pretty, but at this point in your SwiftUI career you’re more than ready for it.

 As always we have some techniques to cover before we get into the project, so please create a new iOS app using the App template, naming it “Instafilter”.
 */

/* How property wrappers become structs
 You’ve seen how SwiftUI lets us store changing data in our structs by using the @State property wrapper, how we can bind that state to the value of a UI control using $, and how changes to that state automatically cause SwiftUI to reinvoke the body property of our struct.

 All that combined lets us write code such as this:

 struct ContentView: View {
     @State private var blurAmount = 0.0

     var body: some View {
         VStack {
             Text("Hello, World!")
                 .blur(radius: blurAmount)

             Slider(value: $blurAmount, in: 0...20)

             Button("Random Blur") {
                 blurAmount = Double.random(in: 0...20)
             }
         }
     }
 }
 If you run that, you’ll find that dragging the slider left and right adjusts the blur amount for the text label, exactly as you would expect, and tapping the button immediately jumps to a random blur amount.

 Now, let’s say we want that binding to do more than just handle the radius of the blur effect. Perhaps we want to run a method, or just print out the value for debugging purposes. You might try updating the property like this:

 @State private var blurAmount = 0.0 {
     didSet {
         print("New value is \(blurAmount)")
     }
 }
 If you run that code, you’ll be disappointed: as you drag the slider around you’ll see the blur amount change, but you won’t see our print() statement being triggered – in fact, nothing will be output at all. But if you try pressing the button you will see a message printed.

 To understand what’s happening here, I want you to think about when we looked at Core Data: we used the @FetchRequest property wrapper to query our data, but I also showed you how to use the FetchRequest struct directly so that we had more control over how it was created.

 Property wrappers have that name because they wrap our property inside another struct. What this means is that when we use @State to wrap a string, the actual type of property we end up with is a State<String>. Similarly, when we use @Environment and others we end up with a struct of type Environment that contains some other value inside it.

 Previously I explained that we can’t modify properties in our views because they are structs, and are therefore fixed. However, now you know that @State itself produces a struct, so we have a conundrum: how come that struct can be modified?

 Xcode has a really helpful command called “Open Quickly” (accessed using Cmd+Shift+O), which lets you find any file or type in your project or any of the frameworks you have imported. Activate it now, and type “State” – hopefully the first result says SwiftUI below it, but if not please find that and select it.

 You’ll be taken to a generated interface for SwiftUI, which is essentially all the parts that SwiftUI exposes to us. There’s no implementation code in there, just lots of definitions for protocols, structs, modifiers, and such.

 We asked to see State, so you should have been taken to this line:

 @propertyWrapper public struct State<Value> : DynamicProperty {
 That @propertyWrapper attribute is what makes this into @State for us to use.

 Now look a few lines further down, and you should see this:

 public var wrappedValue: Value { get nonmutating set }
 That wrapped value is the actual value we’re trying to store, such as a string. What this generated interface is telling us is that the property can be read (get), and written (set), but that when we set the value it won’t actually change the struct itself. Behind the scenes, it sends that value off to SwiftUI for storage in a place where it can be modified freely, so it’s true that the struct itself never changes.

 Now you know all that, let’s circle back to our problematic code:

 @State private var blurAmount = 0.0 {
     didSet {
         print("New value is \(blurAmount)")
     }
 }
 On the surface, that states “when blurAmount changes, print out its new value.” However, because @State actually wraps its contents, what it’s actually saying is that when the State struct that wraps blurAmount changes, print out the new blur amount.

 Still with me? Now let’s go a stage further: you’ve just seen how State wraps its value using a non-mutating setter, which means neither blurAmount or the State struct wrapping it are changing – our binding is directly changing the internally stored value, which means the property observer is never being triggered.

 So, changing the property directly using a button works fine, because it goes through the nonmutating setter and triggers the didSet observer, but using a binding doesn’t because it bypasses the setter and adjusts the value directly.

 How then can we solve this – how can we ensure some code is run whenever a binding is changed, no matter how that change happens? Well, there’s a modifier just for that purpose… */

/* Responding to state changes using onChange()
 Because of the way SwiftUI sends binding updates to property wrappers, assigning property observers used with property wrappers often won’t work, which means this kind of code won’t print anything even as the blur radius changes:

 struct ContentView: View {
     @State private var blurAmount: CGFloat = 0.0 {
         didSet {
             print("New value is \(blurAmount)")
         }
     }

     var body: some View {
         VStack {
             Text("Hello, World!")
                 .blur(radius: blurAmount)

             Slider(value: $blurAmount, in: 0...20)
         }
     }
 }
 To fix this we need to use the onChange() modifier, which tells SwiftUI to run a function of our choosing when a particular value changes. SwiftUI will automatically pass in the new value to whatever function you attach, or you can just read the original property if you prefer:

 struct ContentView: View {
     @State private var blurAmount = 0.0

     var body: some View {
         VStack {
             Text("Hello, World!")
                 .blur(radius: blurAmount)

             Slider(value: $blurAmount, in: 0...20)
                 .onChange(of: blurAmount) { newValue in
                     print("New value is \(newValue)")
                 }
         }
     }
 }
 Now that code will correctly print out values as the slider changes, because onChange() is watching it. Notice how most other things have stayed the same: we still use @State private var to declare the blurAmount property, and we still use blur(radius: blurAmount) as the modifier for our text view.

 What all this means is that you can do whatever you want inside the onChange() function: you can call methods, run an algorithm to figure out how to apply the change, or whatever else you might need.
 */

/* Showing multiple options with confirmationDialog()
 SwiftUI gives us alert() for presenting important announcements with one or two buttons, and sheet() for presenting whole views on top of the current view, but it also gives us confirmationDialog(): an alternative to alert() that lets us add many buttons.

 Visually alerts and confirmation dialogs are very different: on iPhones, alerts appear in the center of the screen and must actively be dismissed by choosing a button, whereas confirmation dialogs slide up from the bottom, can contain multiple buttons, and can be dismissed by tapping on Cancel or by tapping outside of the options.

 Although they look very different, confirmation dialogs and alerts are created almost identically:

 Both are created by attaching a modifier to our view hierarchy – alert() for alerts and confirmationDialog() for confirmation dialogs.
 Both get shown automatically by SwiftUI when a condition is true.
 Both can be filled with buttons to take various actions.
 Both can have a second closure attached to provide an extra message.
 To demonstrate confirmation dialogs being used, we first need a basic view that toggles some sort of condition. For example, this shows some text, and tapping the text changes a Boolean:

 struct ContentView: View {
     @State private var showingConfirmation = false
     @State private var backgroundColor = Color.white

     var body: some View {
         Text("Hello, World!")
             .frame(width: 300, height: 300)
             .background(backgroundColor)
             .onTapGesture {
                 showingConfirmation = true
             }
     }
 }
 Now for the important part: we need to add another modifier to the text, creating and showing a confirmation dialog when we’re ready.

 Just like alert(), we have a confirmationDialog() modifier that accepts two parameters: a binding that decides whether the dialog is currently presented or not, and a closure that provides the buttons that should be shown – usually provided as a trailing closure.

 We provide our confirmation dialog with a title and optionally also a message, then an array of buttons. These are stacked up vertically on the screen in the order you provide, and it’s generally a good idea to include a cancel button at the end – yes, you can cancel by tapping elsewhere on the screen, but it’s much better to give users the explicit option.

 So, add this modifier to your text view:

 .confirmationDialog("Change background", isPresented: $showingConfirmation) {
     Button("Red") { backgroundColor = .red }
     Button("Green") { backgroundColor = .green }
     Button("Blue") { backgroundColor = .blue }
     Button("Cancel", role: .cancel) { }
 } message: {
     Text("Select a new color")
 }
 When you run the app, you should find that tapping the text causes the confirmation dialog to slide over, and tapping its options should cause the text’s background color to change.
 */
