//
//  Day59_CoreDataWrapUpApp.swift
//  Day59_CoreDataWrapUp
//
//  Created by Lee McCormick on 5/9/22.
//

import SwiftUI

@main
struct Day59_CoreDataWrapUpApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
/* Project 12, part 3
 Are you ready for some more challenges?

 American singer and songwriter Christina Grimmie once said, “people aren't born strong; People grow stronger little by little, encountering difficult situations, learning not to run from them.” The same is absolutely true of good coders: there’s no magic switch that gets flicked when you’ve been reading books for a year, but instead your skills grow slowly over time as you face – and solve – increasingly hard problems.

 I keep encouraging you to tackle these problems because writing your own code, and finding your own solutions, matters. At first there will often be some blank page syndrome – where you stare blankly at the screen, not knowing where to start. But that’s OK, and in fact it’s to be expected. The more you practice the more adept you’ll become at figuring out solutions for yourself, and today is another step towards that goal.

 Today you should work through the wrap up chapter for project 12, complete its review, then work through all three of its challenges.

 - Core Data: Wrap up
 - Review for Project 12: Core Data
 */

/* Core Data: Wrap up
 Core Data might seem like a dry topic at first, but it’s so useful when building apps – you’ve seen how it can add, delete, sort, filter, and more, all with relatively simple code. Yes, a few parts are a little murky in Swift – NSPredicate, for example, could do with some refinement, and NSSet is never pleasant to deal with – but with a little work on our behalf this stops being a problem.

 Perhaps the most important thing about Core Data is that it’s guaranteed to be there for all apps, on all of Apple’s platforms. This means you can use it regardless of your needs: maybe it’s for saving important data, maybe it’s just a cache of content you downloaded; it doesn’t matter, because Core Data will do a great job of managing it for you.

 Review what you learned
 Anyone can sit through a tutorial, but it takes actual work to remember what was taught. It’s my job to make sure you take as much from these tutorials as possible, so I’ve prepared a short review to help you check your learning.

 Click here to review what you learned in this project.

 *** Challenge ***
 One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on.

 All three of these tasks require you to modify the FilteredList view we made:

 1) Make it accept a string parameter that controls which predicate is applied. You can use Swift’s string interpolation to place this in the predicate.
 2) Modify the predicate string parameter to be an enum such as .beginsWith, then make that enum get resolved to a string inside the initializer.
 3) Make FilteredList accept an array of SortDescriptor objects to get used in its fetch request.
 
 Tip: If you’re using the generic version of FilteredList, your sort descriptors are of type SortDescriptor<T>. If you’re using the simpler, non-generic version, your sort descriptors are of type SortDescriptor<Singer>.
 */
