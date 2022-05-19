//
//  Day68_BacketList_Part1App.swift
//  Day68_BacketList_Part1
//
//  Created by Lee McCormick on 5/18/22.
//

import SwiftUI

@main
struct Day68_BacketList_Part1App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 14, part 1
 You’ll be pleased to know that today is the easiest day you will have had in a while. That doesn’t mean we’re looking at unimportant stuff, only that the new techniques we’re covering are pretty much guaranteed to be a welcome break from the coordinators, selectors, and more you’ve recently had to face.

 All I can is this: enjoy it while it lasts! Tomorrow we’re back on to the hard stuff, which I hope shouldn’t come as a surprise given that you’re well past the two-thirds mark in these 100 days.

 Keep going! As Vince Lombardi said, “the only place success comes before work is in the dictionary.”

 Today you have four topics to work through, in which you’ll learn how about implementing Comparable, finding the user’s documents directory, and more.

 - Bucket List: Introduction
 - Adding conformance to Comparable for custom types
 - Writing data to the documents directory
 - Switching view states with enums
 */

/* Bucket List: Introduction

 In this project we’re going to build an app that lets the user build a private list of places on the map that they intend to visit one day, add a description for that place, look up interesting places that are nearby, and save it all to the iOS storage for later.

 To make all that work will mean leveraging some skills you’ve met already, such as forms, sheets, Codable, and URLSession, but also teach you some new skills: how to embed maps in a SwiftUI app, how to store private data safely so that only an authenticated user can access it, how to load and save data outside of UserDefaults, and more.

 So, lots to learn and another great app to make! Anyway, let’s get started with our techniques: create a new iOS project using the App template, and name it BucketList. And now on to our techniques…
 */

