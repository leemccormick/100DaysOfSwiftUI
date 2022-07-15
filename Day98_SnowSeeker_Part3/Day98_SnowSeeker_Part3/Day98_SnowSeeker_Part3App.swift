//
//  Day98_SnowSeeker_Part3App.swift
//  Day98_SnowSeeker_Part3
//
//  Created by Lee McCormick on 7/15/22.
//

import SwiftUI

@main
struct Day98_SnowSeeker_Part3App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 19, part 3 --> https://www.hackingwithswift.com/100/swiftui/98
 It’s time to write the final part of our final project, which means implementing three important features: adjusting the UI to make the most of our available space, showing more information about each facility when it’s tapped, and letting the user mark favorites.

 The first two of those probably sound easy, but as you’ll see they come with interesting complexities that take some thinking to solve. That’s okay, though – you’re near the very end of the 100 days now, so thinking about complex SwiftUI should be well within the scope of your abilities. These things might have been hard for you four or five weeks ago, but at this point I hope they are almost second nature. As David A. Smith once said, “it’s only hard until it becomes easy.”

 Today you have three topics to work through, in which you’ll add support for size classes, show more information about facilities, and let users mark favorite resorts.

 - Changing a view’s layout in response to size classes
 - Binding an alert to an optional string
 - Letting the user mark favorites
 That’s another project finished – don’t forget to share your progress with others, because there’s value in staying accountable even now!
 */

/* Changing a view’s layout in response to size classes
 SwiftUI gives us two environment values to monitor the current size class of our app, which in practice means we can show one layout when space is restricted and another when space is plentiful.

 For example, in our current layout we’re displaying the resort details and snow details in a HStack, like this:

 HStack {
     ResortDetailsView(resort: resort)
     SkiDetailsView(resort: resort)
 }
 Each of those subviews are internally using a Group that doesn’t add any of its own layout, so we end up with all four pieces of text laid out horizontally. This looks great when we have enough space, but when space is limited it would be helpful to switch to a 2x2 grid layout.

 To make this happen we could create copies of ResortDetailsView and SkiDetailsView that handle the alternative layout, but a much smarter solution is to have both those views remain layout neutral – to have them automatically adapt to being placed in a HStack or VStack depending on the parent that places them.

 First, add this new @Environment property to ResortView:

 @Environment(\.horizontalSizeClass) var sizeClass
 That will tell us whether we have a regular or compact size class. Very roughly:

 All iPhones in portrait have compact width and regular height.
 Most iPhones in landscape have compact width and compact height.
 Large iPhones (Plus-sized and Max devices) in landscape have regular width and compact height.
 All iPads in both orientations have regular width and regular height when your app is running with the full screen.
 Things get a little more complex for iPad when it comes to split view mode, which is when you have two apps running side by side – iOS will automatically downgrade our app to a compact size class at various points depending on the exact iPad model.

 Fortunately, to begin with all we care about are these two horizontal options: do we have lots of horizontal space (regular) or is space restricted (compact). If we have a regular amount of space, we’re going to keep the current HStack approach so that everything its neatly on one line, but if space is restricted we’ll ditch that and place each of the views into a VStack.

 So, find the HStack that contains ResortDetailsView and SkiDetailsView and replace it with this:

 HStack {
     if sizeClass == .compact {
         VStack(spacing: 10) { ResortDetailsView(resort: resort) }
         VStack(spacing: 10) { SkiDetailsView(resort: resort) }
     } else {
         ResortDetailsView(resort: resort)
         SkiDetailsView(resort: resort)
     }
 }
 .padding(.vertical)
 .background(Color.primary.opacity(0.1))
 As you can see, that uses two vertical stacks placed side by side, rather than just having all four views horizontal.

 Is it perfect? Well, no. Sure, there’s a lot more space in compact layouts, which means the user can use larger Dynamic Type sizes without running out of space, but many users won’t have that problem because they’ll be using the default size or even smaller sizes.

 To make this even better we can combine a check for the app’s current horizontal size class with a check for the user’s Dynamic Type setting so that we use the flat horizontal layout unless space really is tight – if the user has a compact size class and a larger Dynamic Type setting.

 First add another property to read the current Dynamic Type setting:

 @Environment(\.dynamicTypeSize) var typeSize
 Now modify the size class check to this:

 if sizeClass == .compact && typeSize > .large {
 Now finally our layout should look great in both orientations: one single line of text in a regular size class, and two rows of vertical stacks in a compact size class when an increased font size is used. It took a little work, but we got there in the end!

 Our solution didn’t result in code duplication, which is a huge win, but it also left our two child views in a better place – they are now there just to serve up their content without specifying a layout. So, parent views can dynamically switch between HStack and VStack whenever they want, and SwiftUI will take care of the layout for us.

 Before we’re done, I want to show you one useful extra technique: you can limit the range of Dynamic Type sizes supported by a particular view. For example, you might have worked hard to support as wide a range of sizes as possible, but found that anything larger than the “extra extra extra large” setting just looks bad. In that situation you can use the dynamicTypeSize() modifier on a view, like this:

 .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
 That’s a one-sided range, meaning that any size up to and including .xxxLarge is fine, but nothing larger. Obviously it’s best to avoid setting these limits where possible, but it’s not a problem if you use it judiciously – both TabView and NavigationView, for example, limit the size of their text labels so the UI doesn’t break.
 */

