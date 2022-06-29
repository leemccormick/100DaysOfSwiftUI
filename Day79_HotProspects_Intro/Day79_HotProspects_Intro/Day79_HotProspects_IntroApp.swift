//
//  Day79_HotProspects_IntroApp.swift
//  Day79_HotProspects_Intro
//
//  Created by Lee McCormick on 6/28/22.
//

import SwiftUI

@main
struct Day79_HotProspects_IntroApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 16, part 1
 Now that you’ve crossed the hump of working with UIKit, we can get back to the happier place of working in pure SwiftUI – and I think you’ll appreciate it even more now!

 In this project you’re going to be learning a really great mix of features from both Swift and SwiftUI; it will really help push your skills forward and give you the flexibility to create powerful apps. Yes, even here at 79 days through our 100 there are still lots of new things to learn – as Lily Tomlin said, “the road to success is always under construction”!

 Today you have three topics to work through, in which you’ll learn about custom environment objects, tab views, and more.

 - Hot Prospects: Introduction
 - Reading custom values from the environment with @EnvironmentObject
 - Creating tabs with TabView and tabItem()
 */

/* Hot Prospects: Introduction
 In this project we’re going to build Hot Prospects, which is an app to track who you meet at conferences. You’ve probably seen apps like it before: it will show a QR code that stores your attendee information, then others can scan that code to add you to their list of possible leads for later follow up.

 That might sound easy enough, but along the way we’re going to cover stacks of really important new techniques: creating tab bars and context menus, sharing custom data using the environment, sending custom change notifications, and more. The resulting app is awesome, but what you learn along the way will be particularly useful!

 As always we have lots of techniques to cover before we get into the implementation of our project, so please start by creating a new iOS project using the App template, naming it HotProspects.

 Let’s get to it!
 */

/* Reading custom values from the environment with @EnvironmentObject
 You’ve seen how @State is used to work with state that is local to a single view, and how @ObservedObject lets us pass one object from view to view so we can share it. Well, @EnvironmentObject takes that one step further: we can place an object into the environment so that any child view can automatically have access to it.

 Imagine we had multiple views in an app, all lined up in a chain: view A shows view B, view B shows view C, C shows D, and D shows E. View A and E both want to access the same object, but to get from A to E you need to go through B, C, and D, and they don’t care about that object. If we were using @ObservedObject we’d need to pass our object from each view to the next until it finally reached view E where it could be used, which is annoying because B, C, and D don’t care about it. With @EnvironmentObject view A can put the object into the environment, view E can read the object out from the environment, and views B, C, and D don’t have to know anything happened – it’s much nicer.

 There’s one last thing before I show you some code: environment objects use the same ObservableObject protocol you’ve already learned, and SwiftUI will automatically make sure all views that share the same environment object get updated when it changes.

 OK, let’s look at some code that shows how to share data between two views using environment objects. First, here’s some basic data we can work with:

 @MainActor class User: ObservableObject {
     @Published var name = "Taylor Swift"
 }
 As you can see, that uses @MainActor, ObservableObject, and @Published just like we’ve learned previously – all that knowledge you built up continues to pay off.

 Next we can define two SwiftUI views to use our new class. These will use the @EnvironmentObject property wrapper to say that the value of this data comes from the environment rather than being created locally:

 struct EditView: View {
     @EnvironmentObject var user: User

     var body: some View {
         TextField("Name", text: $user.name)
     }
 }

 struct DisplayView: View {
     @EnvironmentObject var user: User

     var body: some View {
         Text(user.name)
     }
 }
 That @EnvironmentObject property wrapper will automatically look for a User instance in the environment, and place whatever it finds into the user property. If it can’t find a User in the environment your code will just crash, so please be careful.

 We can now bring those two views together in one place, and send in a User instance for them to work with:

 struct ContentView: View {
     @StateObject private var user = User()

     var body: some View {
         VStack {
             EditView().environmentObject(user)
             DisplayView().environmentObject(user)
         }
     }
 }
 And that’s all it takes to get our code working – you can run the app now and change the textfield to see its value appear in the text view below. Of course, we could have represented this in a single view, but this way you can see exactly how seamless the communication is when using environment objects.

 Now, here’s the clever part. Try rewriting the body property of ContentView to this:

 VStack {
     EditView()
     DisplayView()
 }
 .environmentObject(user)
 What you’ll find is that it works identically. We’re now placing user into the environment of ContentView, but because both EditView and DisplayView are children of ContentView they inherit its environment automatically.

 Tip: Given that we are explicitly sharing our User instance with other views, I would personally be inclined to remove the private access control because it’s not accurate.

 Now, you might wonder how SwiftUI makes the connection between .environmentObject(user) and @EnvironmentObject var user: User – how does it know to place that object into the correct property?

 Well, you’ve seen how dictionaries let us use one type for the key and another for the value. The environment effectively lets us use data types themselves for the key, and instances of the type as the value. This is a bit mind bending at first, but imagine it like this: the keys are things like Int, String, and Bool, with the values being things like 5, “Hello”, and true, which means we can say “give me the Int” and we’d get back 5.
 */