/* Adding conformance to Comparable for custom types
 When you think about it, we take a heck of a lot of stuff for granted when we write Swift code. For example, if we write 4 < 5, we expect that to return true – the developers of Swift (and LLVM, larger compiler project that sits behind Swift) have already done all the hard work of checking whether that calculation is actually true, so we don’t have to worry about it.

 But what Swift does really well is extend functionality into lots of places using protocols and protocol extensions. For example, we know that 4 < 5 is true because we’re able to compare two integers and decide whether the first one comes before or after the second. Swift extends that functionality to arrays of integers: we can compare all the integers in an array to decide whether each one should come before or after the others. Swift then uses that result to sort the array.

 So, in Swift we expect this kind of code to Just Work:

 struct ContentView: View {
     let values = [1, 5, 3, 6, 2, 9].sorted()

     var body: some View {
         List(values, id: \.self) {
             Text(String($0))
         }
     }
 }
 We don’t need to tell sorted() how it should work, because it understands how arrays of integers work.

 Now consider a struct like this one:

 struct User: Identifiable {
     let id = UUID()
     let firstName: String
     let lastName: String
 }
 We could make an array of those users, and use them inside a List like this:

 struct ContentView: View {
     let users = [
         User(firstName: "Arnold", lastName: "Rimmer"),
         User(firstName: "Kristine", lastName: "Kochanski"),
         User(firstName: "David", lastName: "Lister"),
     ]

     var body: some View {
         List(users) { user in
             Text("\(user.lastName), \(user.firstName)")
         }
     }
 }
 That will work just fine, because we made the User struct conform to Identifiable.

 But how about if we wanted to show those users in a sorted order? If we modify the code to this it won’t work:

 let users = [
     User(firstName: "Arnold", lastName: "Rimmer"),
     User(firstName: "Kristine", lastName: "Kochanski"),
     User(firstName: "David", lastName: "Lister"),
 ].sorted()
 Swift doesn’t understand what sorted() means here, because it doesn’t know whether to sort by first name, last name, both, or something else.

 Previously I showed you how we could provide a closure to sorted() to do the sorting ourselves, and we could use the same here:

 let users = [
     User(firstName: "Arnold", lastName: "Rimmer"),
     User(firstName: "Kristine", lastName: "Kochanski"),
     User(firstName: "David", lastName: "Lister"),
 ].sorted {
     $0.lastName < $1.lastName
 }
 That absolutely works, but it’s not an ideal solution for two reasons.

 First, this is model data, by which I mean that it’s affecting the way we work with the User struct. That struct and its properties are our data model, and in a well-developed application we don’t really want to tell the model how it should behave inside our SwiftUI code. SwiftUI represents our view, i.e. our layout, and if we put model code in there then things get confused.

 Second, what happens if we want to sort User arrays in multiple places? You might copy and paste the closure once or twice, before realizing you’re just creating a problem for yourself: if you end up changing your sorting logic so that you also use firstName if the last name is the same, then you need to search through all your code to make sure all the closures get updated.

 Swift has a better solution. Arrays of integers get a simple sorted() method with no parameters because Swift understands how to compare two integers. In coding terms, Int conforms to the Comparable protocol, which means it defines a function that takes two integers and returns true if the first should be sorted before the second.

 We can make our own types conform to Comparable, and when we do so we also get a sorted() method with no parameters. This takes two steps:

 Add the Comparable conformance to the definition of User.
 Add a method called < that takes two users and returns true if the first should be sorted before the second.
 Here’s how that looks in code:

 struct User: Identifiable, Comparable {
     let id = UUID()
     let firstName: String
     let lastName: String

     static func <(lhs: User, rhs: User) -> Bool {
         lhs.lastName < rhs.lastName
     }
 }
 There’s not a lot of code in there, but there is still a lot to unpack.

 First, yes the method is just called <, which is the “less than” operator. It’s the job of the method to decide whether one user is “less than” (in a sorting sense) another, so we’re adding functionality to an existing operator. This is called operator overloading, and it can be both a blessing and a curse.

 Second, lhs and rhs are coding conventions short for “left-hand side” and “right-hand side”, and they are used because the < operator has one operand on its left and one on its right.

 Third, this method must return a Boolean, which means we must decide whether one object should be sorted before another. There is no room for “they are the same” here – that’s handled by another protocol called Equatable.

 Fourth, the method must be marked as static, which means it’s called on the User struct directly rather than a single instance of the struct.

 Finally, our logic here is pretty simple: we’re just passing on the comparison to one of our properties, asking Swift to use < for the two last name strings. You can add as much logic as you want, comparing as many properties as needed, but ultimately you need to return true or false.

 Tip: One thing you can’t see in that code is that conforming to Comparable also gives us access to the > operator – greater than. This is the opposite of <, so Swift creates it for us by using < and flipping the Boolean between true and false.

 Now that our User struct conforms to Comparable, we automatically get access to the parameter-less version of sorted(), which means this kind of code works now:

 let users = [
     User(firstName: "Arnold", lastName: "Rimmer"),
     User(firstName: "Kristine", lastName: "Kochanski"),
     User(firstName: "David", lastName: "Lister"),
 ].sorted()
 This resolves the problems we had before: we now isolate our model functionality in the struct itself, and we no longer need to copy and paste code around – we can use sorted() everywhere, safe in the knowledge that if we ever change the algorithm then all our code will adapt.
 */

