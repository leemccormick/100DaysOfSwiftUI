//
//  Day34_GuessTheFlagAnimationApp.swift
//  Day34_GuessTheFlagAnimation
//
//  Created by Lee McCormick on 4/3/22.
//

import SwiftUI

@main
struct Day34_GuessTheFlagAnimationApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 6, part 3
 Diana Scharf-Hunt once said, “goals are dreams with deadlines.” Well, we know your goal is to learn SwiftUI because that’s why you’re here, so it’s time to add a deadline too: your mission today is to complete three animation challenges that will really put your skills – and your creativity! – to the test.
 
 As you’ll see, one of the challenges today specifically asks you to be creative and try something yourself. You have all the tools now to create a huge variety of animations and transitions, so all that’s holding you back is the opportunity to practice.
 
 Well, this is it – good luck!
 
 Today you should work through the wrap up chapter for project 6, complete its review, then work through all three of its challenges.
 
 Animation: Wrap up
 Review for Project 6: Animation
 I look forward to seeing what you create with the third challenge – make a video and share it on Twitter, making sure to add @twostraws somewhere in there so I see it!
 
 Need help? Tweet me @twostraws!
 */

/* Animation: Wrap up
 Paul Hudson     @twostraws    November 2nd 2021
 
 This technique project started off easier, took a few twists and turns, and progressed into more advanced animations, but I hope it’s given you an idea of just how powerful – and how flexible! – SwiftUI’s animation system is.
 
 As I’ve said previously, animation is about both making your app look great and also adding extra meaning. So, rather than making a view disappear abruptly, can you add a transition to help the user understand something is changing?
 
 Also, don’t forget what it looks like to be playful in your user interface. My all-time #1 favorite iOS animation is one that Apple ditched when they moved to iOS 7, and it was the animation for deleting passes in the Wallet app – a metal shredder appeared and cut your pass into a dozen strips that then dropped away. It only took a fraction of a second more than the current animation, but it was beautiful and fun too!
 
 Review what you learned
 Anyone can sit through a tutorial, but it takes actual work to remember what was taught. It’s my job to make sure you take as much from these tutorials as possible, so I’ve prepared a short review to help you check your learning.
 
 Click here to review what you learned in this project.
 
 Challenge
 One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on.
 
 Go back to the Guess the Flag project and add some animation:
 
 - When you tap a flag, make it spin around 360 degrees on the Y axis.
 - Make the other two buttons fade out to 25% opacity.
 - Add a third effect of your choosing to the two flags the user didn’t choose – maybe make them scale down? Or flip in a different direction? Experiment!
 
 These challenges aren’t easy. They take only a few lines of code, but you’ll need to think carefully about what modifiers you use to get the exact animations you want. Try adding an @State property to track which flag the user tapped on, then using that inside conditional modifiers for rotation, fading, and whatever you decide for the third challenge.
 */