/* Binding an alert to an optional string
 SwiftUI lets us present an alert with an optional source of truth inside, but it takes a little thinking to get right as you’ll see.

 To demonstrate these optional alerts in action, we’re going to rewrite the way our resort facilities are shown. Right now we have a plain text view generated like this:

 Text(resort.facilities, format: .list(type: .and))
     .padding(.vertical)
 We’re going to replace that with icons that represent each facility, and when the user taps on one we’ll show an alert with a description of that facility.

 As usual we’re going to start small then work our way up. First, we need a way to convert facility names like “Accommodation” into an icon that can be displayed. Although this will only happen in ResortView right now, this functionality is exactly the kind of thing that should be available elsewhere in our project. So, we’re going to create a new struct to hold all this information for us.

 Create a new Swift file called Facility.swift, replace its Foundation import with SwiftUI, and give it this code:

 struct Facility: Identifiable {
     let id = UUID()
     var name: String

     private let icons = [
         "Accommodation": "house",
         "Beginners": "1.circle",
         "Cross-country": "map",
         "Eco-friendly": "leaf.arrow.circlepath",
         "Family": "person.3"
     ]

     var icon: some View {
         if let iconName = icons[name] {
             return Image(systemName: iconName)
                 .accessibilityLabel(name)
                 .foregroundColor(.secondary)
         } else {
             fatalError("Unknown facility type: \(name)")
         }
     }
 }
 As you can see, that conforms to Identifiable so we can loop over an array of facilities with SwiftUI, and internally it looks up a given facility name in a dictionary to return the correct icon. I’ve picked out various SF Symbols icons that work well for the facilities we have, and I also used an accessibilityLabel() modifier for the image to make sure it works well in VoiceOver.

 The next step is to create Facility instances for every of the facilities in a Resort, which we can do in a computed property inside the Resort struct itself:

 var facilityTypes: [Facility] {
     facilities.map(Facility.init)
 }
 We can now drop that facilities view into ResortView by replacing this code:

 Text(resort.facilities, format: .list(type: .and))
     .padding(.vertical)
 With this:

 HStack {
     ForEach(resort.facilityTypes) { facility in
         facility.icon
             .font(.title)
     }
 }
 .padding(.vertical)
 That loops over each item in the facilities array, converting it to an icon and placing it into a HStack. I used the .font(.title) modifier to make the images larger – using the modifier here rather than inside Facility allows us more flexibility if we wanted to use these icons in other places.

 That was the easy part. The harder part comes next: we want to make the facility images into buttons, so that we can show an alert when they are tapped.

 Using the optional form of alert() this starts easily enough – add two new properties to ResortView, one to store the currently selected facility, and one to store whether an alert should currently be shown or not:

 @State private var selectedFacility: Facility?
 @State private var showingFacility = false
 Now replace the previous ForEach loop with this:

 ForEach(resort.facilityTypes) { facility in
     Button {
         selectedFacility = facility
         showingFacility = true
     } label: {
         facility.icon
             .font(.title)
     }
 }
 We can create the alert in a very similar manner as we created the icons – by adding a dictionary to the Facility struct containing all the keys and values we need:

 private let descriptions = [
     "Accommodation": "This resort has popular on-site accommodation.",
     "Beginners": "This resort has lots of ski schools.",
     "Cross-country": "This resort has many cross-country ski routes.",
     "Eco-friendly": "This resort has won an award for environmental friendliness.",
     "Family": "This resort is popular with families."
 ]
 Then reading that inside another computed property:

 var description: String {
     if let message = descriptions[name] {
         return message
     } else {
         fatalError("Unknown facility type: \(name)")
     }
 }
 So far this hasn’t been tricky, but now comes the complex part. You see, the selectedFacility property is optional, so we need to handle it carefully:

 We can’t use it as the only title for our alert, because we must provide a non-optional string. We can fix that with nil coalescing.
 We always want to make sure the alert reads from our optional selectedFacility, so it passes in the unwrapped value from there.
 We don’t need any buttons in this alert, so we can let the system provide a default OK button.
 We need to provide an alert message based on the unwrapped facility data, calling the new message(for:) method we just wrote.
 Putting all that together, add this modifier below navigationBarTitleDisplayMode() in ResortView:

 .alert(selectedFacility?.name ?? "More information", isPresented: $showingFacility, presenting: selectedFacility) { _ in
 } message: { facility in
     Text(facility.description)
 }
 Notice how we’re using _ in for the alert’s action closure because we don’t actually care about getting the unwrapped Facility instance there, but it is important in the message closure so we can display the correct description.
 */

