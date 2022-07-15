//
//  Day96_SnowSeeker_Part1App.swift
//  Day96_SnowSeeker_Part1
//
//  Created by Lee McCormick on 7/15/22.
//

import SwiftUI

@main
struct Day96_SnowSeeker_Part1App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 19, part 1 --> https://www.hackingwithswift.com/100/swiftui/96
 Although all our projects so far work on iPads, we haven’t really taken the time to stop and focus on it in any depth. Well, that changes in our new project because we’re going to be building an app that takes advantage of all the extra space iPads offer, and even takes advantage of the space offered by Max-sized iPhones in landscape orientation.

 Even though Apple forked iOS into iPadOS in 2019, iPads and iPhones are almost identical in terms of their software. This means we can write code that works on both platforms at the same time, making only a handful of changes to really make the most of each environment.

 When Steve Jobs launched the first iPad back in 2010 he said, “because we already shipped over 75 million iPhones, there are already 75 million users who know how to use the iPad.” This means users benefit from the similarity of the two platforms as well, because they instantly know how to use our apps on iPad thanks to existing usage on iPhone.

 Although a custom user interface can look and feel great, never under-estimated the power of this built-in knowledge!

 Today you have four topics to work through, in which you’ll learn about split view controllers, binding an alert to an optional, and using groups for flexible layout.

 - SnowSeeker: Introduction
 - Working with two side by side views in SwiftUI
 - Using alert() and sheet() with optionals
 - Using groups as transparent layout containers
 - Making a SwiftUI view searchable
 */

/* SnowSeeker: Introduction
 In this project we’re going to create SnowSeeker: an app to let users browse ski resorts around the world, to help them find one suitable for their next holiday.

 This will be the first app where we specifically aim to make something that works great on iPad by showing two views side by side, but you’ll also get deep into solving problematic layouts, learn a new way to show sheets and alerts, and more.

 As always we have some techniques to cover before getting into the main project, so please create a new iOS project using the App template, calling it SnowSeeker.

 Let’s go!
 */

/* Working with two side by side views in SwiftUI
 You might not have realized it, but one of the smartest, simplest ways that our apps adapt to varying screen sizes is actually baked right in to NavigationView.

 You’re already familiar with the basic usage of NavigationView, which allows us to create views like this one:

 struct ContentView: View {
     var body: some View {
         NavigationView {
             Text("Hello, world!")
                 .navigationTitle("Primary")
         }
     }
 }
 However, what you see when that runs depends on several factors. If you’re using an iPhone in portrait then you’ll see the layout you’ve come to expect: a large “Primary” title at the top, then a small “Hello, world!” centered in the space below.

 If you rotate that same phone to landscape, then you’ll see one of two things: on the majority of iPhones the navigation title will shrink away to small text so that it takes up less space, but on max-sized iPhones, such as the iPhone 13 Pro Max, you’ll see that our title becomes a blue button in the top-left corner, leaving the whole rest of the screen clear. Tapping that button makes the “Hello, world!” text slide in from the leading edge, where you’ll also see the “Primary” title at the top.

 On iPad things get even cleverer, because the system will select from three different layouts depending on the device’s size and the available screen space. For example, if we were using a 12.9-inch iPad Pro in landscape, then:

 If our app has the whole screen to itself, you’ll see the “Hello, world!” view visible on the left, with nothing on the right.
 If the app has very little space, it will look just like a long iPhone in portrait.
 For other sizes, you’re likely to see the “Primary” button visible, which causes the “Hello, world!” text to slide in when pressed.
 What you’re seeing here is called adaptive layout, and it’s used in many of Apple’s apps such as Notes, Mail, and more. It allows iOS to make best use of available screen space without us needing to get involved.

 What’s actually happening here is that iOS is giving us a primary/secondary layout: a primary view to act as navigation, such as selecting from a list of books we’ve read or a list of Apollo missions, and a secondary view to act as further information, such as more details about a book or Apollo mission selected in the primary view.

 In our trivial code example, SwiftUI interprets the single view inside our NavigationView as being the primary view in this primary/secondary layout. However, if we do provide two views then we get some really useful behavior out of the box. Try changing your view to this:

 NavigationView {
     Text("Hello, world!")
         .navigationTitle("Primary")

     Text("Secondary")
 }
 When you launch the app what you see once again depends on your device and orientation, but on Max-sized phones and iPads you’ll see “Secondary”, with the Primary toolbar button bringing up the “Hello, world!” view.

 SwiftUI automatically links the primary and secondary views, which means if you have a NavigationLink in the primary view it will automatically load its content in the secondary view:

 NavigationView {
     NavigationLink {
         Text("New secondary")
     } label: {
         Text("Hello, World!")
     }
     .navigationTitle("Primary")

     Text("Secondary")
 }
 However, right now at least, all this magic has a few drawbacks that I hope will be fixed in a future SwiftUI update:

 Detail views always get a navigation bar whether you want it or not, so you need to use navigationBarHidden(true) to hide it.
 There’s no way of making the primary view stay visible even when there is more than enough space.
 You can’t make the primary view shown in landscape by default; SwiftUI always chooses the detail.
 Tip: You can even add a third view to NavigationView, which lets you create a sidebar. You’ll see these in apps such as Notes, where you can navigate up from from the list of notes to browse note folders. So, navigation links in the first view control the second view, and navigation links in the second view control the third view – it’s an extra level of organization for times when you need it.
 */

