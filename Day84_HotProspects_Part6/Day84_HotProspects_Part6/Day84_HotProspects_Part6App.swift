//
//  Day84_HotProspects_Part6App.swift
//  Day84_HotProspects_Part6
//
//  Created by Lee McCormick on 7/6/22.
//

import SwiftUI

@main
struct Day84_HotProspects_Part6App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 16, part 6
 This has been a long project with lots to learn, but today marks the last of the code. As the American professor Angela Duckworth said, “enthusiasm is common; endurance is rare” – it took enthusiasm to start day 1 of this series, but here you are on day 84 just finishing a huge project, so it’s clear you’ve got great endurance as well.

 This project has already drawn upon some important SwiftUI features such as tab bars, swipe actions, and the environment; some important Swift features such as filter(), Result, and advanced access control; and even some important iOS features such as Core Image and scanning codes with the camera. Today we’re going to add the icing on the cake, which is loading and saving data using UserDefaults, adding a context menu, and showing alerts using the UserNotification framework.

 This is what great apps look like: they lean on a variety of language and system features to build great user experiences that go beyond what SwiftUI can do by itself. Yes, SwiftUI is an awesome way to build apps, but it’s only the beginning – iOS is capable of so much more, and as much as it sounds like a cliche the only limit to what you can make is your imagination.

 Today you have three topics to work through, in which you’ll load and save data with UserDefaults, add a context menu to save our QR code, then show local notifications using the UserNotifications framework.

 - Saving and loading data with UserDefaults
 - Adding a context menu to an image
 - Posting notifications to the lock screen
 
 That’s another app complete – don’t forget to share your progress with others!
 */

/* Saving and loading data with UserDefaults
 This app mostly works, but it has one fatal flaw: any data we add gets wiped out when the app is relaunched, which doesn’t make it much use for remembering who we met. We can fix this by making the Prospects initializer able to load data from UserDefaults, then write it back when the data changes.

 This time our data is stored using a slightly easier format: although the Prospects class uses the @Published property wrapper, the people array inside it is simple enough that it already conforms to Codable just by adding the protocol conformance. So, we can get most of the way to our goal by making three small changes:

 Updating the Prospects initializer so that it loads its data from UserDefaults where possible.
 Adding a save() method to the same class, writing the current data to UserDefaults.
 Calling save() when adding a prospect or toggling its isContacted property.
 We’ve looked at the code to do all that previously, so let’s get to it. We already have a simple initializer for Prospects, so we can update it to use UserDefaults like this:

 init() {
     if let data = UserDefaults.standard.data(forKey: "SavedData") {
         if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
             people = decoded
             return
         }
     }

     people = []
 }
 As for the save() method, this will do the same thing in reverse – add this:

 func save() {
     if let encoded = try? JSONEncoder().encode(people) {
         UserDefaults.standard.set(encoded, forKey: "SavedData")
     }
 }
 Our data is changed in two places, so we need to make both of those call save() to make sure the data is always written out.

 The first is in the toggle() method of Prospects, so modify it to this:

 func toggle(_ prospect: Prospect) {
     objectWillChange.send()
     prospect.isContacted.toggle()
     save()
 }
 The second is in the handleScan(result:) method of ProspectsView, where we add new prospects to the array. Find this line:

 prospects.people.append(person)
 And add this directly below:

 prospects.save()
 If you run the app now you’ll see that any contacts you add will remain there even after you relaunch the app, so we could easily stop here. However, this time I want to go a stage further and fix two other problems:

 We’ve had to hard-code the key name “SavedData” in two places, which again might cause problems in the future if the name changes or needs to be used in more places.
 Having to call save() inside ProspectsView isn’t good design, partly because our view really shouldn’t know about the internal workings of its model, but also because if we have other views working with the data then we might forget to call save() there.
 To fix the first problem we should create a property on Prospects to contain our save key, so we use that property rather than a string for UserDefaults.

 Add this to the Prospects class:

 let saveKey = "SavedData"
 We can then use that rather than a hard-coded string, first by modifying the initializer like this:

 if let data = UserDefaults.standard.data(forKey: saveKey) {
 And by modifying the save() method to this:

 UserDefaults.standard.set(encoded, forKey: saveKey)
 This approach is much safer in the long term – it’s far too easy to write “SaveKey” or “savedKey” by accident, and in doing so introduce all sorts of bugs.

 As for the problem of calling save(), this is actually a deeper problem: when we write code like prospects.people.append(person) we’re breaking a software engineering principle known as encapsulation. This is the idea that we should limit how much external objects can read and write values inside a class or a struct, and instead provide methods for reading (getters) and writing (setters) that data.

 In practical terms, this means rather than writing prospects.people.append(person) we’d instead create an add() method on the Prospects class, so we could write code like this: prospects.add(person). The result would be the same – our code adds a person to the people array – but now the implementation is hidden away. This means that we could switch the array out to something else and ProspectsView wouldn’t break, but it also means we can add extra functionality to the add() method.

 So, to solve the second problem we’re going to create an add() method in Prospects so that we can internally trigger save(). Add this now:

 func add(_ prospect: Prospect) {
     people.append(prospect)
     save()
 }
 Even better, we can use access control to stop external writes to the people array, meaning that our views must use the add() method to add prospects. This is done by changing the definition of the people property to this:

 @Published private(set) var people: [Prospect]
 Now that only code inside Prospects calls the save() method, we can mark that as being private too:

 private func save() {
 This helps lock down our code so that we can’t make mistakes by accident – the compiler simply won’t allow it. In fact, if you try building the code now you’ll see exactly what I mean: ProspectsView tries to append to the people array and call save(), which is no longer allowed.

 To fix that error and get our code compiling cleanly again, replace those two lines with this:

 prospects.add(person)
 Switching away from strings then using encapsulation and access control are simple ways of making our code safer, and are some great steps towards building better software.
 */

