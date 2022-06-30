//
//  Day80_HotProspects_Part2App.swift
//  Day80_HotProspects_Part2
//
//  Created by Lee McCormick on 6/28/22.
//

import SwiftUI

@main
struct Day80_HotProspects_Part2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 16, part 2
 Today you’re going to tackle a tricky concept in the form of Swift’s Result type, but to balance things out we’re also going to cover two easier ones too so hopefully you don’t find today too much work.

 Swift’s Result type is designed to solve the problem when you know thing A might be true or thing B might be true, but exactly one can be true at any given time. If you imagine those as Boolean properties, then each has two states (true and false), but together they have four states:

 A is false and B is false
 A is true and B is false
 A is false and B is true
 A is true and B is true
 If you know for sure that options 1 and 4 are never possible – that either A or B must be true but they can’t both be true – then you can immediately halve the complexity of your logic.

 American author Ursula K Le Guin once said that “the only thing that makes life possible is permanent, intolerable uncertainty; not knowing what comes next.” The absolute opposite is true of good software: the more certainty we can enforce and the more constraints we can apply, the safer our code is and the more work the Swift compiler can do on our behalf.

 So, although Result requires you to think about escaping closures being passed in as parameters, the pay off is smarter, simpler, safer good – totally worth it.

 Today you have three topics to work through, in which you’ll learn about Result, objectWillChange, and image interpolation.

 - Manually publishing ObservableObject changes
 - Understanding Swift’s Result type
 - Controlling image interpolation in SwiftUI
 */

/* Manually publishing ObservableObject changes
 Classes that conform to the ObservableObject protocol can use SwiftUI’s @Published property wrapper to automatically announce changes to properties, so that any views using the object get their body property reinvoked and stay in sync with their data. That works really well a lot of the time, but sometimes you want a little more control and SwiftUI’s solution is called objectWillChange.

 Every class that conforms to ObservableObject automatically gains a property called objectWillChange. This is a publisher, which means it does the same job as the @Published property wrapper: it notifies any views that are observing that object that something important has changed. As its name implies, this publisher should be triggered immediately before we make our change, which allows SwiftUI to examine the state of our UI and prepare for animation changes.

 To demonstrate this we’re going to build an ObservableObject class that updates itself 10 times. We’re going to use a method called DispatchQueue.main.asyncAfter(), which lets us run an attached closure after a delay of our choosing, which means we can say “do this work after 1 second” rather than “do this work now.”

 In this test case, we’re going to use asyncAfter() inside a loop from 1 through 10, so we increment an integer 10 values. That integer will be wrapped using @Published so change announcements are sent out to any views that are watching it.

 Add this class somewhere in your code:

 @MainActor class DelayedUpdater: ObservableObject {
     @Published var value = 0

     init() {
         for i in 1...10 {
             DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                 self.value += 1
             }
         }
     }
 }
 To use that, we just need to add a @StatedObject property in ContentView, then show the value in our body, like this:

 struct ContentView: View {
     @StateObject var updater = DelayedUpdater()

     var body: some View {
         Text("Value is: \(updater.value)")
     }
 }
 When you run that code you’ll see the value counts upwards until it reaches 10, which is exactly what you’d expect.

 Now, if you remove the @Published property wrapper you’ll see the UI no longer changes. Behind the scenes all the asyncAfter() work is still happening, but it doesn’t cause the UI to refresh any more because no change notifications are being sent out.

 We can fix this by sending the change notifications manually using the objectWillChange property I mentioned earlier. This lets us send the change notification whenever we want, rather than relying on @Published to do it automatically.

 Try changing the value property to this:

 var value = 0 {
     willSet {
         objectWillChange.send()
     }
 }
 Now you’ll get the old behavior back again – the UI will count to 10 as before. Except this time we have the opportunity to add extra functionality inside that willSet observer. Perhaps you want to log something, perhaps you want to call another method, or perhaps you want to clamp the integer inside value so it never goes outside of a range – it’s all under our control now.
 */

