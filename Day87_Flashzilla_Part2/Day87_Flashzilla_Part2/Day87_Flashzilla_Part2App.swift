//
//  Day87_Flashzilla_Part2App.swift
//  Day87_Flashzilla_Part2
//
//  Created by Lee McCormick on 7/10/22.
//

import SwiftUI

@main
struct Day87_Flashzilla_Part2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 17, part 2 --> https://www.hackingwithswift.com/100/swiftui/87
 Cory House once said, “code is like humor. When you have to explain it, it’s bad.” I’ve touched on something similar previously – the need to write clear code that effectively communicates our intent is the mark of a good programming, and it will save many hours of maintenance and testing in the future.

 Today you’re going to be learning about monitoring notifications using Apple’s Combine framework, and you’ll see that the code is so simple it barely requires any explanation at all – and that’s despite it letting us do all sorts of monitoring for system events.

 This doesn’t happen by accident: Apple spends a lot of time doing API review, which is when cross-functional teams of developers get together to discuss what we call the surface area of an API – how it looks to us end-user developers in terms of what parameters they take, what they return, how they are named, whether they throw errors, and how they fit together in context. API review is harder than you might think, but the end result is we get great functionality with remarkably little Swift and SwiftUI code, so it’s a big win for us!

 Today you have three topics to work through, in which you’ll learn about the Combine framework, Timer, and reading specific accessibility settings.

 - Triggering events repeatedly using a timer
 - How to be notified when your SwiftUI app moves to the background
 - Supporting specific accessibility needs with SwiftUI
 */

/* Triggering events repeatedly using a timer
 iOS comes with a built-in Timer class that lets us run code on a regular basis. This uses a system of publishers that comes from an Apple framework called Combine. We’ve actually been using parts of Combine for many apps in this series, although it’s unlikely you noticed it. For example, both the @Published property wrapper and ObservableObject protocols both come from Combine, but we didn’t need to know that because when you import SwiftUI we also implicitly import parts of Combine.

 Apple’s core system library is called Foundation, and it gives us things like Data, Date, SortDescriptor, UserDefaults, and much more. It also gives us the Timer class, which is designed to run a function after a certain number of seconds, but it can also run code repeatedly. Combine adds an extension to this so that timers can become publishers, which are things that announce when their value changes. This is where the @Published property wrapper gets its name from, and timer publishers work the same way: when your time interval is reached, Combine will send an announcement out containing the current date and time.

 The code to create a timer publisher looks like this:

 let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
 That does several things all at once:

 It asks the timer to fire every 1 second.
 It says the timer should run on the main thread.
 It says the timer should run on the common run loop, which is the one you’ll want to use most of the time. (Run loops let iOS handle running code while the user is actively doing something, such as scrolling in a list.)
 It connects the timer immediately, which means it will start counting time.
 It assigns the whole thing to the timer constant so that it stays alive.
 If you remember, back in project 7 I said “@Published is more or less half of @State” – it sends change announcements that something else can monitor. In the case of regular publishers like this one, we need to catch the announcements by hand using a new modifier called onReceive(). This accepts a publisher as its first parameter and a function to run as its second, and it will make sure that function is called whenever the publisher sends its change notification.

 For our timer example, we could receive its notifications like this:

 Text("Hello, World!")
     .onReceive(timer) { time in
         print("The time is now \(time)")
     }
 That will print the time every second until the timer is finally stopped.

 Speaking of stopping the timer, it takes a little digging to stop the one we created. You see, the timer property we made is an autoconnected publisher, so we need to go to its upstream publisher to find the timer itself. From there we can connect to the timer publisher, and ask it to cancel itself. Honestly, if it weren’t for code completion this would be rather hard to find, but here’s how it looks in code:

 timer.upstream.connect().cancel()
 For example, we could update our existing example so that it fires the timer only five times, like this:

 struct ContentView: View {
     let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
     @State private var counter = 0

     var body: some View {
         Text("Hello, World!")
             .onReceive(timer) { time in
                 if counter == 5 {
                     timer.upstream.connect().cancel()
                 } else {
                     print("The time is now \(time)")
                 }

                 counter += 1
             }
     }
 }
 Before we’re done, there’s one more important timer concept I want to show you: if you’re OK with your timer having a little float, you can specify some tolerance. This allows iOS to perform important energy optimization, because it can fire the timer at any point between its scheduled fire time and its scheduled fire time plus the tolerance you specify. In practice this means the system can perform timer coalescing: it can push back your timer just a little so that it fires at the same time as one or more other timers, which means it can keep the CPU idling more and save battery power.

 As an example, this adds half a second of tolerance to our timer:

 let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
 If you need to keep time strictly then leaving off the tolerance parameter will make your timer as accurate as possible, but please note that even without any tolerance the Timer class is still “best effort” – the system makes no guarantee it will execute precisely.
 */

