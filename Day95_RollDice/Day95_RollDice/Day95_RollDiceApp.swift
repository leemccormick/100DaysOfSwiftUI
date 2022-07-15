//
//  Day95_RollDiceApp.swift
//  Day95_RollDice
//
//  Created by Lee McCormick on 7/13/22.
//

import SwiftUI

@main
struct Day95_RollDiceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Milestone: Projects 16-18 --> https://www.hackingwithswift.com/100/swiftui/95
 With two huge projects and another technique project complete, it’s time to pause and reflect on what you learned, inspect a couple of key topics more closely, then take on a fresh challenge. This is your final challenge in these 100 days, so I’ve picked out something nice and flexible – you can get it done in 30 minutes if you want, but you can also complete optional extra tasks based on whatever interests you.

 The nice thing about this challenge is that it gives you all sorts of scope to develop the app however you want, implementing the features you find most interesting or useful to you. The point is that you have a blank canvas to work with, and it’s down to you to make that into something real – you need to pick the things you want to work on, design your UI, fix your own bugs, and get it ready.

 As always, don’t be afraid of making mistakes, because it’s normal. As Roger Crawford once said, “being challenged in life is inevitable, but being defeated is optional.”

 Today you have three topics to work through, one of which of is your challenge.

 - What you learned
 - Key points
 - Challenge
 Note: Don’t worry if you don’t complete challenges in the day they were assigned – in future days you’ll find you have some time to spare here and there, so challenges are something you can return back to in the future.
 */

/* What you learned
 We’ve had some really long projects recently, but that’s mainly a result of your SwiftUI skills really growing – you’re way past the basics now, so you’re able to tackle bigger projects that solve bigger problems. I realize it can feel tiring working on these larger projects, but I hope you’re able to look back on what you built and feel good – you’ve come such a long way!

 While completing these projects, you also learned:

 - Reading environment values using @EnvironmentObject.
 - Creating tabs with TabView.
 - Using Swift’s Result type to send back success or failure.
 - Manually publishing ObservableObject changes using objectWillChange.send().
 - Controlling image interpolation.
 - Adding swipe actions to list rows,.
 - Placing buttons in a ContextMenu.
 - Creating local notifications with the UserNotifications framework.
 - Using third-party code with Swift package dependencies.
 - Using map() and filter() to create new arrays based on an existing one.
 - How to create dynamic QR codes.
 - Attaching custom gestures to a SwiftUI view.
 - Using UINotificationFeedbackGenerator to make iPhones vibrate.
 - Disabling user interactivity using allowsHitTesting().
 - Triggering events repeatedly using Timer.
 - Tracking scene state changes as our app moves between the background and foreground.
 - Supporting color blindness, reduced motion, and more.
 - SwiftUI’s three step layout system.
 - Alignment, alignment guides, and custom alignment guides.
 - Absolutely positioning views using the position() modifier.
 -  Using GeometryReader and GeometryProxy to make special effects.
 …and you also built some real apps to put those skills into action – it’s been really busy, and I hope you feel proud of what you accomplished!
 */

