//
//  Day16_WeSpiltPart1App.swift
//  Day16_WeSpiltPart1
//
//  Created by Lee McCormick on 3/16/22.
//

import SwiftUI

@main
struct Day16_WeSpiltPart1App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/*
 In this project we’re going to be building a check-splitting app that you might use after eating at a restaurant – you enter the cost of your food, select how much of a tip you want to leave, and how many people you’re with, and it will tell you how much each person needs to pay.

 This project isn’t trying to build anything complicated, because its real purpose is to teach you the basics of SwiftUI in a useful way while also giving you a real-world project you can expand on further if you want.

 You’ll learn the basics of UI design, how to let users enter values and select from options, and how to track program state. As this is the first project, we’ll be going nice and slow and explaining everything along the way – subsequent projects will slowly increase the speed, but for now we’re taking it easy.

 This project – like all the projects that involve building a complete app – is broken down into three stages:

 1. A hands-on introduction to all the techniques you’ll be learning.
 2. A step-by-step guide to build the project.
 4. Challenges for you to complete on your own, to take the project further.
 
 Each of those are important, so don’t try to rush past any of them.

 In the first step I’ll be teaching you each of the individual new components in isolation, so you can understand how they work individually. There will be lots of code, but also some explanation so you can see how everything works just by itself. This step is an overview: here are the things we’re going to be using, here is how they work, and here is how you use them.

 In the second step we’ll be taking those concepts and applying them in a real project. This is where you’ll see how things work in practice, but you’ll also get more context – here’s why we want to use them, and here’s how they fit together with other components.

 In the final step we’ll be summarizing what you learned, and then you’ll be given a short test to make sure you’ve really understood what was covered. You’ll also be given three challenges: three wholly new tasks that you need to complete yourself, to be sure you’re able to apply the skills you’ve learned. We don’t provide solutions for these challenges (so please don’t write an email asking for them!), because they are there to test you rather than following along with a solution.

 Anyway, enough chat: it’s time to begin the first project. We’re going to look at the techniques required to build our check-sharing app, then use those in a real project.

So, launch Xcode now, and choose Create A New Xcode Project. You’ll be shown a list of options, and I’d like you to choose iOS and App, then press Next. On the subsequent screen you need to do the following:

 - For Product Name please enter “WeSplit”.
 - For Organization Identifier you can enter whatever you want, but if you have a website you should enter it with the components reversed: “hackingwithswift.com” would be “com.hackingwithswift”. If you don’t have a domain, make one up – “me.yourlastname.yourfirstname” is perfectly fine.
 - For Interface please select SwiftUI.
 - For Language please make sure you have Swift selected.
 - Make sure all the checkboxes at the bottom are not checked.
 
 In case you were curious about the organization identifier, you should look at the text just below: “Bundle Identifier”. Apple needs to make sure all apps can be identified uniquely, and so it combines the organization identifier – your website domain name in reverse – with the name of the project. So, Apple might have the organization identifier of “com.apple”, so Apple’s Keynote app might have the bundle identifier “com.apple.keynote”.

 When you’re ready, click Next, then choose somewhere to save your project and click Create. Xcode will think for a second or two, then create your project and open some code ready for you to edit.

 Later on we’re going to be using this project to build our check-splitting app, but for now we’re going to use it as a sandbox where we can try out some code.

 Important: All the projects we’re building in this series target iOS 15.0 or later, but by default Xcode creates new projects to target iOS 14.0. To fix this you need to select “WeSplit” in the project navigator in the left-hand side of Xcode – it’s at the very top of the sidebar – then select WeSplit under the Targets list, and finally change “iOS 14.0” to “iOS 15.0” in the Deployment Info section.

 Repeat: Yes, I’m repeating this because it’s so important: for this project and all projects in this book, you need to update your target’s deployment info option so that it uses iOS 15.0 rather than iOS 14.0.

 Okay, let’s get to it!
 */