/* How to be notified when your SwiftUI app moves to the background
 SwiftUI can detect when your app moves to the background (i.e., when the user returns to the home screen), and when it comes back to the foreground, and if you put those two together it allows us to make sure our app pauses and resumes work depending on whether the user can see it right now or not.

 This is done using three steps:

 Adding a new property to watch an environment value called scenePhase.
 Using onChange() to watch for the scene phase changing.
 Responding to the new scene phase somehow.
 You might wonder why it’s called scene phase as opposed to something to do with your current app state, but remember that on iPad the user can run multiple instances of your app at the same time – they can have multiple windows, known as scenes, each in a different state.

 To see the various scene phases in action, try this code:

 struct ContentView: View {
     @Environment(\.scenePhase) var scenePhase

     var body: some View {
         Text("Hello, world!")
             .padding()
             .onChange(of: scenePhase) { newPhase in
                 if newPhase == .active {
                     print("Active")
                 } else if newPhase == .inactive {
                     print("Inactive")
                 } else if newPhase == .background {
                     print("Background")
                 }
             }
     }
 }
 When you run that back, try going to the home screen in your simulator, locking the virtual device, and other common activities to see how the scene phase changes.

 As you can see, there are three scene phases we need to care about:

 Active scenes are running right now, which on iOS means they are visible to the user. On macOS an app’s window might be wholly hidden by another app’s window, but that’s okay – it’s still considered to be active.
 Inactive scenes are running and might be visible to the user, but the user isn’t able to access them. For example, if you’re swiping down to partially reveal the control center then the app underneath is considered inactive.
 Background scenes are not visible to the user, which on iOS means they might be terminated at some point in the future.
 */

/* Supporting specific accessibility needs with SwiftUI
 SwiftUI gives us a number of environment properties that describe the user’s custom accessibility settings, and it’s worth taking the time to read and respect those settings.

 Back in project 15 we looked at accessibility labels and hints, traits, groups, and more, but these settings are different because they are provided through the environment. This means SwiftUI automatically monitors them for changes and will reinvoke our body property whenever one of them changes.

 For example, one of the accessibility options is “Differentiate without color”, which is helpful for the 1 in 12 men who have color blindness. When this setting is enabled, apps should try to make their UI clearer using shapes, icons, and textures rather than colors.

 To use this, just add an environment property like this one:

 @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
 That will be either true or false, and you can adapt your UI accordingly. For example, in the code below we use a simple green background for the regular layout, but when Differentiate Without Color is enabled we use a black background and add a checkmark instead:

 struct ContentView: View {
     @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor

     var body: some View {
         HStack {
             if differentiateWithoutColor {
                 Image(systemName: "checkmark.circle")
             }

             Text("Success")
         }
         .padding()
         .background(differentiateWithoutColor ? .black : .green)
         .foregroundColor(.white)
         .clipShape(Capsule())
     }
 }
 You can test that in the simulator by going to the Settings app and choosing Accessibility > Display & Text Size > Differentiate Without Color.

 Another common option is Reduce Motion, which again is available in the simulator under Accessibility > Motion > Reduce Motion. When this is enabled, apps should limit the amount of animation that causes movement on screen. For example, the iOS app switcher makes views fade in and out rather than scale up and down.

 With SwiftUI, this means we should restrict the use of withAnimation() when it involves movement, like this:

 struct ContentView: View {
     @Environment(\.accessibilityReduceMotion) var reduceMotion
     @State private var scale = 1.0

     var body: some View {
         Text("Hello, World!")
             .scaleEffect(scale)
             .onTapGesture {
                 if reduceMotion {
                     scale *= 1.5
                 } else {
                     withAnimation {
                         scale *= 1.5
                     }
                 }
             }
     }
 }
 I don’t know about you, but I find that rather annoying to use. Fortunately we can add a little wrapper function around withAnimation() that uses UIKit’s UIAccessibility data directly, allowing us to bypass animation automatically:

 func withOptionalAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
     if UIAccessibility.isReduceMotionEnabled {
         return try body()
     } else {
         return try withAnimation(animation, body)
     }
 }
 So, when Reduce Motion Enabled is true the closure code that’s passed in is executed immediately, otherwise it’s passed along using withAnimation(). The whole throws/rethrows thing is more advanced Swift, but it’s a direct copy of the function signature for withAnimation() so that the two can be used interchangeably.

 Use it like this:

 struct ContentView: View {
     @State private var scale = 1.0

     var body: some View {
         Text("Hello, World!")
             .scaleEffect(scale)
             .onTapGesture {
                 withOptionalAnimation {
                     scale *= 1.5
                 }
             }
     }
 }
 Using this approach you don’t need to repeat your animation code every time.

 One last option you should consider supporting is Reduce Transparency, and when that’s enabled apps should reduce the amount of blur and translucency used in their designs to make doubly sure everything is clear.

 For example, this code uses a solid black background when Reduce Transparency is enabled, otherwise using 50% transparency:

 struct ContentView: View {
     @Environment(\.accessibilityReduceTransparency) var reduceTransparency

     var body: some View {
         Text("Hello, World!")
             .padding()
             .background(reduceTransparency ? .black : .black.opacity(0.5))
             .foregroundColor(.white)
             .clipShape(Capsule())
     }
 }
 That’s the final technique I want you to learn ahead of building the real project, so please reset your project back to its original state so we have a clean slate to start on.
 */