/* Creating tabs with TabView and tabItem()
 Navigation views are great for letting us create hierarchical stacks of views that let users drill down into data, but they don’t work so well for showing unrelated data. For that we need to use SwiftUI’s TabView, which creates a button strip across the bottom of the screen, where tapping each button shows a different view.

 Placing tabs inside a TabView is as simple as listing them out one by one, like this:

 TabView {
     Text("Tab 1")
     Text("Tab 2")
 }
 However, in practice you will always want to customize the way the tabs are shown – in the code above the tab bar will be an empty gray space. Although you can tap on the left and right parts of that gray space to activate the two tabs, it’s a pretty terrible user experience.

 Instead, it’s a better idea to attach the tabItem() modifier to each view that’s inside a TabView. This lets you customize the way the view is shown in the tab bar, providing an image and some text to show next to it like this:

 TabView {
     Text("Tab 1")
         .tabItem {
             Label("One", systemImage: "star")
         }

     Text("Tab 2")
         .tabItem {
             Label("Two", systemImage: "circle")
         }
 }
 As well as letting the user switch views by tapping on their tab item, SwiftUI also allows us to control the current view programmatically using state. This takes four steps:

 Create an @State property to track the tab that is currently showing.
 Modify that property to a new value whenever we want to jump to a different tab.
 Pass that as a binding into the TabView, so it will be tracked automatically.
 Tell SwiftUI which tab should be shown for each value of that property.
 The first three of those are simple enough, so let’s get them out of the way. First, we need some state to track the current tab, so add this as a property to ContentView:

 @State private var selectedTab = "One"
 Second, we need to modify that somewhere, which will ask SwiftUI to switch tabs. In our little demo we could attach an onTapGesture() modifier to the first tab, like this:

 Text("Tab 1")
     .onTapGesture {
         selectedTab = "Two"
     }
     .tabItem {
         Label("One", systemImage: "star")
     }
 Third, we need to bind the selection of the TabView to $selectedTab. This is passed as a parameter when we create the TabView, so update your code to this:

 TabView(selection: $selectedTab) {
 Now for the interesting part: when we say selectedTab = "Two" how does SwiftUI know which tab that represents? You might think that the tabs could be treated as an array, in which case the second tab would be at index 1, but that causes all sorts of problems: what if we move that tab to a different position in the tab view?

 At a deeper level, it also breaks apart one of the core SwiftUI concepts: that we should be able to compose views freely. If tab 1 was the second item in the array, then:

 Tab 0 is the first tab.
 Tab 1 is the second tab.
 Tab 0 has an onTapGesture() that shows tab 1.
 Therefore tab 0 has intimate knowledge of how its parent, the TabView, is configured.
 This is A Very Bad Idea, and so SwiftUI offers a better solution: we can attach a unique identifier to each view, and use that for the selected tab. These identifiers are called tags, and are attached using the tag() modifier like this:

 Text("Tab 2")
     .tabItem {
         Image(systemName: "circle")
         Text("Two")
     }
     .tag("Two")
 So, our entire view would be this:

 struct ContentView: View {
     @State private var selectedTab = "One"

     var body: some View {
         TabView(selection: $selectedTab) {
             Text("Tab 1")
                 .onTapGesture {
                     selectedTab = "Two"
                 }
                 .tabItem {
                     Label("One", systemImage: "star")
                 }
                 .tag("One")

             Text("Tab 2")
                 .tabItem {
                     Label("Two", systemImage: "circle")
                 }
                 .tag("Two")
         }
     }
 }
 And now that code works: you can switch between tabs by pressing on their tab items, or by activating our tap gesture in the first tab.

 Of course, just using “One” and “Two” isn’t ideal – those values are fixed and so it solves the problem of views being moved around, but they aren’t easy to remember. Fortunately, you can use whatever values you like instead: give each view a string tag that is unique and reflects its purpose, then use that for your @State property. This is much easier to work with in the long term, and is recommended over integers.

 Tip: It’s common to want to use NavigationView and TabView at the same time, but you should be careful: TabView should be the parent view, with the tabs inside it having a NavigationView as necessary, rather than the other way around.
 */
