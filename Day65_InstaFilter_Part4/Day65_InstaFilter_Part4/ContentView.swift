//
//  ContentView.swift
//  Day65_InstaFilter_Part4
//
//  Created by Lee McCormick on 5/16/22.
//

import CoreImage
import CoreImage.CIFilterBuiltins // Now that our project has an image the user selected, the next step is to let the user apply varying Core Image filters to it. To start with we’re just going to work with a single filter, but shortly we’ll extend that using a confirmation dialog.
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage? //  we need a property that will store the image the user selected. We gave the ImagePicker struct an @Binding property attached to a UIImage, which means when we create the image picker we need to pass in a UIImage for it to link to. When the @Binding property changes, the external value changes as well, which lets us read the value.
    @State private var currentFilter = CIFilter.sepiaTone()
    let context = CIContext() // Contexts are expensive to create, so if you intend to render many images it’s a good idea to create a context once and keep it alive. As for the filter, we’ll be using CIFilter.sepiaTone() as our default but because we’ll make it flexible later we’ll make the filter use @State so it can be changed.
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)
                    Text("Tap To Select Picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                    // Selete an image
                    showingImagePicker = true
                }
                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity) { _ in
                            applyProcessing()
                        }
                }
                .padding(.vertical)
                HStack{
                    Button("Change Filter") {
                        // Change filter
                    }
                    Spacer()
                    Button("Save", action: save)
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Day65 Instafilter Part4")
            .sheet(isPresented: $showingImagePicker) { // we need to add a sheet() modifier somewhere in ContentView. This will use showingImagePicker as its condition, and present an ImagePicker bound to inputImage as its contents.
                ImagePicker(image: $inputImage)
            }
            .onChange(of: inputImage) { _ in loadImage() } // We can then call that whenever our inputImage value changes, by attaching an onChange() modifier somewhere in ContentView – it really doesn’t matter where, but after navigationTitle() would seem sensible.
        }
    }
    func save() {
        print("Going to save image...")
    }
    
    func loadImage() { // we need a method that will be called when the ImagePicker view has been dismissed. For now this will just place the selected image directly into the UI, so please add this method to ContentView now:
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        
        // The next job is to change the way loadImage() works. Right now that assigns to the image property, but we don’t want that any more. Instead, it should send whatever image was chosen into the sepia tone filter, then call applyProcessing() to make the magic happen. Core Image filters have a dedicated inputImage property that lets us send in a CIImage for the filter to work with, but often this is thoroughly broken and will cause your app to crash – it’s much safer to use the filter’s setValue() method with the key kCIInputImageKey.
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKeyPath: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() { // With those two in place we can now write a method that will process whatever image was imported – that means it will set our sepia filter’s intensity based on the value in filterIntensity, read the output image back from the filter, ask our CIContext to render it, then place the result into our image property so it’s visible on-screen.
        currentFilter.intensity = Float(filterIntensity)
        guard let outputImage = currentFilter.outputImage else { return }
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            image = Image(uiImage: uiImage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*
 The first step in our project is to build the basic user interface, which for this app will be:
 
 1) A NavigationView so we can show our app’s name at the top.
 2) A large gray box saying “Tap to select a picture”, over which we’ll place their imported picture.
 3) An “Intensity” slider that will affect how strongly we apply our Core Image filters, stored as a value from 0.0 to 1.0.
 4) A “Save” button to write out the modified image to the user’s photo library.
 */
