//
//  Day76_Accessibility_WrapUpApp.swift
//  Day76_Accessibility_WrapUp
//
//  Created by Lee McCormick on 6/9/22.
//

import SwiftUI

@main
struct Day76_Accessibility_WrapUpApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 15, part 3
Now that you’ve seen how easy it is to fix up our projects, it’s time for you to continue that job with some challenges and a review of what you’ve learned. I think you won’t find it hard at all, and perhaps even will continue to be surprised at how easy SwiftUI makes accessibility.

Steve Ballmer (yes, that Steve Ballmer) once said “accessible design is good design – it benefits people who don’t have disabilities as well as people who do.” And he’s right: taking the time to make sure your app works for everyone will provide long-lasting benefits for all your users.

Today you should work through the wrap up chapter for project 15, complete its review, then work through all three of its challenges.

- Accessibility: Wrap up
- Review for Project 15: Accessibility
*/

/* Accessibility: Wrap up

 Accessibility isn’t something that’s “nice to have” – it should be regarded as a fundamental part of your application design, and considered from the very beginning onwards. SwiftUI didn’t get its excellent accessibility support because Apple thought about it at the last minute, but instead because it got baked in from the start – every part of SwiftUI was crafted with accessibility in mind, and we’d be doing a great disservice to our users if we didn’t match that same standard.

 What’s more, I hope you can agree that adding extra accessibility is surprisingly easy – some special values here, a little grouping there, and some bonus traits are all simple things that take only minutes to add, but are the difference between “opaque” and “easy to use” for millions of people around the world.

 - Review what you learned
 
 Anyone can sit through a tutorial, but it takes actual work to remember what was taught. It’s my job to make sure you take as much from these tutorials as possible, so I’ve prepared a short review to help you check your learning.

 *** Challenge ***
 One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on.

 1) The check out view in Cupcake Corner uses an image and loading spinner that don’t add anything to the UI, so find a way to make the screenreader not read them out.
 2) Fix the list rows in iExpense so they read out the name and value in one single VoiceOver label, and their type in a hint.
 3) Do a full accessibility review of Moonshot – what changes do you need to make so that it’s fully accessible?
*/
