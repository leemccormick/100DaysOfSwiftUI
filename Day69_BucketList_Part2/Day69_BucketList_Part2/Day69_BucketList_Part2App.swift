//
//  Day69_BucketList_Part2App.swift
//  Day69_BucketList_Part2
//
//  Created by Lee McCormick on 5/20/22.
//

import SwiftUI

@main
struct Day69_BucketList_Part2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 14, part 2
 In the second part of our technique overview for this project, we’re going to look at two really important frameworks on iOS: MapKit for rendering maps in our app, and LocalAuthentication for using Touch ID and Face ID.
 
 It won’t surprise you to learn that location, fingerprints, and facial recognition are really personal to users, which means we need to treat them with respect at all times. Remember, users trust us to treat their data with the utmost care and intention at all times, so it’s a good thing to get into the mindset that privacy, security, and trust are your core values rather than optional extras.
 
 Elvis Presley is reputed to have once said, “values are like fingerprints: nobody’s are the same, but you leave them all over the things you touch.” Well, this project is at the center of the Venn diagram of both values and fingerprints, so stay sharp – this stuff matters.
 
 Today you have two topics to work through, in which you’ll learn how embed maps into a SwiftUI app, how to use Face ID to unlock your app, and more.
 
 - Integrating MapKit with SwiftUI
 - Using Touch ID and Face ID with SwiftUI
 
 Make sure and tell the world about your progress – you’re making some real steps forward.
 */

/* Integrating MapKit with SwiftUI
 Maps have been a core feature of iPhone since the very first device shipped way back in 2007, and the underlying framework has been available to developers for almost as long. Even better, Apple provides a SwiftUI Map view that wraps up the underlying map framework beautifully, letting us place maps, annotations, and more alongside the rest of our SwiftUI view hierarchy.
 
 Let’s start with something simple: showing a map means creating some program state that stores the map’s current center coordinate and zoom level, which is handled through a dedicated type called MKCoordinateRegion. The “MK” in that name means this come from Apple’s MapKit framework, so our first step is to import that framework:
 
 import MapKit
 Now we can make a property such as this one:
 
 @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
 That centers on the city of London. Both sets of latitude and longitude are measured in degrees, but in practice longitude changes in its underlying value as you move further away from the equator so it might take a little experimentation to find a starting value you like.
 
 Finally, we can add a map view like this:
 
 Map(coordinateRegion: $mapRegion)
 That has a two-way binding to the region so it can be updated as the user moves around the map, and when the app runs you should see London right there on your map.
 
 There are a variety of extra options we can use when creating maps, but by far the most important is the ability to add annotations to the map – markers that represent various places of our choosing.
 
 To do this takes at least three steps depending on your goal: defining a new data type that contains your location, creating an array of those containing all your locations, then adding them as annotations in the map. Whatever new data type you create to store locations, it must conform to the Identifiable protocol so that SwiftUI can identify each map marker uniquely.
 
 For example, we might start with this kind of Location struct:
 
 struct Location: Identifiable {
 let id = UUID()
 let name: String
 let coordinate: CLLocationCoordinate2D
 }
 Now we can go ahead and define an array of locations, wherever we want map annotations to appear:
 
 let locations = [
 Location(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
 Location(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
 ]
 Step three is the important part: we can feed that array of locations into the Map view, as well as providing a function that transforms one location into a visible annotation on the map. SwiftUI provides us with a couple of different annotation types, but the simplest is MapMarker: a simple balloon with a latitude/longitude coordinate attached.
 
 For example, we could place markers at both our locations like so:
 
 Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
 MapMarker(coordinate: location.coordinate)
 }
 When that runs you’ll see two red balloons on the map, although they don’t show any useful information – our locations don’t have their name visible, for example. To add that extra information we need to create a wholly custom view using a different annotation type, helpfully just called MapAnnotation. This accepts the same coordinate as MapMarker, except rather than just showing a system-style balloon we instead get to pass in whatever custom SwiftUI views we want.
 
 So, we could replace the balloons with stroked red circles like this:
 
 Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
 MapAnnotation(coordinate: location.coordinate) {
 Circle()
 .stroke(.red, lineWidth: 3)
 .frame(width: 44, height: 44)
 }
 }
 Once you’re using MapAnnotation you can pass in any SwiftUI views you want – it’s a great customization point, and can include any interactivity you want.
 
 For example, we could add a tap gesture to our annotations like this:
 
 MapAnnotation(coordinate: location.coordinate) {
 Circle()
 .stroke(.red, lineWidth: 3)
 .frame(width: 44, height: 44)
 .onTapGesture {
 print("Tapped on \(location.name)")
 }
 }
 We could even place a NavigationLink into our map annotation, directing the user to a different view when the annotation was tapped:
 
 NavigationView {
 Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
 MapAnnotation(coordinate: location.coordinate) {
 NavigationLink {
 Text(location.name)
 } label: {
 Circle()
 .stroke(.red, lineWidth: 3)
 .frame(width: 44, height: 44)
 }
 }
 }
 .navigationTitle("London Explorer")
 }
 The point is that you get to decide whether you want something simple or something more advanced, then add any interactivity using all the SwiftUI tools and techniques you already know.
 */

