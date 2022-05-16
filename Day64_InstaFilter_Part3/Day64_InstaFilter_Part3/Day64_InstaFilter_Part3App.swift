//
//  Day64_InstaFilter_Part3App.swift
//  Day64_InstaFilter_Part3
//
//  Created by Lee McCormick on 5/15/22.
//

import SwiftUI

@main
struct Day64_InstaFilter_Part3App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 13, part 3
 Believe it or not, we still have one more day of techniques for this project before we get into the implementation phase, and I’ve left the hardest stuff to the end.

 Today you’re going to look at some of the complexities around how SwiftUI works with UIKit. If you’ve ever used UIKit before these things won’t be too taxing, but if UIKit is new to you then today might hurt almost as much as when you first met closures in Swift. Yes, really.

 Stick with it! After today we’ll start putting all these concepts into action, so you’re really close to the fun part. Take your inspiration from the postage stamp – as the writer Josh Billings once quipped, “its usefulness consists in the ability to stick to one thing until it gets there.“

 Today you have just two topics to work through, in which you’ll learn about coordinators, delegates, NSObject, @objc, selectors, and other things that go bump in the night.

 - Using coordinators to manage SwiftUI view controllers
 - How to save images to the user’s photo library
 I’d love to hear what you think of these APIs now that you’ve had some time with SwiftUI, whether or not you’ve used UIKit before. Send me a tweet!
 */

