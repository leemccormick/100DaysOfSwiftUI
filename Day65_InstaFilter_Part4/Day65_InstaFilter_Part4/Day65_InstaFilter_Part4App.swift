//
//  Day65_InstaFilter_Part4App.swift
//  Day65_InstaFilter_Part4
//
//  Created by Lee McCormick on 5/16/22.
//

import SwiftUI

@main
struct Day65_InstaFilter_Part4App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/*
 Project 13, part 4
 Today we’re going to be putting into practice some of the techniques you just learned, including how to create custom bindings, how to wrap PHPickerViewController for use inside SwiftUI, and how to apply Core Filter effects to an image.

 One thing I hope you notice is how I frequently lead you back to a topic we looked at previously. This isn’t an accident: as the self-help author Napoleon Hill wrote, “any idea, plan, or purpose may be placed in the mind through repetition of thought” – this repetition is one of several approaches I use to help you internalize how all this code fits together.

 And even if you don’t fully get these concepts today, that’s OK – we’ll be covering them again the future.

 Today you have three topics to work through, in which you’ll put into practice wrapping a UIViewController for use with SwiftUI, filtering images using Core Image, and more.

 - Building our basic UI
 - Importing an image into SwiftUI using PHPickerViewController
 - Basic image filtering using Core Image
 */

/* Building our basic UI
 The first step in our project is to build the basic user interface, which for this app will be:

 A NavigationView so we can show our app’s name at the top.
 A large gray box saying “Tap to select a picture”, over which we’ll place their imported picture.
 An “Intensity” slider that will affect how strongly we apply our Core Image filters, stored as a value from 0.0 to 1.0.
 A “Save” button to write out the modified image to the user’s photo library.
 Initially the user won’t have selected an image, so we’ll represent that using an @State optional image property.

 First add these two properties to ContentView:

 @State private var image: Image?
 @State private var filterIntensity = 0.5
 Now modify the contents of its body property to this:

 NavigationView {
     VStack {
         ZStack {
             Rectangle()
                 .fill(.secondary)

             Text("Tap to select a picture")
                 .foregroundColor(.white)
                 .font(.headline)

             image?
                 .resizable()
                 .scaledToFit()
         }
         .onTapGesture {
             // select an image
         }

         HStack {
             Text("Intensity")
             Slider(value: $filterIntensity)
         }
         .padding(.vertical)

         HStack {
             Button("Change Filter") {
                 // change filter
             }

             Spacer()

             Button("Save") {
                 // save the picture
             }
         }
     }
     .padding([.horizontal, .bottom])
     .navigationTitle("Instafilter")
 }
 I love being able to place optional views right inside a SwiftUI layout, and I think it works particularly well with ZStack because the text below our picture will automatically be obscured when a picture has been loaded by the user.

 Now, as our code was fairly easy here, I want to just briefly explore what it looks like to clean up our body property a little – we have lots of layout code in there, but as you can see we also have a couple of button closures in there too.

 For very small pieces of code I’m usually happy enough to have button actions specified as closures, but that Save button is going to have quite a few lines in there when we’re done so I would suggest spinning it out into its own function.

 Right now that just means adding an empty save() method to ContentView, like this:

 func save() {
 }
 We would then call that from the button like so:

 Button("Save", action: save)
 When you’re learning it’s very common to write button actions and similar directly inside your views, but once you get onto real projects it’s a good idea to spend extra time keeping your code cleaned up – it makes your life easier in the long term, trust me!

 I’ll be adding more little cleanup tips like this going forward, so as you start to approach the end of the course you feel increasingly confident that your code is in good shape.
 */