/* Using Touch ID and Face ID with SwiftUI
 The vast majority of Apple’s devices come with biometric authentication as standard, which means they use fingerprint and facial recognition to unlock. This functionality is available to us too, which means we can make sure that sensitive data can only be read when unlocked by a valid user.
 
 This is another Objective-C API, but it’s only a little bit unpleasant to use with SwiftUI, which is better than we’ve had with some other frameworks we’ve looked at so far.
 
 Before we write any code, you need to add a new key to your project options, explaining to the user why you want access to Face ID. For reasons known only to Apple, we pass the Touch ID request reason in code, and the Face ID request reason in project options.
 
 So, select your current target, go to the Info tab, right-click on an existing key, then choose Add Row. Scroll through the list of keys until you find “Privacy - Face ID Usage Description” and give it the value “We need to unlock your data.”
 
 Now head back to ContentView.swift, and add this import near the top of the file:
 
 import LocalAuthentication
 And with that, we’re all set to write some biometrics code.
 
 I mentioned earlier this was “only a little bit unpleasant”, and here’s where it comes in: Swift developers use the Error protocol for representing errors that occur at runtime, but Objective-C uses a special class called NSError. We need to be able to pass that into the function and have it changed inside the function rather than returning a new value – although this was the standard in Objective-C, it’s quite an alien way of working in Swift so we need to mark this behavior specially by using &.
 
 We’re going to write an authenticate() method that isolates all the biometric functionality in a single place. To make that happen requires four steps:
 
 Create instance of LAContext, which allows us to query biometric status and perform the authentication check.
 Ask that context whether it’s capable of performing biometric authentication – this is important because iPod touch has neither Touch ID nor Face ID.
 If biometrics are possible, then we kick off the actual request for authentication, passing in a closure to run when authentication completes.
 When the user has either been authenticated or not, our completion closure will be called and tell us whether it worked or not, and if not what the error was.
 Please go ahead and add this method to ContentView:
 
 func authenticate() {
 let context = LAContext()
 var error: NSError?
 
 // check whether biometric authentication is possible
 if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
 // it's possible, so go ahead and use it
 let reason = "We need to unlock your data."
 
 context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
 // authentication has now completed
 if success {
 // authenticated successfully
 } else {
 // there was a problem
 }
 }
 } else {
 // no biometrics
 }
 }
 That method by itself won’t do anything, because it’s not connected to SwiftUI at all. To fix that we need to add some state we can adjust when authentication is successful, and also an onAppear() modifier to trigger authentication.
 
 So, first add this property to ContentView:
 
 @State private var isUnlocked = false
 That simple Boolean will store whether the app is showing its protected data or not, so we’ll flip that to true when authentication succeeds. Replace the // authenticated successfully comment with this:
 
 isUnlocked = true
 Finally, we can show the current authentication state and begin the authentication process inside the body property, like this:
 
 VStack {
 if isUnlocked {
 Text("Unlocked")
 } else {
 Text("Locked")
 }
 }
 .onAppear(perform: authenticate)
 If you run the app there’s a good chance you just see “Locked” and nothing else. This is because the simulator isn’t opted in to biometrics by default, and we didn’t provide any error messages, so it fails silently.
 
 To take Face ID for a test drive, go to the Features menu and choose Face ID > Enrolled, then launch the app again. This time you should see the Face ID prompt appear, and you can trigger successful or failed authentication by going back to the Features menu and choosing Face ID > Matching Face or Non-matching Face.
 
 All being well you should see the Face ID prompt go away, and underneath it will be the “Unlocked” text view – our app has detected the authentication, and is now open to use.
 
 Important: When working with biometric authentication, you should always look for a backup plan that lets users authenticate without biometrics. Think about folks who might be wearing a face mask, or perhaps are wearing gloves right now – if you try to force them to use biometrics all the time you’ll just have angry users. So, consider adding a screen that prompts for a passcode, then provide that as a fallback if biometrics fail.
 */
