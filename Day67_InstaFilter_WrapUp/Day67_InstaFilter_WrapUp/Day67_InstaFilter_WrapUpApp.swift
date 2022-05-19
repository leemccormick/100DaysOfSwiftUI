//
//  Day67_InstaFilter_WrapUpApp.swift
//  Day67_InstaFilter_WrapUp
//
//  Created by Lee McCormick on 5/16/22.
//

import SwiftUI

@main
struct Day67_InstaFilter_WrapUpApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 13, part 6
 This was a difficult project, mostly because as soon as we bring in one part of UIKit you also need to learn a fair amount of its baggage. If you had learned pure UIKit then this wouldn’t be a problem, because of course UIKit code works great when you use it with other UIKit code; it only really becomes a problem when we try to bring the two worlds together.

 Like it or not, you’re going to need to know about UIKit for the foreseeable future: it isn’t going away, and if anything is more likely to get even more powerful in the future. Remember, there are hundreds of millions of lines of code out there all written for UIKit, and if you intend to get a job building iOS apps then you’ll need to learn to love it.

 Today is a challenge day, so it’s time for you to read the wrap up chapter, take the test for this project, then complete the three challenges. As the astronaut John Young said, “the greatest enemy of progress is the illusion of knowledge” – it’s much better to take the time to challenge yourself now than assume you know it all, only to find later on that those things you “knew” weren’t quite right!

 Today you should work through the wrap up chapter for project 13, complete its review, then work through all three of its challenges.

 - Instafilter: Wrap up
 - Review for Project 13: Instafilter
 */

/* Instafilter: Wrap up

 We covered a lot of ground in this tutorial, and we’ll be coming back to a lot of it in the very next project – working with UIKit isn’t a “nice to have” for most apps, so it’s best you get used to it and start building up your library of functionality wrappers.

 Still, we also learned some great SwiftUI stuff, including confirmation dialogs and onChange(), both of which are super common and will continue to be useful for years to come.

 And there’s Core Image. This is another one Apple’s extremely powerful frameworks that never quite made the smooth leap to Swift – you need to know it’s quirks if you want to make the most of it. Still, you’re through the worst of it now, so hopefully you can try using it in your own code!

 Review what you learned
 Anyone can sit through a tutorial, but it takes actual work to remember what was taught. It’s my job to make sure you take as much from these tutorials as possible, so I’ve prepared a short review to help you check your learning.

 Click here to review what you learned in this project.

 Challenge
 One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on.

 1) Try making the Save button disabled if there is no image in the image view.
 2) Experiment with having more than one slider, to control each of the input keys you care about. For example, you might have one for radius and one for intensity.
 3) Explore the range of available Core Image filters, and add any three of your choosing to the app.
 Tip: That last one might be a little trickier than you expect. Why? Maybe have a think about it for 10 seconds!
 */
