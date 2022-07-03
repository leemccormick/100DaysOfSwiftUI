//
//  Day82_HotProspects_Part4App.swift
//  Day82_HotProspects_Part4
//
//  Created by Lee McCormick on 7/2/22.
//

import SwiftUI

@main
struct Day82_HotProspects_Part4App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 16, part 4
 It’s time to start putting your new techniques into action, and this project is so big it takes three implementation days to complete. But this is day 82, so you’ve shown you have the willpower to make amazing things – as the aviation pioneer Amelia Earhart once said, “the most difficult thing is the decision to act, the rest is merely tenacity.”

 There are lots of interesting techniques covered today, but I’ll also briefly be introducing you to the filter() method of sequences. We looked at map() previously, which is used to transform objects in a sequence from one thing into another, and filter works in a similar way: it’s a method on sequences, it accepts a closure that gets run on each element individually, and it returns a new array.

 The difference is that the closure we pass filter() is used as a predicate – a test that is used to determine whether each element should be included in the returned array. If the test returns true for an element then it gets included, otherwise it will be skipped over.

 Both filter() and map() belong to a category called functional programming. This is covered in great detail in my book Pro Swift, but the abridged definition is that our code tells the computer what to do not how to do it. In the case of map() we’re saying “go over every item in this array, transform it using this closure, and put the results back into a new array”, but it’s down to Swift to figure out how to make that happen. For filter() we’re doing much the same: “go over every item in this array, run this test on each one, and put any that pass the test into a new array.”

 Anyway, enough chat – you have lots to get through today, so let’s get on to the code!

 Today you have three topics to work through, in which you’ll learn about tab views, environment objects, filter(), and more.

 - Building our tab bar
 - Sharing data across tabs using @EnvironmentObject
 - Dynamically filtering a SwiftUI List
 */

/* Building our tab bar
 This app is going to display four SwiftUI views inside a tab bar: one to show everyone that you met, one to show people you have contacted, another to show people you haven’t contacted, and a final one showing your personal information for others to scan.

 Those first three views are variations on the same concept, but the last one is quite different. As a result, we can represent all our UI with just three views: one to display people, one to show our data, and one to bring all the others together using TabView.

 So, our first step will be to create placeholder views for our tabs that we can come back and fill in later. Press Cmd+N to make a new SwiftUI view and call it “ProspectsView”, then create another SwiftUI view called “MeView”. You can leave both of them with the default “Hello, World!” text view; it doesn’t matter for now.

 For now, what matters is ContentView, because that’s where we’re going to store our TabView that contains all the other views in our UI. We’re going to add some more logic here shortly, but for now this is just going to be a TabView with three instances of ProspectsView and one MeView. Each of those views will have a tabItem() modifier with an image that I picked out from SF Symbols and some text.

 Replace the body of your current ContentView with this:

 TabView {
     ProspectsView()
         .tabItem {
             Label("Everyone", systemImage: "person.3")
         }
     ProspectsView()
         .tabItem {
             Label("Contacted", systemImage: "checkmark.circle")
         }
     ProspectsView()
         .tabItem {
             Label("Uncontacted", systemImage: "questionmark.diamond")
         }
     MeView()
         .tabItem {
             Label("Me", systemImage: "person.crop.square")
         }
 }
 If you run the app now you’ll see a neat tab bar across the bottom of the screen, allowing us to tap through each of our four views.

 Now, obviously creating three instances of ProspectsView will be weird in practice because they’ll just be identical, but we can fix that by customizing each view. Remember, we want the first one to show every person you’ve met, the second to show people you have contacted, and the third to show people you haven’t contacted, and we can represent that with an enum plus a property on ProspectsView.

 So, add this enum inside ProspectsView now:

 enum FilterType {
     case none, contacted, uncontacted
 }
 Now we can use that to allow each instance of ProspectsView to be slightly different by giving it a new property:

 let filter: FilterType
 This will immediately break ContentView and ProspectsView_Previews because they need to provide a value for that property when creating ProspectsView, but first let’s use it to customize each of the three views just a little by giving them a navigation bar title.

 Start by adding this computed property to ProspectsView:

 var title: String {
     switch filter {
     case .none:
         return "Everyone"
     case .contacted:
         return "Contacted people"
     case .uncontacted:
         return "Uncontacted people"
     }
 }
 Now replace the default “Hello, World!” body text with this:

 NavigationView {
     Text("Hello, World!")
         .navigationTitle(title)
 }
 That at least makes each of the ProspectsView instances look slightly different so we can be sure the tabs are working correctly.

 To make our code compile again we need to make sure that every ProspectsView initializer is called with a filter. So, in ProspectsView_Previews change the body to this:

 ProspectsView(filter: .none)
 Then change the three ProspectsView instances in ContentView so they have filter: .none, filter: .contacted, and filter: .uncontacted respectively.

 If you run the app now you’ll see it’s looking better. Now for the real challenge: those first three views need to work with the same data, so how can we share it all smoothly? For that we need to turn to SwiftUI’s environment…
 */

