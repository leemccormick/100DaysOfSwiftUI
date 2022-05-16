//
//  SaveImageView.swift
//  Day64_InstaFilter_Part3
//
//  Created by Lee McCormick on 5/15/22.
//

import SwiftUI

struct SaveImageView: View {
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
            Button("Select Image") {
                showingImagePicker = true
            }
            Button("Save Image") {
                guard let inputImage = inputImage else { return }
                   let imageSaver = ImageSaver()
                   imageSaver.writeToPhotoAlbum(image: inputImage)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
        .onChange(of: inputImage) { _ in loadImage() }
        .navigationTitle("How to save images to the user’s photo library")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        UIImageWriteToSavedPhotosAlbum(inputImage, nil, nil, nil) // Before I show you the code, I want to mention the fourth parameter. So, the first one is the image to save, the second one is an object that should be notified about the result of the save, the third one is the method on the object that should be run, and then there’s the fourth one. We aren’t going to be using it here, but you need to be aware of what it does: we can provide any sort of data here, and it will be passed back to us when our completion method is called. This is what UIKit calls “context”, and it helps you identify one image save operation from another. You can provide literally anything you want here, so UIKit uses the most hands-off type you can imagine: a raw chunk of memory that Swift makes no guarantees about whatsoever. This has its own special type name in Swift: UnsafeRawPointer. Honestly, if it weren’t for the fact that we had to use it here I simply wouldn’t even tell you it existed, because it’s not really useful at this point in your app development career.
        
        /*
         Those nil parameters matter, or at least the first two do: they tell Swift what method should be called when saving completes, which in turn will tell us whether the save operation succeeded or failed. If you don’t care about that then you’re done – passing nil for all three is fine. But remember: users can deny access to their photo library, so if you don’t catch the save error they’ll wonder why your app isn’t working properly.

         The reason it takes UIKit two parameters to know which function to call is because this code is old – way older than Swift, and in fact so old it even pre-dates Objective-C’s equivalent of closures. So instead, this uses a completely different way of referring to functions: in place of the first nil we should point to an object, and in place of the second nil we should point to the name of the method that should be called.

         If that sounds bad, I’m afraid you only know half the story. You see, both of those two parameters have their own complexities:

         - The object we provide must be a class, and it must inherit from NSObject. This means we can’t point to a SwiftUI view struct.
         - The method is provided as a method name, not an actual method. This method name was used by Objective-C to find the actual code at runtime, which could then be run. That method needs to have a specific signature (list of parameters) otherwise our code just won’t work.
         But wait: there’s more! For performance reasons, Swift prefers not to generate code in a way that Objective-C can read – that whole “look up methods at runtime” thing was really neat, but also really slow. And so, when it comes to writing the method name we need to do two things:

         1) Mark the method using a special compiler directive called #selector, which asks Swift to make sure the method name exists where we say it does.
         2) Add an attribute called @objc to the method, which tells Swift to generate code that can be read by Objective-C.
         */
    }
}

struct SaveImageView_Previews: PreviewProvider {
    static var previews: some View {
        SaveImageView()
    }
}