/* Letting the user mark favorites
 The final task for this project is to let the user assign favorites to resorts they like. This is mostly straightforward, using techniques we’ve already covered:

 Creating a new Favorites class that has a Set of resort IDs the user likes.
 Giving it add(), remove(), and contains() methods that manipulate the data, sending update notifications to SwiftUI while also saving any changes to UserDefaults.
 Injecting an instance of the Favorites class into the environment.
 Adding some new UI to call the appropriate methods.
 Swift’s sets already contain methods for adding, removing, and checking for an element, but we’re going to add our own around them so we can use objectWillChange to notify SwiftUI that changes occurred, and also call a save() method so the user’s changes are persisted. This in turn means we can mark the favorites set using private access control, so we can’t accidentally bypass our methods and miss out saving.

 Create a new Swift file called Favorites.swift, replace its Foundation import with SwiftUI, then give it this code:

 class Favorites: ObservableObject {
     // the actual resorts the user has favorited
     private var resorts: Set<String>

     // the key we're using to read/write in UserDefaults
     private let saveKey = "Favorites"

     init() {
         // load our saved data

         // still here? Use an empty array
         resorts = []
     }

     // returns true if our set contains this resort
     func contains(_ resort: Resort) -> Bool {
         resorts.contains(resort.id)
     }

     // adds the resort to our set, updates all views, and saves the change
     func add(_ resort: Resort) {
         objectWillChange.send()
         resorts.insert(resort.id)
         save()
     }

     // removes the resort from our set, updates all views, and saves the change
     func remove(_ resort: Resort) {
         objectWillChange.send()
         resorts.remove(resort.id)
         save()
     }

     func save() {
         // write out our data
     }
 }
 You’ll notice I’ve missed out the actual functionality for loading and saving favorites – that will be your job to fill in shortly.

 We need to create a Favorites instance in ContentView and inject it into the environment so all views can share it. So, add this new property to ContentView:

 @StateObject var favorites = Favorites()
 Now inject it into the environment by adding this modifier to the NavigationView:

 .environmentObject(favorites)
 Because that’s attached to the navigation view, every view the navigation view presents will also gain that Favorites instance to work with. So, we can load it from inside ResortView by adding this new property:

 @EnvironmentObject var favorites: Favorites
 Tip: Make sure you modify your ResortView preview to inject an example Favorites object into the environment, so your SwiftUI preview carries on working. This will work fine: .environmentObject(Favorites()).

 All this work hasn’t really accomplished much yet – sure, the Favorites class gets loaded when the app starts, but it isn’t actually used anywhere despite having properties to store it.

 This is easy enough to fix: we’re going to add a button at the end of the scrollview in ResortView so that users can either add or remove the resort from their favorites, then display a heart icon in ContentView for favorite resorts.

 First, add this to the end of the scrollview in ResortView:

 Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
     if favorites.contains(resort) {
         favorites.remove(resort)
     } else {
         favorites.add(resort)
     }
 }
 .buttonStyle(.borderedProminent)
 .padding()
 Now we can show a colored heart icon next to favorite resorts in ContentView by adding this to the end of the label for our NavigationLink:

 if favorites.contains(resort) {
     Spacer()
     Image(systemName: "heart.fill")
     .accessibilityLabel("This is a favorite resort")
         .foregroundColor(.red)
 }
 Tip: As you can see, the foregroundColor() modifier works great here because our image uses SF Symbols.

 That mostly works, but you might notice a glitch: if you favorite resorts with longer names you might find their name wraps onto two lines even though there’s space for it to be all on one.

 This happens because we’ve made an assumption in our code, and it’s coming back to bite us: we were passing an Image and a VStack into the label for our NavigationLink, which SwiftUI was smart enough to arrange neatly for us, but as soon as we added a third view it wasn’t sure how to respond.

 To fix this, we need to tell SwiftUI explicitly that the content of our NavigationLink is a plain old HStack, so it will size everything appropriately. So, wrap the entire contents of the NavigationLink label – everything from the Image down to the new condition wrapping the heart icon – inside a HStack to fix the problem.

 That should make the text layout correctly even with the spacer and heart icon – much better. And that also finishes our project, so give it one last try and see what you think. Good job!
 */
