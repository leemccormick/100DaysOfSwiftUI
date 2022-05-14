//
//  Day61_FriendFaceCoreDataApp.swift
//  Day61_FriendFaceCoreData
//
//  Created by Lee McCormick on 5/14/22.
//

import SwiftUI

@main
struct Day61_FriendFaceCoreDataApp: App {
    @StateObject private var coreDataController = CoreDataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataController.container.viewContext)
        }
    }
}

/* Time for Core Data
 If I had said to you that your challenge was to build an app that fetches data from the network, decodes it into native Swift types, then displays it using a navigation view – oh, and by the way, the whole thing should be powered using Core Data… well, suffice to say you’d probably have baulked at the challenge.

 So, instead I’ve pulled a fast one: yesterday I had you work on the fundamentals of the app, making sure you understand the JSON, got your Codable support right, thought your UI through, and more.

 Today I’m going to do what inevitably happens in any real-world project: I’m going to add a new feature request to the project scope. This is sometimes called “scope creep”, and it’s something you’re going to face on pretty much every project you ever work on. That doesn’t mean planning ahead is a bad idea – as Winston Churchill said, “those who plan do better than those who do not plan, even though they rarely stick to their plan.”

 So, we’re not sticking to the plan; we’re adding an important new feature that will force you to rethink the way you’ve built your app, will hopefully lead you to think about how you structured your code, and also give you practice in a technique that you ought to be thoroughly familiar with by now: Core Data.

 Yes, your job today is to expand your app so that it uses Core Data. Your boss just emailed you to say the app is great, but once the JSON has been fetched they really want it to work offline. This means you need to use Core Data to store the information you download, then use your Core Data entities to display the views you designed – you should only need to fetch the data once. You still need to try to fetch the data every time your app loads, just in case it has changed somehow, but if that fetch fails it’s okay because you still have your Core Data back up.

 The end result will hopefully be the same as if I had given you the task all at once, but segmenting it in two like this hopefully makes it seem more within reach, while also giving you the chance to think about how well you structured your code to be adaptable as change requests come in.

 Important: please read!
 This is a hard challenge. I’m going to give you some tips below, and some of you might think “tips? Ha! I don’t need tips, I can do this myself!” But please make an exception today: there is at least one new thing you need to learn to be able to tackle this challenge, and a few extra tips will save you hours of headaches.

 First, the new thing: when we fetch data from the internet we do so using an asynchronous function – we’re writing a function that can go to sleep while our download happens, then wake up and continue working.

 Now think about this: what happens if SwiftUI is busy rendering our view, and suddenly our network task wakes up and announces that is has new data? If you’ve ever seen the movie Ghostbusters, it’s a bit like “crossing the streams” – you’re putting SwiftUI in a state where it’s trying to show some data while that same data is changing underneath its feet, and the result is going to be really unpleasant. If you’re lucky you might just see some unusual results, but a lot of the time you’ll find your app crashes.

 To fix this problem you need to make sure you update Core Data in the same place as SwiftUI updates its user interface, so that they can’t happen at the same time – we queue up the work, and it will happen only when SwiftUI is ready.

 In Swift this is called the main actor, and among other things it’s the job of the main actor to update the user interface. We can ask this main actor to do any work we want, and it will automatically get in line alongside any other work that is scheduled to happen. The main actor only ever runs one piece of code at a time, which means updating Core Data can’t ever happen in the middle of SwiftUI updating its user interface – one will always happen before or after the other.

 To run work on the main actor, use this code:

 await MainActor.run {
     // your work here
 }
 
 We need to use await because it might take some time to run – remember, the main actor won’t ever run two pieces of code at the same time, so the work we ask for might need to wait for some other work to complete first.

 So, when it comes to creating and saving all your Core Data objects, that’s definitely a task for the main actor, because it means your fetch request won’t start changing under SwiftUI’s feet.

 That’s the only new thing you need to know, but I have some other tips for you that will make today much easier. You don’t need to know these, but please take my word for it: there’s enough challenge in this task already without you trying to ignore a little friendly advice on top!

 You need to keep your original User and Friend structs, which will be used to decode the remote data.
 When you create Core Data entities, give them different names such as CachedUser and CachedFriend, so they don’t conflict with your structs.
 Add constraints on the id attributes for CachedUser and CachedFriend, to avoid duplicates.
 You’ll need to create some wrapped properties that either return the underlying Core Data attributes if they have something in there, or sensible default values otherwise.
 If you chose to use it, the tags attribute is an interesting challenge because it’s not something that fits into Core Data neatly. I would recommend you use something like user.tags.joined(separator: ",") to create one string from the array, using commas to separate the values – you can then use components(separatedBy:) later on to display them if needed.
 When you’re creating the relationship between CachedUser and CachedFriend, don’t forget to make it work both ways by adding an inverse relationship.
 That’s it! Again, this is a hard challenge, so please don’t feel bad when it feels hard. Take your time and work through

 Good luck!
 */