/* Using alert() and sheet() with optionals
 SwiftUI has two ways of creating alerts and sheets, and so far we’ve mostly only used one: a binding to a Boolean that shows the alert or sheet when the Boolean becomes true.

 The second option allows us to bind an optional to the alert or sheet, and we used it briefly when presenting map pins. If you remember, the key is that we use an optional Identifiable object as the condition for showing the sheet, and the closure hands you the non-optional value that was used for the condition, so you can use it safely.

 To demonstrate this, we could create a trivial User struct that conforms to the Identifiable protocol:

 struct User: Identifiable {
     var id = "Taylor Swift"
 }
 We could then create a property inside ContentView that tracks which user is selected, set to nil by default:

 @State private var selectedUser: User? = nil
 Now we can change the body of ContentView so that it sets selectedUser to a value when its text view is tapped, then displays a sheet when selectedUser is given a value:

 Text("Hello, World!")
     .onTapGesture {
         selectedUser = User()
     }
     .sheet(item: $selectedUser) { user in
         Text(user.id)
     }
 With that simple code, whenever you tap “Hello, World!” a sheet saying “Taylor Swift” appears. As soon as the sheet is dismissed, SwiftUI sets selectedUser back to nil.

 This might seem like a simple piece of functionality, but it’s simpler and safer than the alternative. If we were to rewrite the above code using the old .sheet(isPresented:) modifier it would look like this:

 struct ContentView: View {
     @State private var selectedUser: User? = nil
     @State private var isShowingUser = false

     var body: some View {
         Text("Hello, World!")
             .onTapGesture {
                 selectedUser = User()
                 isShowingUser = true
             }
             .sheet(isPresented: $isShowingUser) {
                 Text(selectedUser?.id ?? "Unknown")
             }
     }
 }
 That’s another property, another value to set in the onTapGesture(), and extra code to hand the optional in the sheet() modifier – if you can avoid those things you should.

 Alerts have similar functionality, although you need to pass both the Boolean and optional Identifiable value at the same time. This allows you to show the alert when needed, but also benefit from the same optional unwrapping behavior we have with sheets:

 .alert("Welcome", isPresented: $isShowingUser, presenting: selectedUser) { user in
     Button(user.id) { }
 }
 With that covered, you now know practically all there is to know about sheets and alerts, but there is one last thing I want to sneak in to round out your knowledge.

 You see, so far we’ve written lots of alerts like this one:

 .alert("Welcome", isPresented: $isShowingUser) {
     Button("OK") { }
 }
 That OK button works because all actions dismiss the alert they belong to when they are tapped, and we’ve been using this approach so far because it gives you practice creating alerts and buttons.

 However, I want to show you a neat shortcut. Try this code out:

 .alert("Welcome", isPresented: $isShowingUser) { }
 When that runs you’ll see something interesting: exactly the same result as before, despite not having a dedicated OK button. SwiftUI spots that we don’t have any actions in the alert, so it adds a default one for us that has the title “OK” and will dismiss the alert when tapped.

 Obviously this doesn’t work in situations where you need other buttons alongside OK, but for simple alerts it’s perfect.
 */

