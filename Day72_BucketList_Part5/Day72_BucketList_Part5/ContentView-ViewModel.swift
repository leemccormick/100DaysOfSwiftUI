//
//  ContentView-ViewModel.swift
//  Day72_BucketList_Part5
//
//  Created by Lee McCormick on 5/23/22.
//

import Foundation
import LocalAuthentication // Third, we need to add import LocalAuthentication to the top of your view model’s file, so we have access to Apple’s authentication framework. ==> Second, we need to add the Face ID permission request key to our project configuration options, explaining to the user why we want to use Face ID. If you haven’t added this already, go to your target options now, select the Info tab, then right-click on any existing row and add the “Privacy - Face ID Usage Description” key there. You can enter what you like, but “Please authenticate yourself to unlock your places” seems like a good choice.
import MapKit

/*
 The pattern we’re going to look at is called MVVM, which is an acronym standing for Model View View-Model. This is a terrifically bad name, and thoroughly confuses people, but I’m afraid we’re rather stuck with it at this point. There is no single definition of what is MVVM, and you’ll find all sorts of people arguing about it online, but that’s okay – here we’re going to keep it simple, and use MVVM as a way of getting some of our program state and logic out of our view structs. We are, in effect, separating logic from layout.
 
 We’ll explore that definition as we go, but for now let’s start with the big stuff: make a new Swift file called ContentView-ViewModel.swift, then give it an extra import for MapKit. We’re going to use this to create a new class that manages our data, and manipulates it on behalf of the ContentView struct so that our view doesn’t really care how the underlying data system works.
 
 We’re going to start with three trivial things, then build our way up from there. First, create a new class that conforms to the ObservableObject protocol, so we’re able to report changes back to any SwiftUI view that’s watching:
 */

extension ContentView {
    /* The final small change I’d like you to make is to add a new attribute, @MainActor, to the whole class, like this:
     Now, we’ve used ObservableObject classes before, but didn’t have @MainActor – how come they worked? Well, behind the scenes whenever we use @StateObject or @ObservedObject Swift was silently inferring the @MainActor attribute for us – it knows that both mean a SwiftUI view is relying on an external object to trigger its UI updates, and so it will make sure all the work automatically happens on the main actor without us asking for it.
     
     However, that doesn’t provide 100% safety. Yes, Swift will infer this when used from a SwiftUI view, but what if you access your class from somewhere else – from another class, for example? Then the code could run anywhere, which isn’t safe. So, by adding the @MainActor attribute here we’re taking a “belt and braces” approach: we’re telling Swift every part of this class should run on the main actor, so it’s safe to update the UI, no matter where it’s used.
     */
    @MainActor class ViewModel: ObservableObject {
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        @Published private(set) var locations: [Location] // Reading data from a view model’s properties is usually fine, but writing it isn’t because the whole point of this exercise is to separate logic from layout. You can find these two places immediately if we clamp down on writing view model data – modify the locations property in your view model to this:
        @Published var selectedPlace: Location?
        @Published var isUnlocked = false  // First we need some new state in our view model that tracks whether the app is unlocked or not. So, start by adding this new property:
        
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces") // So, a better idea is to add a new property to our view model to store the location we’re saving to:
        
        // And with that in place we can create a new initializer and a new save() method that makes sure our data is saved automatically. Start by adding this to the view model:
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        // Now we’ve said that reading locations is fine, but only the class itself can write locations. Immediately Xcode will point out the two places where we need to get code out of the view: adding a new location, and updating an existing one. So, we can start by adding a new method to the view model to handle adding a new location:
        func addLocation() {
            let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            locations.append(newLocation)
            save()
        }
        
        // The second problematic place is updating a location, so I want you to cut that whole if let index check to your clipboard, then paste it into a new method in the view model, adding in a check that we have a selected place to work with:
        func update(location: Location) {
            guard let selectedPlace = selectedPlace else { return }
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        /*
         And now for the hard part. If you recall, the code for biometric authentication was a teensy bit unpleasant because of its Objective-C roots, so it’s always a good idea to get it far away from the neatness of SwiftUI. So, we’re going to write a dedicated authenticate() method that handles all the biometric work:
         
         1) Creating an LAContext so we have something that can check and perform biometric authentication.
         2) Ask it whether the current device is capable of biometric authentication.
         3) If it is, start the request and provide a closure to run when it completes.
         4) When the request finishes, check the result.
         5) If it was successful, we’ll set isUnlocked to true so we can run our app as normal.
         */
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success { // That works, but we can do better: we can tell Swift that our task’s code needs to run directly on the main actor, by giving the closure itself the @MainActor attribute. So, rather than bouncing to a background task then back to the main actor, the new task will immediately start running on the main actor:
                        Task { @MainActor in
                            self.isUnlocked = true
                        }
                        /* That effectively means “start a new background task, then immediately use that background task to queue up some work on the main actor.”
                         Task {
                         await MainActor.run {
                         self.isUnlocked = true
                         }
                         }
                         */
                    } else {
                        // error
                    }
                }
            } else {
                // no biometrics
            }
        }
    }
}

/*
 That took quite a bit of code in total, but the end result is that we have loading and saving done really well:
 
 - All the logic is handled outside the view, so later on when you learn to write tests you’ll find the view model is much easier to work with.
 - When we write data we’re making iOS encrypt it so the file can’t be read or written until the user unlocks their device.
 - The load and save process is almost transparent – we added one modifier and changed another, and that’s all it took.
 */