/* Using coordinators to manage SwiftUI view controllers
 Previously we looked at how we can use UIViewControllerRepresentable to wrap a UIKit view controller so that it can be used inside SwiftUI, in particular focusing on PHPickerViewController. However, we hit a problem: although we could show the image picker, we weren’t able to respond to the user selecting an image or pressing cancel.

 SwiftUI’s solution to this is called coordinators, which is a bit confusing for folks coming from a UIKit background because there we had a design pattern also called coordinators that performed an entirely different role. To be clear, SwiftUI’s coordinators are nothing like the coordinator pattern many developers used with UIKit, so if you’ve used that pattern previously please jettison it from your brain to avoid confusion!

 SwiftUI’s coordinators are designed to act as delegates for UIKit view controllers. Remember, “delegates” are objects that respond to events that occur elsewhere. For example, UIKit lets us attach a delegate object to its text field view, and that delegate will be notified when the user types anything, when they press return, and so on. This meant that UIKit developers could modify the way their text field behaved without having to create a custom text field type of their own.

 Using coordinators in SwiftUI requires you to learn a little about the way UIKit works, which is no surprise given that we’re literally integrating UIKit’s view controllers. So, to demonstrate this we’re going to upgrade our ImagePicker view so that it can report back when the user selects an image or presses Cancel.

 As a reminder, here’s the code we have right now:

 struct ImagePicker: UIViewControllerRepresentable {
     func makeUIViewController(context: Context) -> PHPickerViewController {
         var config = PHPickerConfiguration()
         config.filter = .images

         let picker = PHPickerViewController(configuration: config)
         return picker
     }

     func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

     }
 }
 We’re going to take it step by step, because there’s a lot to take in here – don’t feel bad if it takes you some time to understand, because coordinators really aren’t easy the first time you encounter them.

 First, add this nested class inside the ImagePicker struct:

 class Coordinator {
 }
 Yes, it needs to be a class as you’ll see in a moment. It doesn’t need to be a nested class, although it’s a good idea because it neatly encapsulates the functionality – without a nested class it would be confusing if you had lots of view controllers and coordinators all mixed up.

 Even though that class is inside a UIViewControllerRepresentable struct, SwiftUI won’t automatically use it for the view’s coordinator. Instead, we need to add a new method called makeCoordinator(), which SwiftUI will automatically call if we implement it. All this needs to do is create and configure an instance of our Coordinator class, then send it back.

 Right now our Coordinator class doesn’t do anything special, so we can just send one back by adding this method to the ImagePicker struct:

 func makeCoordinator() -> Coordinator {
     Coordinator()
 }
 What we’ve done so far is create an ImagePicker struct that knows how to create a PHPickerViewController, and now we just told ImagePicker that it should have a coordinator to handle communication from that PHPickerViewController.

 The next step is to tell the PHPickerViewController that when something happens it should tell our coordinator. This takes just one line of code in makeUIViewController(), so add this directly before the return picker line:

 picker.delegate = context.coordinator
 That code won’t compile, but before we fix it I want to spend just a moment digging in to what just happened.

 We don’t call makeCoordinator() ourselves; SwiftUI calls it automatically when an instance of ImagePicker is created. Even better, SwiftUI automatically associated the coordinator it created with our ImagePicker struct, which means when it calls makeUIViewController() and updateUIViewController() it will automatically pass that coordinator object to us.

 So, the line of code we just wrote tells Swift to use the coordinator that just got made as the delegate for the PHPickerViewController. This means any time something happens inside the photo picker controller – i.e., when the user selects an image or presses Cancel – it will report that action to our coordinator.

 The reason our code doesn’t compile is that Swift is checking that our coordinator class is capable of acting as a delegate for PHPickerViewController, finding that it isn’t, and so is refusing to build our code any further. To fix this we need to modify our Coordinator class from this:

 class Coordinator {
 To this:

 class Coordinator: NSObject, PHPickerViewControllerDelegate {
 That does three things:

 It makes the class inherit from NSObject, which is the parent class for almost everything in UIKit. NSObject allows Objective-C to ask the object what functionality it supports at runtime, which means the photo picker can say things like “hey, the user selected an image, what do you want to do?”
 It makes the class conform to the PHPickerViewControllerDelegate protocol, which is what adds functionality for detecting when the user selects an image. (NSObject lets Objective-C check for the functionality; this protocol is what actually provides it.)
 It stops our code from compiling, because we’ve said that class conforms to PHPickerViewControllerDelegate but we haven’t implemented the one method required by that protocol.
 Still, at least now you can see why we needed to use a class for Coordinator: we need to inherit from NSObject so that Objective-C can query our coordinator to see what functionality it supports.

 At this point we have an ImagePicker struct that wraps a PHPickerViewController, and we’ve configured that image picker controller to talk to our Coordinator class when something interesting happens.

 The last step is to implement the one required method of the PHPickerViewControllerDelegate protocol, which will be called when the user has finished making their selection. That might mean we have an image, or that the user pressed cancel, so we need to respond appropriately.

 If we put UIKit to one side for a second and think in pure functionality, what we want is for our ImagePicker to report back that image to whatever used the picker in the first place. We’re presenting ImagePicker inside a sheet in our ContentView struct, so we want that to be given whatever image was selected, then dismiss the sheet.

 What we need here is SwiftUI’s @Binding property wrapper, which allows us to create a binding from ImagePicker up to whatever created it. This means we can set the binding value in our image picker and have it actually update a value being stored somewhere else – in ContentView, for example.

 So, add this property to ImagePicker:

 @Binding var image: UIImage?
 Now, we just added that property to ImagePicker, but we need to access it inside our Coordinator class because that’s the one that will be informed when an image was selected.

 Rather than just pass the data down one level, a better idea is to tell the coordinator what its parent is, so it can modify values there directly. That means adding an ImagePicker property and associated initializer to the Coordinator class, like this:

 var parent: ImagePicker

 init(_ parent: ImagePicker) {
     self.parent = parent
 }
 And now we can modify makeCoordinator() so that it passes the ImagePicker struct into the coordinator, like this:

 func makeCoordinator() -> Coordinator {
     Coordinator(self)
 }
 At this point your entire ImagePicker struct should look like this:

 struct ImagePicker: UIViewControllerRepresentable {
     class Coordinator: NSObject, PHPickerViewControllerDelegate {
         var parent: ImagePicker

         init(_ parent: ImagePicker) {
             self.parent = parent
         }
     }

     @Binding var image: UIImage?

     func makeUIViewController(context: Context) -> PHPickerViewController {
         var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
         config.filter = .images

         let picker = PHPickerViewController(configuration: config)
         picker.delegate = context.coordinator
         return picker
     }

     func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

     }

     func makeCoordinator() -> Coordinator {
         Coordinator(self)
     }
 }
 At long last we’re ready to actually read the response from our PHPickerViewController, which is done by implementing a method with a very specific name. Swift will look for this method in our Coordinator class, as it’s the delegate of the image picker, so make sure and add it there.

 The method name is long and needs to be exactly right in order for UIKit to find it, but helpfully Xcode can help us out with autocomplete. So, click on the red hexagon on the error line, then click “Fix” to add this method stub:

 func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
     code
 }
 That method receives two objects we care about: the picker view controller that the user was interacting with, plus an array of the users selections because it’s possible to let the user select multiple images at once.

 It’s our job to do three things:

 Tell the picker to dismiss itself.
 Exit if the user made no selection – if they tapped Cancel.
 Otherwise, see if the user’s results includes a UIImage we can actually load, and if so place it into the parent.image property.
 So, replace the “code” placeholder with this:

 // Tell the picker to go away
 picker.dismiss(animated: true)

 // Exit if no selection was made
 guard let provider = results.first?.itemProvider else { return }

 // If this has an image we can use, use it
 if provider.canLoadObject(ofClass: UIImage.self) {
     provider.loadObject(ofClass: UIImage.self) { image, _ in
         self.parent.image = image as? UIImage
     }
 }
 Notice how we need the typecast for UIImage – that’s because the data we’re provided could in theory be anything. Yes, I know we specifically asked for photos, but PHPickerViewControllerDelegate calls this same method for any kind of media, which is why we need to be careful.

 At this point I bet you’re really missing the beautiful simplicity of SwiftUI, so you’ll be glad to know that we’re finally done with the ImagePicker struct – it does everything we need now.

 So, at last we can return to ContentView.swift. Here’s how we left it from earlier:

 struct ContentView: View {
     @State private var image: Image?
     @State private var showingImagePicker = false

     var body: some View {
         VStack {
             image?
                 .resizable()
                 .scaledToFit()

             Button("Select Image") {
                 showingImagePicker = true
             }
         }
         .sheet(isPresented: $showingImagePicker) {
             ImagePicker()
         }
     }
 }
 To integrate our ImagePicker view into that we need to start by adding another @State image property that can be passed into the picker:

 @State private var inputImage: UIImage?
 We can now change our sheet() modifier to pass that property into our image picker, so it will be updated when the image is selected:

 ImagePicker(image: $inputImage)
 Next, we need a method we can call when that property changes. Remember, we can’t use a plain property observer here because Swift will ignore changes to the binding, so instead we’ll write a method that checks whether inputImage has a value, and if it does uses it to assign a new Image view to the image property.

 Add this method to ContentView now:

 func loadImage() {
     guard let inputImage = inputImage else { return }
     image = Image(uiImage: inputImage)
 }
 And now we can use an onChange() modifier to call loadImage() whenever a new image is chosen – put this below the sheet() modifier:

 .onChange(of: inputImage) { _ in loadImage() }
 And we’re done! Go ahead and run the app and try it out – you should be able to tap the button, browse through your photo library, and select a picture. When that happens the photo picker should disappear, and your selected image will be shown below.

 I realize at this point you’re probably sick of UIKit and coordinators, but before we move on I want to sum up the complete process:

 We created a SwiftUI view that conforms to UIViewControllerRepresentable.
 We gave it a makeUIViewController() method that created some sort of UIViewController, which in our example was a PHPickerViewController.
 We added a nested Coordinator class to act as a bridge between the UIKit view controller and our SwiftUI view.
 We gave that coordinator a didFinishPicking method, which will be triggered by iOS when an image was selected.
 Finally, we gave our ImagePicker an @Binding property so that it can send changes back to a parent view.
 For what it’s worth, after you’ve used coordinators once, the second and subsequent times are easier, but I wouldn’t blame you if you found the whole system quite baffling for now.

 Don’t worry too much – we’ll be coming back to this again soon, so you’ll have more than enough time to practice. It also means you shouldn’t delete your ImagePicker.swift file, because that’s another useful component you’ll use in this project and in others you make.
 */