/* Using groups as transparent layout containers
 SwiftUI’s Group view is commonly used to work around the 10-child view limit, but it also has another important behavior: it acts as a transparent layout container. This means the group doesn’t actually affect our layout at all, but still gives us the ability to add SwiftUI modifiers as needed, or send back multiple views without using @ViewBuilder.

 For example, this UserView has a Group containing three text views:

 struct UserView: View {
     var body: some View {
         Group {
             Text("Name: Paul")
             Text("Country: England")
             Text("Pets: Luna and Arya")
         }
         .font(.title)
     }
 }
 That group contains no layout information, so we don’t know whether the three text fields will be stacked vertically, horizontally, or by depth. This is where the transparent layout behavior of Group becomes important: whatever parent places a UserView gets to decide how its text views get arranged.

 For example, we could create a ContentView like this:

 struct ContentView: View {
     @State private var layoutVertically = false

     var body: some View {
         Group {
             if layoutVertically {
                 VStack {
                     UserView()
                 }
             } else {
                 HStack {
                     UserView()
                 }
             }
         }
         .onTapGesture {
             layoutVertically.toggle()
         }
     }
 }
 That flips between vertical and horizontal layout every time the group is tapped, and again you see that using Group lets us attach the tap gesture to everything at once.

 You might wonder how often you need to have alternative layouts like this, but the answer might surprise you: it’s really common! You see, this is exactly what you want to happen when trying to write code that works across multiple device sizes – if we want layout to happen vertically when horizontal space is constrained, but horizontally otherwise. Apple provides a very simple solution called size classes, which is a thoroughly vague way of telling us how much space we have for our views.

 When I say “thoroughly vague” I mean it: we have only two size classes horizontally and vertically, called “compact” and “regular”. That’s it – that covers all screen sizes from the largest iPad Pro in landscape down to the smallest iPhone in portrait. That doesn’t mean it’s useless – far from it! – just that it only lets us reason about our user interfaces in the broadest terms.

 To demonstrate size classes in action, we could create a view that has a property to track the current size class so we can switch between VStack and HStack automatically:

 struct ContentView: View {
     @Environment(\.horizontalSizeClass) var sizeClass

     var body: some View {
         if sizeClass == .compact {
             VStack {
                 UserView()
             }
         } else {
             HStack {
                 UserView()
             }
         }
     }
 }
 Tip: In situations like this, where you have only one view inside a stack and it doesn’t take any parameters, you can pass the view’s initializer directly to the VStack to make your code shorter:

 if sizeClass == .compact {
     VStack(content: UserView.init)
 } else {
     HStack(content: UserView.init)
 }
 I know short code isn’t everything, but this technique is pleasingly concise when you’re using this approach to grouped view layout.

 What you see when that code runs depends on the device you’re using. For example, an iPhone 13 Pro will have a compact horizontal size class in both portrait and landscape, whereas an iPhone 13 Pro Max will have a regular horizontal size class when in landscape.

 Regardless of whether we’re toggling our layout using size classes or tap gestures, the point is that UserView just doesn’t care – its Group simply groups the text views together without affecting their layout at all, so the layout arrangement UserView is given depends entirely on how it’s used.
 */

/* Making a SwiftUI view searchable
 iOS can add a search bar to our views using the searchable() modifier, and we can bind a string property to it to filter our data as the user types.

 To see how this works, try this simple example:

 struct ContentView: View {
     @State private var searchText = ""

     var body: some View {
         NavigationView {
             Text("Searching for \(searchText)")
                 .searchable(text: $searchText, prompt: "Look for something")
                 .navigationTitle("Searching")
         }
     }
 }
 Important: You need to make sure your view is inside a NavigationView, otherwise iOS won’t have anywhere to put the search box.

 When you run that code example, you should see a search bar you can type into, and whatever you type will be shown in the view below.

 In practice, searchable() is best used with some kind of data filtering. Remember, SwiftUI will reinvoke your body property when an @State property changes, so you could use a computed property to handle the actual filtering:

 struct ContentView: View {
     @State private var searchText = ""
     let allNames = ["Subh", "Vina", "Melvin", "Stefanie"]

     var body: some View {
         NavigationView {
             List(filteredNames, id: \.self) { name in
                 Text(name)
             }
             .searchable(text: $searchText, prompt: "Look for something")
             .navigationTitle("Searching")
         }
     }

     var filteredNames: [String] {
         if searchText.isEmpty {
             return allNames
         } else {
             return allNames.filter { $0.contains(searchText) }
         }
     }
 }
 When you run that, iOS will automatically hide the search bar at the very top of the list – you’ll need to pull down gently to reveal it, which matches the way other iOS apps work. iOS doesn’t require that we make our lists searchable, but it really makes a huge difference to users!

 Tip: Rather than using contains() here, you probably want to use another method with a much longer name: localizedCaseInsensitiveContains(). That lets us check any part of the search strings, without worrying about uppercase or lowercase letters.
 */