/*  Sharing data across tabs using @EnvironmentObject
 SwiftUI’s environment lets us share data in a really beautiful way: any view can send objects into the environment, then any child view can read those objects back out from the environment at a later date. Even better, if one view changes the object all other views automatically get updated – it’s an incredibly smart way to share data in larger applications.

 In our app we have a TabView that contains three instances of ProspectsView, and we want all three of those to work as different views on the same shared data. This is a great example of where SwiftUI’s environment makes sense: we can define a class that stores one prospect, then place an array of those prospects into the environment so all our views can read it if needed.

 So, start by making a new Swift file called Prospect.swift, replacing its Foundation import with SwiftUI, then giving it this code:

 class Prospect: Identifiable, Codable {
     var id = UUID()
     var name = "Anonymous"
     var emailAddress = ""
     var isContacted = false
 }
 Yes, that’s a class rather than a struct. This is intentional, because it allows us to change instances of the class directly and have it be updated in all other views at the same time. Remember, SwiftUI takes care of propagating that change to our views automatically, so there’s no risk of views getting stale.

 When it comes to sharing that across multiple views, one of the best things about SwiftUI’s environment is that it uses the same ObservableObject protocol we’ve been using with the @StateObject property wrapper. This means we can mark properties that should be announced using the @Published property wrapper – SwiftUI takes care of most of the work for us.

 So, add this class in Prospect.swift:

 @MainActor class Prospects: ObservableObject {
     @Published var people: [Prospect]

     init() {
         self.people = []
     }
 }
 We’ll come back to that later on, not least to make the initializer do more than just create an empty array, but it’s good enough for now.

 Now, we want all our ProspectsView instances to share a single instance of the Prospects class, so they are all pointing to the same data. If we were writing UIKit code here I’d go into long explanation about how difficult this is to get right and how careful we need to be to ensure all changes get propagated cleanly, but with SwiftUI it requires just three steps.

 First, we need to add a property to ContentView that creates and stores a single instance of the Prospects class:

 @StateObject var prospects = Prospects()
 Second, we need to post that property into the SwiftUI environment, so that all child views can access it. Because tabs are considered children of the tab view they are inside, if we add it to the environment for the TabView then all our ProspectsView instances will get that object.

 So, add this modifier to the TabView in ContentView:

 .environmentObject(prospects)
 Important: Make sure you add the same modifier to the preview struct for ProspectsView, so your previews continue working.

 And now we want all instances of ProspectsView to read that object back out of the environment when they are created. This uses a new @EnvironmentObject property wrapper that does all the work of finding the object, attaching it to a property, and keeping it up to date over time. So, the final step is just adding this property to ProspectsView:

 @EnvironmentObject var prospects: Prospects
 That really is all it takes – I don’t think there’s a way SwiftUI could make this any easier.

 Important: When you use @EnvironmentObject you are explicitly telling SwiftUI that your object will exist in the environment by the time the view is created. If it isn’t present, your app will crash immediately – be careful, and treat it like an implicitly unwrapped optional.

 Soon we’re going to be adding code to add prospects by scanning QR codes, but for now we’re going to add a navigation bar item that just adds test data and shows it on-screen.

 Change the body property of ProspectsView to this:

 NavigationView {
     Text("People: \(prospects.people.count)")
         .navigationTitle(title)
         .toolbar {
             Button {
                 let prospect = Prospect()
                 prospect.name = "Paul Hudson"
                 prospect.emailAddress = "paul@hackingwithswift.com"
                 prospects.people.append(prospect)
             } label: {
                 Label("Scan", systemImage: "qrcode.viewfinder")
             }
         }
 }
 Now you’ll see a “Scan” button on the first three views of our tab view, and tapping it adds a person to all three simultaneously – you’ll see the count increment no matter which button you tap.
 */

/* Dynamically filtering a SwiftUI List
 SwiftUI’s List view likes to work with arrays of objects that conform to the Identifiable protocol, or at least can provide some sort of id parameter that is guaranteed to be unique. However, there’s no reason these need to be stored properties of a view, and in fact if we send in a computed property then we’re able to adjust our filtering on demand.

 In our app, we have three instances of ProspectsView that vary only according to the FilterType property that gets passed in from our tab view. We’re already using that to set the title of each view, but we can also use it to set the contents for a List.

 The easiest way to do this is using Swift’s filter() method. This runs every element in a sequence through a test you provide as a closure, and any elements that return true from the test are sent back as part of a new array. Our ProspectsView already has a prospects property being passed in with an array of people inside it, so we can either return all people, all contacted people, or all uncontacted people.

 Add this property to ProspectsView below the previous two:

 var filteredProspects: [Prospect] {
     switch filter {
     case .none:
         return prospects.people
     case .contacted:
         return prospects.people.filter { $0.isContacted }
     case .uncontacted:
         return prospects.people.filter { !$0.isContacted }
     }
 }
 When filter() runs, it passes every element in the people array through our test. So, $0.isContacted means “does the current element have its isContacted property set to true?” All items in the array that pass that test – that have isContacted set to true – will be added to a new array and sent back from filteredResults. And when we use !$0.isContacted we get the opposite: only prospects that haven’t been contacted get included.

 With that computed property in place, we can now create a List to loop over that array. This will show both the title and email address for each prospect using a VStack, and we’ll also use a ForEach so we can add deleting later on.

 Replace the existing text view in ProspectsView with this:

 List {
     ForEach(filteredProspects) { prospect in
         VStack(alignment: .leading) {
             Text(prospect.name)
                 .font(.headline)
             Text(prospect.emailAddress)
                 .foregroundColor(.secondary)
         }
     }
 }
 If you run the app again you’ll see things are starting to look much better.

 Before we move on, I want you to think about this: now that we’re using a computed property, how does SwiftUI know to refresh the view when the property changed? The answer is actually quite simple: it doesn’t.

 When we added an @EnvironmentObject property to ProspectsView, we also asked SwiftUI to reinvoke the body property whenever that property changes. So, whenever we insert a new person into the people array its @Published property wrapper will announce the update to all views that are watching it, and SwiftUI will reinvoke the body property of ProspectsView. That in turn will calculate our computed property again, so the List will change.

 I love the way SwiftUI transparently takes on so much work for us here, which means we can focus on how we filter and present our data rather than how to connect up all the pipes to make sure things are kept up to date.
 */