/* Importing an image into SwiftUI using PHPickerViewController
 In order to bring this project to life, we need to let the user select a photo from their library, then display it in ContentView. I’ve already shown you how this all works, so if you followed the introductory chapters you’ll already have most of the code you need.

 If you missed those chapters, it’s not too late: create a new Swift file called ImagePicker.swift, then replace its code with this:

 import PhotosUI
 import SwiftUI

 struct ImagePicker: UIViewControllerRepresentable {
     @Binding var image: UIImage?

     func makeUIViewController(context: Context) -> PHPickerViewController {
         var config = PHPickerConfiguration()
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

     class Coordinator: NSObject, PHPickerViewControllerDelegate {
         let parent: ImagePicker

         init(_ parent: ImagePicker) {
             self.parent = parent
         }

         func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
             picker.dismiss(animated: true)

             guard let provider = results.first?.itemProvider else { return }

             if provider.canLoadObject(ofClass: UIImage.self) {
                 provider.loadObject(ofClass: UIImage.self) { image, _ in
                     self.parent.image = image as? UIImage
                 }
             }
         }
     }
 }
 That’s all code we’ve looked at before, so I’m not going to re-explain what it all does. Instead, I want to head back to ContentView.swift so we can make use of it.

 First we need an @State Boolean to track whether our image picker is being shown or not, so start by adding this to ContentView:

 @State private var showingImagePicker = false
 Second, we need to set that Boolean to true when the big gray rectangle is tapped, so replace the // select an image comment with this:

 showingImagePicker = true
 Third, we need a property that will store the image the user selected. We gave the ImagePicker struct an @Binding property attached to a UIImage, which means when we create the image picker we need to pass in a UIImage for it to link to. When the @Binding property changes, the external value changes as well, which lets us read the value.

 So, add this property to ContentView:

 @State private var inputImage: UIImage?
 Fourth, we need a method that will be called when the ImagePicker view has been dismissed. For now this will just place the selected image directly into the UI, so please add this method to ContentView now:

 func loadImage() {
     guard let inputImage = inputImage else { return }
     image = Image(uiImage: inputImage)
 }
 We can then call that whenever our inputImage value changes, by attaching an onChange() modifier somewhere in ContentView – it really doesn’t matter where, but after navigationTitle() would seem sensible.

 .onChange(of: inputImage) { _ in loadImage() }
 And finally, we need to add a sheet() modifier somewhere in ContentView. This will use showingImagePicker as its condition, and present an ImagePicker bound to inputImage as its contents.

 So, add this directly below the existing navigationTitle() modifier:

 .sheet(isPresented: $showingImagePicker) {
     ImagePicker(image: $inputImage)
 }
 That completes all the steps required to wrap a UIKit view controller for use inside SwiftUI. We went over it a little faster this time but hopefully it still all made sense!

 Go ahead and run the app again, and you should be able to tap the gray rectangle to import a picture, and when you’ve found one it will appear inside our UI.

 Tip: The ImagePicker view we just made is completely reusable – you can put that Swift file to one side and use it on other projects easily. If you think about it, all the complexity of wrapping the view is contained inside ImagePicker.swift, which means if you do choose to use it elsewhere it’s just a matter of showing a sheet and binding an image.
 */

/* Basic image filtering using Core Image
 Now that our project has an image the user selected, the next step is to let the user apply varying Core Image filters to it. To start with we’re just going to work with a single filter, but shortly we’ll extend that using a confirmation dialog.

 If we want to use Core Image in our apps, we first need to add two imports to the top of ContentView.swift:

 import CoreImage
 import CoreImage.CIFilterBuiltins
 Next we need both a context and a filter. A Core Image context is an object that’s responsible for rendering a CIImage to a CGImage, or in more practical terms an object for converting the recipe for an image into an actual series of pixels we can work with.

 Contexts are expensive to create, so if you intend to render many images it’s a good idea to create a context once and keep it alive. As for the filter, we’ll be using CIFilter.sepiaTone() as our default but because we’ll make it flexible later we’ll make the filter use @State so it can be changed.

 So, add these two properties to ContentView:

 @State private var currentFilter = CIFilter.sepiaTone()
 let context = CIContext()
 With those two in place we can now write a method that will process whatever image was imported – that means it will set our sepia filter’s intensity based on the value in filterIntensity, read the output image back from the filter, ask our CIContext to render it, then place the result into our image property so it’s visible on-screen.

 func applyProcessing() {
     currentFilter.intensity = Float(filterIntensity)

     guard let outputImage = currentFilter.outputImage else { return }

     if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
         let uiImage = UIImage(cgImage: cgimg)
         image = Image(uiImage: uiImage)
     }
 }
 Tip: Sadly the Core Image behind the sepia tone filter wants Float rather than Double for its values. This makes Core Image feel even older, I know, but don’t worry – we’ll make it go away soon!

 The next job is to change the way loadImage() works. Right now that assigns to the image property, but we don’t want that any more. Instead, it should send whatever image was chosen into the sepia tone filter, then call applyProcessing() to make the magic happen.

 Core Image filters have a dedicated inputImage property that lets us send in a CIImage for the filter to work with, but often this is thoroughly broken and will cause your app to crash – it’s much safer to use the filter’s setValue() method with the key kCIInputImageKey.

 So, replace your existing loadImage() method with this:

 func loadImage() {
     guard let inputImage = inputImage else { return }

     let beginImage = CIImage(image: inputImage)
     currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
     applyProcessing()
 }
 If you run the code now you’ll see our basic app flow works great: we can select an image, then see it with a sepia effect applied. But that intensity slider we added doesn’t do anything, even though it’s bound to the same filterIntensity value that our filter is reading from.

 What’s happening here ought not to be too surprising: even though the slider is changing the value of filterIntensity, changing that property won’t automatically trigger our applyProcessing() method again. Instead, we need to do that by hand by telling SwiftUI to watch filterIntensity with onChange().

 Again, these onChange() modifiers can go anywhere in our SwiftUI view hierarchy, but in this situation I do something different: when one specific view is responsible for changing a value I usually add onChange() directly to that view so it’s clear to me later on that adjusting the view triggers a side effect. If multiple views adjust the same value, or if it’s not quite so specific what is changing the value, then I’d add the modifier at the end of the view.

 Anyway, here filterIntensity is being changed by the slider, so let’s add onChange() there:

 Slider(value: $filterIntensity)
     .onChange(of: filterIntensity) { _ in
         applyProcessing()
     }
 You can go ahead and run the app now, but be warned: even though Core Image is extremely fast on all iPhones, it’s usually extremely slow in the simulator. That means you can try it out to make sure everything works, but don’t be surprised if your code runs about as fast as an asthmatic ant carrying a heavy bag of shopping.
 */