/* Key points
 Before we get on to the challenges for this project, there are two points I want to explore in more depth to make sure you’ve understood them thoroughly: how map() and filter() fit into the larger world of functional programming, and Swift’s Result type.

 **** Functional programming  ****
 Although I cover functional programming a lot in my book Pro Swift, I want to touch on it here too because we used it twice in project 16: once with map() and once with filter(). Both those methods are designed to let us specify what we want rather than how we get there, and both are part of a wider programming approach called functional programming.

 To demonstrate how this approach differs from a common alternative, called imperative programming, take a look at this code:

 let numbers = [1, 2, 3, 4, 5]
 var evens = [Int]()

 for number in numbers {
     if number.isMultiple(of: 2) {
         evens.append(number)
     }
 }
 That creates an array of integers, loops over them one by one, and adds those that are multiples of two to a new array called evens – we need to spell out exactly how we want the process to happen. That code is easy to read, easy to write, and works great, but if we were to rewrite it using filter() we’d get this:

 let numbers = [1, 2, 3, 4, 5]
 let evens = numbers.filter { $0.isMultiple(of: 2) }
 Now we don’t need to spell out how things should happen, and instead focus on what we want to happen: we provide filter() with a test it can perform, and it does the rest. This means our code is shorter, which is awesome, but it’s also improved in three other ways:

 It’s no longer possible to put a surprise break inside the loop – filter() will always process every element in the array, and this extra simplicity means we can focus on the test itself.
 Rather than providing a closure we can call a shared function instead, which is great for code reuse.
 The resulting evens array is now constant, so we can’t modify it by accident afterwards.
 Writing less code is always nice, but writing code that is simpler, more reusable, and less variable is even better!

 Functions that accept a function as a parameter, or send back a function as their return value, are called higher-order functions, and both map() and filter() are examples of them. Swift has many more like them, but one of the most useful is compactMap(), which:

 Runs a transformation function over every item in an array, just like map().
 Unwraps any optionals returned by that transformation function, and puts the result into a new array to be returned.
 Any optionals that are nil get discarded.
 So, while map() will create a new array containing the same number of items as the array it took in, compactMap() might return the same amount, fewer items, or even none at all!

 To see the difference between map() and compactMap() in action, try this example:

 let numbers = ["1", "2", "fish", "3"]
 let evensMap = numbers.map(Int.init)
 let evensCompactMap = numbers.compactMap(Int.init)
 That creates an array of strings, then converts it to an array of integers using map() then compactMap(). When that code runs, evensMap will contain two optional integers, then nil, then another optional integer, whereas evensCompactMap will contain three real integers – no optionality, and no nil. Much better!

 **** Result  ****
 We used Swift’s Result type as a simple way of returning a single value that either succeeded or failed, but there are a few important features I think you’ll find useful in your own code.

 First, if you think about it, Result is like a slightly more advanced form of optionals. Optionals either contain some sort of value – an integer, a string, etc – or they contain nothing at all, and Result also contains some sort of value, but now rather than nothing at all for the alternative case it must contain some sort of error.

 Behind the scenes, optionals and Result are both implemented as a Swift enum with two cases. For optionals the enum is called Optional and the cases are .none for nil and .some with an associated value of your integer/string/etc, and for Result they are .success with an associated value or .failure with another associated value.

 The only real difference between the two is that Swift has syntactic sugar in place for optionals – special syntax designed to make our life easier, because optionals are so common. So, things like if let and optional chaining exist for optionals, whereas Result doesn’t have any special code around it.

 Second, as you’ve seen a Result contains some sort of success value or some sort of error value, but if you ever need it there are ways of using Result and throwing functions interchangeably.

 If you have a Result and want to get back to do/catch territory, just call the get() method of your Result – this will return the successful value if it exists, or throws its error otherwise.

 As an example, consider code like this:

 enum NetworkError: Error {
     case badURL
 }

 func createResult() -> Result<String, NetworkError> {
     return .failure(.badURL)
 }

 let result = createResult()
 That defines some sort of error, creates a function that returns either a string or an error (but in practice always returns an error), then calls that function and puts its return value into result. If you wanted to use do/catch with that value, you could use get() like this:

 do {
     let successString = try result.get()
     print(successString)
 } catch {
     print("Oops! There was an error.")
 }
 To go the other way – to create a Result value from throwing code – you’ll find that Result has an initializer that accepts a throwing closure. If the closure returns a value successfully that gets used for the success case, otherwise the thrown error is placed into the failure case.

 For example:

 let result = Result { try String(contentsOf: someURL) }
 In that code, result will be a Result<String, Error> – it doesn’t have a specific kind of Error because String(contentsOf:) doesn’t send one back.

 The last thing you should know about Result is that it has functional methods you’re already used to, including map() and mapError(). For example, the map() method looks inside the Result, and transforms the success value into a different kind of value using a closure you specify – for example, it might transform a string into an integer. However, if it finds failure instead, it just uses that directly and ignores your transformation. Alternatively, mapError() transforms the error from one type to another, which can be helpful if you want to homogenize error types in one place.

 This is one of the many things to love about functional programming: once you understand the “takes a closure and uses it to transform stuff” nature of map(), you’ll find it exists on arrays, Result, and even Optional!
 */

/* Challenge
 Your challenge this time can be easy or hard depending on how far you want to take it, but at its core the project is simple: you need to build an app that helps users roll dice then store the results they had.

 At the very least you should lets users roll dice, and also let them see results from previous rolls. However, if you want to push yourself further you can try one or more of the following:

 1) Let the user customize the dice that are rolled: how many of them, and what type: 4-sided, 6-sided, 8-sided, 10-sided, 12-sided, 20-sided, and even 100-sided.
 2) Show the total rolled on the dice.
 3) Store the results using JSON or Core Data – anywhere they are persistent.
 4) Add haptic feedback when dice are rolled.
 5) For a real challenge, make the value rolled by the dice flick through various possible values before settling on the final figure.
 
 When I say “roll dice” you don’t need to create fancy 3D effects – just showing the numbers that were “rolled” is fine.

 The only thing that might cause you some work is step 5: making the results flick through various values before settling on the final figure. The easiest way to tackle this is through a Timer that gets cancelled after a certain number of calls.

 While you’re working, please take a moment to remember the accessibility of your code – try using it with VoiceOver and make sure it works as well as you can make it.
 */