/*  Understanding Swift’s Result type
 Swift provides a special type called Result that allows us to encapsulate either a successful value or some kind of error type, all in a single piece of data. So, in the same way that an optional might hold a string or might hold nothing at all, for example, Result might hold a string or might hold an error. The syntax for using it is a little odd at first, but it does have an important part to play in our projects.

 To see Result in action, we could start by writing a method that downloads an array of data readings from a server, like this:

 struct ContentView: View {
     @State private var output = ""

     var body: some View {
         Text(output)
             .task {
                 await fetchReadings()
             }
     }

     func fetchReadings() async {
         do {
             let url = URL(string: "https://hws.dev/readings.json")!
             let (data, _) = try await URLSession.shared.data(from: url)
             let readings = try JSONDecoder().decode([Double].self, from: data)
             output = "Found \(readings.count) readings"
         } catch {
             print("Download error")
         }
     }
 }
 That code works just fine, but it doesn’t give us a lot of flexibility – what if we want to stash the work away somewhere and do something else while it’s running? What if we want to read its result at some point in the future, perhaps handling any errors somewhere else entirely? Or what if we just want to cancel the work because it’s no longer needed?

 Well, we can get all that by using Result, and it’s actually available through an API you’ve met previously: Task. We could rewrite the above code to this:

 func fetchReadings() async {
     let fetchTask = Task { () -> String in
         let url = URL(string: "https://hws.dev/readings.json")!
         let (data, _) = try await URLSession.shared.data(from: url)
         let readings = try JSONDecoder().decode([Double].self, from: data)
         return "Found \(readings.count) readings"
     }
 }
 We’ve used Task before to launch pieces of work, but here we’ve given the Task object the name of fetchTask – that’s what gives us the extra flexibility to pass it around, or cancel it if needed. And notice how our Task closure returns a value now? That value gets stored in our Task instance so that we can read it in the future when we’re ready.

 More importantly, that Task might have thrown an error if the network fetch failed, or if the data decoding failed, and that’s where Result comes in: the result of our task might be a string saying “Found 10000 readings”, but it might also contain an error. The only way to find out is to look inside – it’s very similar to optionals.

 To read the result from a Task, read its result property like this:

 let result = await fetchTask.result
 Notice how we haven’t used try to read the Result out? That’s because Result holds it inside itself – an error might have been thrown, but we don’t have to worry about it now unless we want to.

 If you look at the type of result, you’ll see it’s a Result<String, Error> – if it succeeded it will contain a string, but it might also have failed and will contain an error.

 You can read the successful value directly from the Result if you want, but you’ll need to make sure and handle errors appropriately, like this:

 do {
     output = try result.get()
 } catch {
     output = "Error: \(error.localizedDescription)"
 }
 Alternatively, you can switch on the Result, and write code to check for both the success and failure cases. Each of those cases have their values inside (the string for success, and an error for failure), so Swift lets us read those values out using a specially crafted case match:

 switch result {
     case .success(let str):
         output = str
     case .failure(let error):
         output = "Error: \(error.localizedDescription)"
 }
 Regardless of how you handle it, the advantage of Result is that it lets us store the whole success or failure of some work in a single value, pass that around wherever we need, and read the error only when we’re ready.
 */

/* Controlling image interpolation in SwiftUI
 What happens if you make a SwiftUI Image view that stretches its content to be larger than its original size? By default, we get image interpolation, which is where iOS blends the pixels so smoothly you might not even realize they have been stretched at all. There’s a performance cost to this of course, but most of the time it’s not worth worrying about.

 However, there is one place where image interpolation causes a problem, and that’s when you’re dealing with precise pixels. As an example, the files for this project on GitHub contain a little cartoon alien image called example@3x.png – it’s taken from the Kenney Platform Art Deluxe bundle at https://kenney.nl/assets/platformer-art-deluxe and is available under the public domain.

 Go ahead and add that graphic to your asset catalog, then change your ContentView struct to this:

 Image("example")
     .resizable()
     .scaledToFit()
     .frame(maxHeight: .infinity)
     .background(.black)
     .ignoresSafeArea()
 That renders the alien character against a black background to make it easier to see, and because it’s resizable SwiftUI will stretch it up to fill all available space.

 Take a close look at the edges of the colors: they look jagged, but also blurry. The jagged part comes from the original image because it’s only 66x92 pixels in size, but the blurry part is where SwiftUI is trying to blend the pixels as they are stretched to make the stretching less obvious.

 Often this blending works great, but it struggles here because the source picture is small (and therefore needs a lot of blending to be shown at the size we want), and also because the image has lots of solid colors so the blended pixels stand out quite obviously.

 For situations just like this one, SwiftUI gives us the interpolation() modifier that lets us control how pixel blending is applied. There are multiple levels to this, but realistically we only care about one: .none. This turns off image interpolation entirely, so rather than blending pixels they just get scaled up with sharp edges.

 So, modify your image to this:

 Image("example")
     .interpolation(.none)
     .resizable()
     .scaledToFit()
     .frame(maxHeight: .infinity)
     .background(.black)
     .ignoresSafeArea()
 Now you’ll see the alien character retains its pixellated look, which not only is particularly popular in retro games but is also important for line art that would look wrong when blurred.
 */
