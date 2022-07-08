//
//  Day85_HotProspects_WrapUpApp.swift
//  Day85_HotProspects_WrapUp
//
//  Created by Lee McCormick on 7/7/22.
//

import SwiftUI

@main
struct Day85_HotProspects_WrapUpApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 16, part 7
 The British mathematician Isaac Newton once said, “if I have seen further it is by standing on the shoulders of giants.” That’s a pretty humble view to take for someone who is one of the most influential scientists of all time!

 I think the same is very much true of working with Apple’s APIs. Could I have written Create ML myself? Or UIKit? Or MapKit, or Core Image, or UserNotifications? Maybe one of them, and perhaps if I had a lot of help two of them, but it’s pretty unlikely.

 Fortunately, I don’t need to, and neither do you: Apple’s vast collection of APIs means we too are standing on the shoulders of giants. Even things like handling dates well is a huge amount of work, but it’s something we don’t need to worry about because Apple already solved it for us.

 So, seize this amazing opportunity! Build something great that combines two, three, or more frameworks and then add your own customizations on top. It’s those final steps that really set your app apart from the pack, and where you add your own value.

 Today you should work through the wrap up chapter for project 16, complete its review, then work through all three of its challenges.

 - Hot Prospects: Wrap up
 - Review for Project 16: Hot Prospects
 */

/* Hot Prospects: Wrap up
 This was our largest project yet, but the end result is another really useful app that could easily form the starting point for a real conference. Along the way we also learned about custom environment objects, TabView, Result, objectWillChange, image interpolation, context menus, local notifications, Swift package dependencies, filter() and map(), and so much more – it’s been packed!

 We’ve explored several of Apple’s other frameworks now – Core ML, MapKit, Core Image, and now UserNotifications – so I hope you’re getting a sense of just how much we can build just by relying on all the work Apple has already done for us.

 Review what you learned
 Anyone can sit through a tutorial, but it takes actual work to remember what was taught. It’s my job to make sure you take as much from these tutorials as possible, so I’ve prepared a short review to help you check your learning.

 *** Challenge ***
 One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on.

 1) Add an icon to the “Everyone” screen showing whether a prospect was contacted or not.
 2) Use JSON and the documents directory for saving and loading our user data.
 3) Use a confirmation dialog to customize the way users are sorted in each tab – by name or by most recent.
 */

/* CodeScanner
 My package is called CodeScanner, and its available on GitHub under the MIT license at https://github.com/twostraws/CodeScanner – you’re welcome to inspect and/or edit the source code if you want. Here, though, we’re just going to add it to Xcode by following these steps:
 1) Go to File > Swift Packages > Add Package Dependency.
 2) Enter https://github.com/twostraws/CodeScanner as the package repository URL.
 3) For the version rules, leave “Up to Next Major” selected, which means you’ll get any bug fixes and additional features but not any breaking changes.
 4) Press Finish to import the finished package into your project.
 */