/* Writing data to the documents directory
 Previously we looked at how to read and write data to UserDefaults, which works great for user settings or small amounts of JSON. However, it’s generally not a great place to store data, particularly if you think you’ll start storing more in the future.

 In this app we’re going to be letting users create as much data as they want, which means we want a better storage solution than just throwing things into UserDefaults and hoping for the best. Fortunately, iOS makes it very easy to read and write data from device storage, and in fact all apps get a directory for storing any kind of documents we want. Files here are automatically synchronized with iCloud backups, so if the user gets a new device then our data will be restored along with all the other system data – we don’t even need to think about it.

 There is a catch – isn’t there always? – and it’s that all iOS apps are sandboxed, which means they run in their own container with a hard to guess directory name. As a result, we can’t – and shouldn’t try to – guess the directory where our app is installed, and instead need to rely on Apple’s API for finding our app’s documents directory.

 There is no nice way of doing this, so I nearly always just copy and paste the same helper method into my projects, and we’re going to do exactly the same thing now. This uses a new class called FileManager, which can provide us with the document directory for the current user. In theory this can return several path URLs, but we only ever care about the first one.

 So, add this method to ContentView:

 func getDocumentsDirectory() -> URL {
     // find all possible documents directories for this user
     let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

     // just send back the first one, which ought to be the only one
     return paths[0]
 }
 That documents directory is ours to do with as we please, and because it belongs to the app it will automatically get deleted if the app itself gets deleted. Other than physical device limitations there is no limit to how much we can store, although remember that users can use the Settings app to see how much storage your app takes up – be respectful!

 Now that we have a directory to work with, we can read and write files there freely. You already met String(contentsOf:) and Data(contentsOf:) for reading data, but for writing data we need to use the write(to:) method. When used with strings this takes three parameters:

 A URL to write to.
 Whether to make the write atomic, which means “all at once”.
 What character encoding to use.
 The first of those can be created by combining the documents directory URL with a filename, such as myfile.txt.

 The second should nearly always be set to true. If this is set to false and we try to write a big file, it’s possible that another part of our app might try and read the file while it’s still being written. This shouldn’t cause a crash or anything, but it does mean that it’s going to read only part of the data, because the other part hasn’t been written yet. Atomic writing causes the system to write our full file to a temporary filename (not the one we asked for), and when that’s finished it does a simple rename to our target filename. This means either the whole file is there or nothing is.

 The third parameter is something we looked at briefly in project 5, because we had to use a Swift string with an Objective-C API. Back then we used the character encoding UTF-16, which is what Objective-C uses, but Swift’s native encoding is UTF-8, so we’re going to use that instead.

 To put all this code into action, we’re going to modify the default text view of our template so that it writes a test string to a file in the documents directory, reads it back into a new string, then prints it out – the complete cycle of reading and writing data.

 Change the body property of ContentView to this:

 Text("Hello World")
     .onTapGesture {
         let str = "Test Message"
         let url = getDocumentsDirectory().appendingPathComponent("message.txt")

         do {
             try str.write(to: url, atomically: true, encoding: .utf8)
             let input = try String(contentsOf: url)
             print(input)
         } catch {
             print(error.localizedDescription)
         }
     }
 When that runs you should be able to tap the label to see “Test message” printed to Xcode’s debug output area.

 Before we move on, here’s a small challenge for you: back in project 8 we looked at how to create a generic extension on Bundle that let us find, load, and decode any Codable data from our app bundle. Can you write something similar for the documents directory, perhaps making it an extension on FileManager?
 */

/* Switching view states with enums
 You’ve seen how we can use regular Swift conditions to present one type of view or the other, and we looked at code along the lines of this:

 if Bool.random() {
     Rectangle()
 } else {
     Circle()
 }
 Tip: When returning different kinds of view, make sure you’re either inside the body property or using something like @ViewBuilder or Group.

 Where conditional views are particularly useful is when we want to show one of several different states, and if we plan it correctly we can keep our view code small and also easy to maintain – it’s a great way to start training your brain to think about SwiftUI architecture.

 There are two parts to this solution. The first is to define an enum for the various view states you want to represent. For example, you might define this as a nested enum:

 enum LoadingState {
     case loading, success, failed
 }
 Next, create individual views for those states. I’m just going to use simple text views here, but they could hold anything:

 struct LoadingView: View {
     var body: some View {
         Text("Loading...")
     }
 }

 struct SuccessView: View {
     var body: some View {
         Text("Success!")
     }
 }

 struct FailedView: View {
     var body: some View {
         Text("Failed.")
     }
 }
 Those views could be nested if you want, but they don’t have to be – it really depends on whether you plan to use them elsewhere and the size of your app.

 With those two parts in place, we now effectively use ContentView as a simple wrapper that tracks the current app state and shows the relevant child view. That means giving it a property to store the current LoadingState value:

 var loadingState = LoadingState.loading
 Then filling in its body property with code that shows the correct view based on the enum value, like this:

 if loadingState == .loading {
     LoadingView()
 } else if loadingState == .success {
     SuccessView()
 } else if loadingState == .failed {
     FailedView()
 }
 Using this approach our ContentView doesn’t spiral out of control as more and more code gets added to the views, and in fact has no idea what loading, success, or failure even look like.
 */