/* Adding a context menu to an image
 We’ve already written code that dynamically generates a QR code based on the user’s name and email address, but with a little extra code we can also let the user save that QR code to their images.

 Start by opening MeView.swift, and adding the contextMenu() modifier to the QR code image, like this:

 Image(uiImage: generateQRCode(from: "\(name)\n\(emailAddress)"))
     .interpolation(.none)
     .resizable()
     .scaledToFit()
     .frame(width: 200, height: 200)
     .contextMenu {
         Button {
             // save my code
         } label: {
             Label("Save to Photos", systemImage: "square.and.arrow.down")
         }
     }
 In terms of saving the image, we can use the same ImageSaver class we used back in project 13 (Instafilter), because that takes care of all the complex work for us. If you have ImageSaver.swift around from the previous project you can just drag it into your new project now, but if not here’s the code again:

 import UIKit

 class ImageSaver: NSObject {
     var successHandler: (() -> Void)?
     var errorHandler: ((Error) -> Void)?

     func writeToPhotoAlbum(image: UIImage) {
         UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
     }

     @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
         if let error = error {
             errorHandler?(error)
         } else {
             successHandler?()
         }
     }
 }
 When it comes to using that we can just repeat the same code to generate our UIImage, then save that – replace the // save my code comment with this:

 let image = generateQRCode(from: "\(name)\n\(emailAddress)")
 let imageSaver = ImageSaver()
 imageSaver.writeToPhotoAlbum(image: image)
 And we’re done!

 We could save a little work by caching the generated QR code, however a more important side effect of that is that we wouldn’t have to pass in the name and email address each time – duplicating that data means if we change one copy in the future we need to change the other too.

 To add this change, first add a new @State property that will store the code we generate:

 @State private var qrCode = UIImage()
 Now modify generateQRCode() so that it quietly stores the new code in our cache before sending it back:

 if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
     qrCode = UIImage(cgImage: cgimg)
     return qrCode
 }
 And now our context menu button can use the cached code:

 Button {
     let imageSaver = ImageSaver()
     imageSaver.writeToPhotoAlbum(image: qrCode)
 } label: {
     Label("Save to Photos", systemImage: "square.and.arrow.down")
 }
 That code will compile cleanly, but I want you to run it and see what happens.

 If everything has gone to plan, Xcode should show a purple warning over your code, saying that we modified our view’s state during a view update, which causes undefined behavior. “Undefined behavior” is a fancy way of saying “this could behave in any number of weird ways, so don’t do it.”

 You see, we’re telling Swift it can load our image by calling the generateQRCode() method, so when SwiftUI calls the body property it will run generateQRCode() as requested. However, while it’s running that method, we then change our new @State property, even though SwiftUI hasn’t actually finished updating the body property yet.

 This is A Very Bad Idea, which is why Xcode is flagging up a large warning. Think about it: if drawing the QR code changes our @State cache property, that will cause body to loaded again, which will cause the QR code to be drawn again, which will change our cache property again, and so on – it’s really messy.

 The smart thing to do here is tell our image to render directly from the cached qrImage property, then call generateQRCode() when the view appears and whenever either name or email address changes.

 First, add this new method to MeView, so we can update our code from several places without having to repeat the exact string:

 func updateCode() {
     qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
 }
 Second, revert the qrCode = UIImage(cgImage: cgimg) line in generateQRCode(), because that’s no longer needed – you can just return the UIImage directly, like before.

 Third, change the QR code image to this:

 Image(uiImage: qrCode)
 Finally, add these new modifiers after navigationTitle():

 .onAppear(perform: updateCode)
 .onChange(of: name) { _ in updateCode() }
 .onChange(of: emailAddress) { _ in updateCode() }
 That will ensure the QR code is updated as soon as the view is shown, or whenever name or emailAddress get changed – perfect for our needs, and much safer than trying to change some state while SwiftUI is updating our view.

 Before you try the context menu yourself, make sure you add the same project option we had for the Instafilter project – you need to add a permission request string to your project’s configuration options.

 In case you’ve forgotten how to do that, here are the steps you need:

 Open your target settings
 Select the Info tab
 Right-click on an existing option
 Choose Add Row
 Select “Privacy - Photo Library Additions Usage Description” for the key name.
 Enter “We want to save your QR code.” as the value.
 And now this step is done – you should be able to run the app, switch to the Me tab, then long press the QR code to bring up your new context menu.
 */

