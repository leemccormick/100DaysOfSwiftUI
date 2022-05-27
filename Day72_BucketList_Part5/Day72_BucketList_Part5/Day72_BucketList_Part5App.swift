//
//  Day72_BucketList_Part5App.swift
//  Day72_BucketList_Part5
//
//  Created by Lee McCormick on 5/22/22.
//

import SwiftUI

@main
struct Day72_BucketList_Part5App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 14, part 5
 Today is the last day of coding for this project, and I’m sure you’re looking forward to the challenges and review tomorrow – it should make a nice change from such a long tutorial.

 First, though, we need to cover off two tricky topics, one of which will really challenge you because we’ll remodel our code to use the MVVM design pattern. As you’ll see, this helps separate logic from layout in our projects, but it takes a bit of thinking too – not least because you need to understand the concept of the main actor.

 While you’re working through today, chances are you’re really starting to feel the difficulty curve ramp up, because our projects are growing and size and complexity. I want to take this opportunity to remind you of a few things:

 You’re not alone; everyone is having to go through this same learning curve.
 It’s a marathon, not a sprint; take your time and it will come.
 It’s OK to take a break and come at a topic again later; having fresh eyes will help.
 There is no learning without struggle; if you’re fighting to learn something, it will stick way better at the end.
 There’s a quote widely attributed to Confucius that you would do well to remember: “it doesn’t matter how slowly you go, as long as you don’t stop.”

 Today you have two topics to work through, in which you’ll learn how to write data to disk securely, and how to enable biometric authentication.

 - Introducing MVVM into your SwiftUI project
 - Locking our UI behind Face ID
 That’s another app done – make sure and share your progress with the world!
 */

/*
 - Introducing MVVM into your SwiftUI project
 - Locking our UI behind Face ID
 */