/* How to save images to the user’s photo library
 Before we’re done with the techniques for this project, there’s one last piece of UIKit joy we need to tackle: once we’ve processed the user’s image we’ll get a UIImage back, but we need a way to save that processed image to the user’s photo library. This uses a UIKit function called UIImageWriteToSavedPhotosAlbum(), which in its simplest form is trivial to use, but in order to make it work usefully you need to wade back into UIKit. At the very least it will make you really appreciate how much better SwiftUI is!

 Before we write any code, we need to do something new: we need to add a configuration option for our project. Every project we build has a whole bunch of these baked right in, describing which interface orientations we support, the version number of our app, and other fixed pieces of data. This isn’t code: these options must all be declared ahead of time, in a separate file, so the system can read them without having to run our app.

 These options all live in a particular place in Xcode, and it’s bizarrely hard to find unless you know what you’re doing:

 In the Project Navigator, select the top item in the tree. It will have your project name, Instafilter.
 You’ll see Instafilter listed under both PROJECT and TARGETS. Please select it under TARGETS.
 Now you’ll see a bunch of tabs across the top, including General, Signing & Capabilities, and more – select Info from there.
 This is where you can add a whole range of configuration options for your project, but right now there’s one specific option we need. You see, writing to the photo library is a protected operation, which means we can’t do it without explicit permission from the user. iOS will take care of asking for permission and checking the response, but we need to provide a short string explaining to users why we want to write images in the first place.

 To add your permission string, right-click on any of the existing options then choose Add Row. You’ll see a dropdown list of options to choose from – I’d like you to scroll down and select “Privacy - Photo Library Additions Usage Description”. For the value on its right, please enter the text “We want to save the filtered photo.”

 With that done, we can now use the UIImageWriteToSavedPhotosAlbum() method to write out a picture. We already have this loadImage() method from our previous work:

 func loadImage() {
     guard let inputImage = inputImage else { return }
     image = Image(uiImage: inputImage)
 }
 We could modify that so it immediately saves the image that got loaded, effectively creating a duplicate. Add this line to the end of the method:

 UIImageWriteToSavedPhotosAlbum(inputImage, nil, nil, nil)
 And that’s it – every time you import an image, our app will save it back to the photo library. The first time you try it, iOS will automatically prompt the user for permission to write the photo and show the string we added to the configuration options.

 Now, you might look at that and think “that was easy!” And you’d be right. But the reason it’s easy is because we did the least possible work: we provided the image to save as the first parameter to UIImageWriteToSavedPhotosAlbum(), then provided nil as the other three.

 Those nil parameters matter, or at least the first two do: they tell Swift what method should be called when saving completes, which in turn will tell us whether the save operation succeeded or failed. If you don’t care about that then you’re done – passing nil for all three is fine. But remember: users can deny access to their photo library, so if you don’t catch the save error they’ll wonder why your app isn’t working properly.

 The reason it takes UIKit two parameters to know which function to call is because this code is old – way older than Swift, and in fact so old it even pre-dates Objective-C’s equivalent of closures. So instead, this uses a completely different way of referring to functions: in place of the first nil we should point to an object, and in place of the second nil we should point to the name of the method that should be called.

 If that sounds bad, I’m afraid you only know half the story. You see, both of those two parameters have their own complexities:

 The object we provide must be a class, and it must inherit from NSObject. This means we can’t point to a SwiftUI view struct.
 The method is provided as a method name, not an actual method. This method name was used by Objective-C to find the actual code at runtime, which could then be run. That method needs to have a specific signature (list of parameters) otherwise our code just won’t work.
 But wait: there’s more! For performance reasons, Swift prefers not to generate code in a way that Objective-C can read – that whole “look up methods at runtime” thing was really neat, but also really slow. And so, when it comes to writing the method name we need to do two things:

 Mark the method using a special compiler directive called #selector, which asks Swift to make sure the method name exists where we say it does.
 Add an attribute called @objc to the method, which tells Swift to generate code that can be read by Objective-C.
 You know, I wrote UIKit code for over a decade before I switched to SwiftUI, and already writing out all this explanation makes this old API seem like a crime against humanity. Sadly it is what it is, and we’re stuck with it.

 Before I show you the code, I want to mention the fourth parameter. So, the first one is the image to save, the second one is an object that should be notified about the result of the save, the third one is the method on the object that should be run, and then there’s the fourth one. We aren’t going to be using it here, but you need to be aware of what it does: we can provide any sort of data here, and it will be passed back to us when our completion method is called.

 This is what UIKit calls “context”, and it helps you identify one image save operation from another. You can provide literally anything you want here, so UIKit uses the most hands-off type you can imagine: a raw chunk of memory that Swift makes no guarantees about whatsoever. This has its own special type name in Swift: UnsafeRawPointer. Honestly, if it weren’t for the fact that we had to use it here I simply wouldn’t even tell you it existed, because it’s not really useful at this point in your app development career.

 Anyway, that’s more than enough talk. Before you decide to throw this project away and go straight to the next one, let’s get this over and done with.

 As I’ve said, to write an image to the photo library and read the response, we need some sort of class that inherits from NSObject. Inside there we need a method with a precise signature that’s marked with @objc, and we can then call that from UIImageWriteToSavedPhotosAlbum().

 Putting all that together, please create a new Swift file called ImageSaver.swift, change its Foundation import for SwiftUI, then give it this code:

 class ImageSaver: NSObject {
     func writeToPhotoAlbum(image: UIImage) {
         UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
     }

     @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
         print("Save finished!")
     }
 }
 With that in place we can now use it from ContentView, like this:

 Button("Save Image") {
     guard let inputImage = inputImage else { return }

     let imageSaver = ImageSaver()
     imageSaver.writeToPhotoAlbum(image: inputImage)
 }
 If you run the code now, you should see the “Save finished!” message output as soon as you select an image, but you’ll also see the system prompt you for permission to write to the photo library.

 Yes, that is remarkably little code given how much explanation it needed, but on the bright side that completes the overview for this project so at long (long, long!) last we can get into the actual implementation.

 Please go ahead and put your project back to its default state so we have a clean slate to work from, but I’d like you to keep ImagePicker and ImageSaver – both of those will be used later in this project, and they are also useful in other projects you might create in the future.
 */