/* Posting notifications to the lock screen
 For the final part of our app, we’re going to add another button to our list swipe actions, letting users opt to be reminded to contact a particular person. This will use iOS’s UserNotifications framework to create a local notification, and we’ll conditionally include it in the swipe actions as part of our existing if check – the button will only be shown if the user hasn’t been contacted already.

 Much more interesting is how we schedule the local notifications. Remember, the first time we try this we need to use requestAuthorization() to explicitly ask for permission to show a notification on the lock screen, but we also need to be careful subsequent times because the user can retroactively change their mind and disable notifications.

 One option is to call requestAuthorization() every time we want to post a notification, and honestly that works great: the first time it will show an alert, and all other times it will immediately return success or failure based on the previous response.

 However, in the interests of completion I want to show you a more powerful alternative: we can request the current authorization settings, and use that to determine whether we should schedule a notification or request permission. The reason it’s helpful to use this approach rather than just requesting permission repeatedly, is that the settings object handed back to us includes properties such as alertSetting to check whether we can show an alert or not – the user might have restricted this so all we can do is display a numbered badge on our icon.

 So, we’re going to call getNotificationSettings() to read whether notifications are currently allowed. If they are, we’ll show a notification. If they aren’t, we’ll request permissions, and if that comes back successfully then we’ll also show a notification. Rather than repeat the code to schedule a notification, we’ll put it inside a closure that can be called in either scenario.

 Start by adding this import near the top of ProspectsView.swift:

 import UserNotifications
 Now add this method to the ProspectsView struct:

 func addNotification(for prospect: Prospect) {
     let center = UNUserNotificationCenter.current()

     let addRequest = {
         let content = UNMutableNotificationContent()
         content.title = "Contact \(prospect.name)"
         content.subtitle = prospect.emailAddress
         content.sound = UNNotificationSound.default

         var dateComponents = DateComponents()
         dateComponents.hour = 9
         let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

         let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
         center.add(request)
     }

     // more code to come
 }
 That puts all the code to create a notification for the current prospect into a closure, which we can call whenever we need. Notice that I’ve used UNCalendarNotificationTrigger for the trigger, which lets us specify a custom DateComponents instance. I set it to have an hour component of 9, which means it will trigger the next time 9am comes about.

 Tip: For testing purposes, I recommend you comment out that trigger code and replace it with the following, which shows the alert five seconds from now:

 let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
 For the second part of that method we’re going to use both getNotificationSettings() and requestAuthorization() together, to make sure we only schedule notifications when allowed. This will use the addRequest closure we defined above, because the same code can be used if we have permission already or if we ask and have been granted permission.

 Replace the // more code to come comment with this:

 center.getNotificationSettings { settings in
     if settings.authorizationStatus == .authorized {
         addRequest()
     } else {
         center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
             if success {
                 addRequest()
             } else {
                 print("D'oh")
             }
         }
     }
 }
 That’s all the code we need to schedule a notification for a particular prospect, so all that remains is to add an extra button to our swipe actions – add this below the “Mark Contacted” button:

 Button {
     addNotification(for: prospect)
 } label: {
     Label("Remind Me", systemImage: "bell")
 }
 .tint(.orange)
 That completes the current step, and completes our project too – try running it now and you should find that you can add new prospects, then press and hold to either mark them as contacted, or to schedule a contact reminder.

 Good job!
 */