/* Introducing MVVM into your SwiftUI project
 So far I’ve introduced you to a range of concepts across Swift and SwiftUI, and I’ve also dropped a few tips on ways to organize your code better. Well, here I want to explore that latter part a bit further: we’re going to look at what is commonly called a software architecture, or the more grandiose name an architectural design pattern – really it’s just a particular way of structuring your code.

 The pattern we’re going to look at is called MVVM, which is an acronym standing for Model View View-Model. This is a terrifically bad name, and thoroughly confuses people, but I’m afraid we’re rather stuck with it at this point. There is no single definition of what is MVVM, and you’ll find all sorts of people arguing about it online, but that’s okay – here we’re going to keep it simple, and use MVVM as a way of getting some of our program state and logic out of our view structs. We are, in effect, separating logic from layout.

 We’ll explore that definition as we go, but for now let’s start with the big stuff: make a new Swift file called ContentView-ViewModel.swift, then give it an extra import for MapKit. We’re going to use this to create a new class that manages our data, and manipulates it on behalf of the ContentView struct so that our view doesn’t really care how the underlying data system works.

 We’re going to start with three trivial things, then build our way up from there. First, create a new class that conforms to the ObservableObject protocol, so we’re able to report changes back to any SwiftUI view that’s watching:

 class ViewModel: ObservableObject {
 }
 Second, I want you to place that new class inside an extension on ContentView, like this:

 extension ContentView {
     class ViewModel: ObservableObject {
     }
 }
 Now we’re saying this isn’t just any view model, it’s the view model for ContentView. Later on it will be your job to add a second view model to handle EditView, so you can try seeing how the concepts map elsewhere.

 The final small change I’d like you to make is to add a new attribute, @MainActor, to the whole class, like this:

 extension ContentView {
     @MainActor class ViewModel: ObservableObject {
     }
 }
 The main actor is responsible for running all user interface updates, and adding that attribute to the class means we want all its code – any time it runs anything, unless we specifically ask otherwise – to run on that main actor. This is important because it’s responsible for making UI updates, and those must happen on the main actor. In practice this isn’t quite so easy, but we’ll come to that later on.

 Now, we’ve used ObservableObject classes before, but didn’t have @MainActor – how come they worked? Well, behind the scenes whenever we use @StateObject or @ObservedObject Swift was silently inferring the @MainActor attribute for us – it knows that both mean a SwiftUI view is relying on an external object to trigger its UI updates, and so it will make sure all the work automatically happens on the main actor without us asking for it.

 However, that doesn’t provide 100% safety. Yes, Swift will infer this when used from a SwiftUI view, but what if you access your class from somewhere else – from another class, for example? Then the code could run anywhere, which isn’t safe. So, by adding the @MainActor attribute here we’re taking a “belt and braces” approach: we’re telling Swift every part of this class should run on the main actor, so it’s safe to update the UI, no matter where it’s used.

 Now that we have our class in place, we get to choose which pieces of state from our view should be moved into the view model. Some people will tell you to move all of it, others will be more selective, and that’s okay – again, there is no single of what MVVM looks like, so I’m going to provide you with the tools and knowledge to experiment yourself.

 Let’s start with the easy stuff: move all three @State properties in ContentView over to its view model, switching @State private for just @Published – they can’t be private any more, because they explicitly need to be shared with ContentView:

 extension ContentView {
     @MainActor class ViewModel: ObservableObject {
         @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
         @Published var locations = [Location]()
         @Published var selectedPlace: Location?
     }
 }
 And now we can replace all those properties in ContentView with a single one:

 @StateObject private var viewModel = ViewModel()
 That will of course break a lot of code, but the fixes are easy – just add viewModel in various places. So, $mapRegion becomes $viewModel.mapRegion, locations becomes viewModel.locations, and so on.

 Once you’ve added that everywhere it’s needed your code will compile again, but you might wonder how this has helped – haven’t we just moved our code from one place to another? Well, yes, but there is an important distinction that will become clearer as your skills grow: having all this functionality in a separate class makes it much easier to write tests for your code.

 Views work best when they handle presentation of data, meaning that manipulation of data is a great candidate for code to move into a view model. With that in mind, if you have a look through your ContentView code you might notice two places our view does more work than it ought to: adding a new location and updating an existing location, both of which root around inside the internal data of our view model.

 Reading data from a view model’s properties is usually fine, but writing it isn’t because the whole point of this exercise is to separate logic from layout. You can find these two places immediately if we clamp down on writing view model data – modify the locations property in your view model to this:

 @Published private(set) var locations = [Location]()
 Now we’ve said that reading locations is fine, but only the class itself can write locations. Immediately Xcode will point out the two places where we need to get code out of the view: adding a new location, and updating an existing one.

 So, we can start by adding a new method to the view model to handle adding a new location:

 func addLocation() {
     let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
     locations.append(newLocation)
 }
 That can then be used from the + button in ContentView:

 Button {
     viewModel.addLocation()
 } label: {
     Image(systemName: "plus")
 }
 The second problematic place is updating a location, so I want you to cut that whole if let index check to your clipboard, then paste it into a new method in the view model, adding in a check that we have a selected place to work with:

 func update(location: Location) {
     guard let selectedPlace = selectedPlace else { return }

     if let index = locations.firstIndex(of: selectedPlace) {
         locations[index] = location
     }
 }
 Make sure and remove the two viewModel references from there – they aren’t needed any more.

 Now the EditView sheet in ContentView can just pass its data onto the view model:

 EditView(location: place) {
     viewModel.update(location: $0)
 }
 At this point the view model has taken over all aspects of ContentView, which is great: the view is there to present data, and the view model is there to manage data. The split isn’t always quite as clean as that, despite what you might hear elsewhere online, and again that’s okay – once you move into more advanced projects you’ll find that “one size fits all” approaches usually fit nobody, so we just do our best with what we have.

 Anyway, in this case now that we have our view model all set up, we can upgrade it to support loading and saving of data. This will look in the documents directory for a particular file, then use either JSONEncoder or JSONDecoder to convert it ready for use.

 Previously I showed you how to find our app’s documents directory with a reusable function, but here we’re going to package it up as an extension on FileManager for easier access in any project.

 Create a new Swift file called FileManager-DocumentsDirectory.swift, then give it this code:

 extension FileManager {
     static var documentsDirectory: URL {
         let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         return paths[0]
     }
 }
 Now we can create a URL to a file in our documents directory wherever we want, however I don’t want to do that when both loading and saving files because it means if we ever change our save location we need to remember to update both places.

 So, a better idea is to add a new property to our view model to store the location we’re saving to:

 let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
 And with that in place we can create a new initializer and a new save() method that makes sure our data is saved automatically. Start by adding this to the view model:

 init() {
     do {
         let data = try Data(contentsOf: savePath)
         locations = try JSONDecoder().decode([Location].self, from: data)
     } catch {
         locations = []
     }
 }
 As for saving, previously I showed you how to write a string to disk, but the Data version is even better because it lets us do something quite amazing in just one line of code: we can ask iOS to ensure the file is written with encryption so that it can only be read once the user has unlocked their device. This is in addition to requesting atomic writes – iOS does almost all the work for us.

 Add this method to the view model now:

 func save() {
     do {
         let data = try JSONEncoder().encode(locations)
         try data.write(to: savePath, options: [.atomic, .completeFileProtection])
     } catch {
         print("Unable to save data.")
     }
 }
 Yes, all it takes to ensure that the file is stored with strong encryption is to add .completeFileProtection to the data writing options.

 Using this approach we can write any amount of data in any number of files – it’s much more flexible than UserDefaults, and also allows us to load and save data as needed rather than immediately when the app launches as with UserDefaults.

 Before we’re done with this step, we need to make a handful of small changes to our view model so that uses the code we just wrote.

 First, the locations array no longer needs to be initialized to an empty array, because that’s handled by the initializer. Change it to this:

 @Published private(set) var locations: [Location]
 And second, we need to call the save() method after adding a new location or after updating an existing one, so add save() to the end of both those methods.

 Go ahead and run the app now, and you should find that you can add items freely, then relaunch the app to see them restored just as they were.

 That took quite a bit of code in total, but the end result is that we have loading and saving done really well:

 - All the logic is handled outside the view, so later on when you learn to write tests you’ll find the view model is much easier to work with.
 - When we write data we’re making iOS encrypt it so the file can’t be read or written until the user unlocks their device.
 - The load and save process is almost transparent – we added one modifier and changed another, and that’s all it took.
 Of course, our app isn’t truly secure yet: we’ve ensured our data file is saved out using encryption so that it can only be read once the device has been unlocked, but there’s nothing stopping someone else from reading the data afterwards.
 */

