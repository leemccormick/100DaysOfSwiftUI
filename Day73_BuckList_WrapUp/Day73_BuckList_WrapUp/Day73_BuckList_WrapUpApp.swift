//
//  Day73_BuckList_WrapUpApp.swift
//  Day73_BuckList_WrapUp
//
//  Created by Lee McCormick on 5/24/22.
//

import SwiftUI

@main
struct Day73_BuckList_WrapUpApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 14, part 6
 This was another difficult project, but you made it through and I hope your mind is already thinking of ways you can use the skills you learned. Whether that’s integrating maps for a shopping app, using Face ID to secure data, or something else, every skill you’re learning here will pay off in the long run.

 Today we’re on to the review and challenges portion of the project, which is where you can push your skills further with some code of your own. As Ralph Waldo Emerson once said, “unless you try to do something beyond what you have already mastered, you will never grow.” So, think of this as a growth day!

 Today you should work through the wrap up chapter for project 14, complete its review, then work through all three of its challenges.

 - Bucket List: Wrap up
 - Review for Project 14: Bucket List
 */

/* Bucket List: Wrap up

 This was our biggest project yet, but we’ve covered a huge amount of ground: adding Comparable to custom types, finding the documents directory, integrating MapKit, using biometric authentication, secure Data writing, and much more. And of course you have another real app, and hopefully you’re able to complete the challenges below to take it further.

 Although this exact project we made places maps at the center of its existence, they also extremely useful as little bonuses elsewhere – showing where a meeting takes place, or the location of a friend, etc, can add just that extra bit of useful detail to your other projects.

 Review what you learned
 Anyone can sit through a tutorial, but it takes actual work to remember what was taught. It’s my job to make sure you take as much from these tutorials as possible, so I’ve prepared a short review to help you check your learning.

 Click here to review what you learned in this project.

 *** Challenge ***
 One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on.

 1) Our + button is rather hard to tap. Try moving all its modifiers to the image inside the button – what difference does it make, and can you think why?
 2) Our app silently fails when errors occur during biometric authentication, so add code to show those errors in an alert.
 3) Create another view model, this time for EditView. What you put in the view model is down to you, but I would recommend leaving dismiss and onSave in the view itself – the former uses the environment, which can only be read by the view, and the latter doesn’t really add anything when moved into the model.
 
 Tip: That last challenge will require you to make a StateObject instance in your EditView initializer – remember to use an underscore with the property name!
 */