/* Locking our UI behind Face ID
 To finish off our app, we’re going to make one last important change: we’re going to require the user to authenticate themselves using either Touch ID or Face ID in order to see all the places they have marked on the app. After all, this is their private data and we should be respectful of that, and of course it gives me a chance to let you use an important skill in a practical context!

 First we need some new state in our view model that tracks whether the app is unlocked or not. So, start by adding this new property:

 @Published var isUnlocked = false
 Second, we need to add the Face ID permission request key to our project configuration options, explaining to the user why we want to use Face ID. If you haven’t added this already, go to your target options now, select the Info tab, then right-click on any existing row and add the “Privacy - Face ID Usage Description” key there. You can enter what you like, but “Please authenticate yourself to unlock your places” seems like a good choice.

 Third, we need to add import LocalAuthentication to the top of your view model’s file, so we have access to Apple’s authentication framework.

 And now for the hard part. If you recall, the code for biometric authentication was a teensy bit unpleasant because of its Objective-C roots, so it’s always a good idea to get it far away from the neatness of SwiftUI. So, we’re going to write a dedicated authenticate() method that handles all the biometric work:

 Creating an LAContext so we have something that can check and perform biometric authentication.
 Ask it whether the current device is capable of biometric authentication.
 If it is, start the request and provide a closure to run when it completes.
 When the request finishes, check the result.
 If it was successful, we’ll set isUnlocked to true so we can run our app as normal.
 Add this method to your view model now:

 func authenticate() {
     let context = LAContext()
     var error: NSError?

     if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
         let reason = "Please authenticate yourself to unlock your places."

         context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in

             if success {
                 self.isUnlocked = true
             } else {
                 // error
             }
         }
     } else {
         // no biometrics
     }
 }
 Remember, the string in our code is used for Touch ID, whereas the string in Info.plist is used for Face ID.

 And now we need to make an adjustment that is in reality very small, but can be hard to visualize if you’re reading this rather than watching the video. Everything inside the ZStack needs to be indented in by one level, and have this placed before it:

 if viewModel.isUnlocked {
 Just before the end of the ZStack add this:

 } else {
     // button here
 }
 So, it should look something like this:

 ZStack {
     if viewModel.isUnlocked {
         MapView…
         Circle…
         VStack…
     } else {
         // button here
     }
 }
 .sheet(item: $viewModel.selectedPlace) { place in
 So now we all we need to do is fill in the // button here comment with an actual button that triggers the authenticate() method. You can design whatever you want, but something like this ought to be enough:

 Button("Unlock Places") {
     viewModel.authenticate()
 }
 .padding()
 .background(.blue)
 .foregroundColor(.white)
 .clipShape(Capsule())
 You can now go ahead and run the app again, because our code is almost done. If this is the first time you’ve used Face ID in the simulator you’ll need to go to the Features menu and choose Face ID > Enrolled, but once you relaunch the app you can authenticate using Features > Face ID > Matching Face.

 However, when it runs you might notice a problem: the app will seem to work just fine, but Xcode is likely to show a warning message in its debug output. More importantly, it will also show a purple warning, which is Xcode’s issue of flagging up runtime issues - when our code does something it really ought not to.

 In this instance, it should point at this line in our view model:

 self.isUnlocked = true
 Next to that it should say “publishing changes from background threads is not allowed”, which translated means “you’re trying to change the UI but you’re not doing it from the main actor and that’s going to cause problems.”

 Now, This might be confusing given that earlier on we specifically added the @MainActor attribute to our whole class, which I said means all the code from the class will be run on the main actor and therefore be safe for UI updates. However, I added an important proviso there: “unless we specifically request otherwise.”

 In this instance we did request otherwise, but it might not be obvious: when we asked Face ID to do the work of authenticating the user, this happens outside of our program – it’s not us doing the actual face check, it’s Apple. When that process completes Apple will call our completion closure to say whether it succeeded or not, but that won’t be called on the main actor despite our @MainActor attribute.

 The solution here is to make sure we change the isUnlocked property on the main actor. This can be done by starting a new task, then calling await MainActor.run() inside there, like this:

 if success {
     Task {
         await MainActor.run {
             self.isUnlocked = true
         }
     }
 } else {
     // error
 }
 That effectively means “start a new background task, then immediately use that background task to queue up some work on the main actor.”

 That works, but we can do better: we can tell Swift that our task’s code needs to run directly on the main actor, by giving the closure itself the @MainActor attribute. So, rather than bouncing to a background task then back to the main actor, the new task will immediately start running on the main actor:

 if success {
     Task { @MainActor in
         self.isUnlocked = true
     }
 } else {
     // error
 }
 And with that our code is done, and that’s another app complete – good job!
 */
