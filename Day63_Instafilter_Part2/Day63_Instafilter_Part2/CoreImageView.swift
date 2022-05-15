//
//  CoreImageView.swift
//  Day63_Instafilter_Part2
//
//  Created by Lee McCormick on 5/14/22.
//

import CoreImage
import CoreImage.CIFilterBuiltins // Both of these data types come from Core Image, so you’ll need to add two imports to make them available to us. So please start by adding these near the top of ContentView.swift
import SwiftUI

struct CoreImageView: View {
    
    @State private var imageSepiaTone: Image?
    @State private var imagePixellate: Image?
    @State private var imageCrystallize: Image?
    @State private var imageTwirlDistortion: Image?
    
    var body: some View {
        ScrollView {
            VStack {
                Text("CIFilterBuiltins : SepiaTone")
                    .bold()
                imageSepiaTone?
                    .resizable()
                    .scaledToFit()
            }
            VStack {
                Text("CIFilterBuiltins : Pixellate")
                    .bold()
                imagePixellate?
                    .resizable()
                    .scaledToFit()
            }
            VStack {
                Text("CIFilterBuiltins : Crystallize")
                    .bold()
                imageCrystallize?
                    .resizable()
                    .scaledToFit()
            }
            VStack {
                Text("CIFilterBuiltins : TwirlDistortion?")
                    .bold()
                imageTwirlDistortion?
                    .resizable()
                    .scaledToFit()
            }
        }
        .onAppear(perform: loadImage)
        .navigationTitle("Integrating Core Image with SwiftUI")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func loadImage() {
        // image = Image("Example")
        guard let inputImage = UIImage(named: "Example") else {return}
        let beginImage = CIImage(image: inputImage)
        let context = CIContext()
        
        let currentFilterSepiaTone = CIFilter.sepiaTone() // We can now customize our filter to change the way it works. Sepia is a simple filter, so it only has two interesting properties: inputImage is the image we want to change, and intensity is how strongly the sepia effect should be applied, specified in the range 0 (original image) and 1 (full sepia).
        currentFilterSepiaTone.inputImage = beginImage
        currentFilterSepiaTone.intensity = 1
        
        let currentFilterPixellate = CIFilter.pixellate()
        currentFilterPixellate.inputImage = beginImage
        currentFilterPixellate.scale = 100 // When that runs you’ll see our image looks pixellated. A scale of 100 should mean the pixels are 100 points across, but because my image is so big the pixels are relatively small.
        
        let currentFilterCrystallize = CIFilter.crystallize()
        currentFilterCrystallize.inputImage = beginImage
        currentFilterCrystallize.radius = 200
        
        let currentFilterTwirlDistortion = CIFilter.twirlDistortion()
        currentFilterTwirlDistortion.inputImage = beginImage
        currentFilterTwirlDistortion.radius = 1000
        currentFilterTwirlDistortion.center = CGPoint(x: inputImage.size.width / 2, y: inputImage.size.height / 2)
        
        // With that in place, you can now change the twirl distortion to any other filter and the code will carry on working – each of the adjustment values are sent in only if they are supported.
        let amount = 1.0
        let inputKeys = currentFilterTwirlDistortion.inputKeys
        // Notice how that relies on setting values for keys, which might remind you of the way UserDefaults works. In fact, all those kCIInput keys are all implemented as strings behind the scenes, so it’s even more similar than you might have realized!
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilterTwirlDistortion.setValue(amount, forKeyPath: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilterTwirlDistortion.setValue(amount * 200, forKeyPath: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilterTwirlDistortion.setValue(amount * 10, forKeyPath: kCIInputImageKey)
        }
        /*
         None of this is terribly hard, but here’s where that changes: we need to convert the output from our filter to a SwiftUI Image that we can display in our view. This is where we need to lean on all four image types at once, because the easiest thing to do is:
         
         - Read the output image from our filter, which will be a CIImage. This might fail, so it returns an optional.
         - Ask our context to create a CGImage from that output image. This also might fail, so again it returns an optional.
         - Convert that CGImage into a UIImage.
         - Convert that UIImage into a SwiftUI Image.
         */
        
        guard let outputImage = currentFilterSepiaTone.outputImage else {return} // get a CIImage from our filter or exit if that fails
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) { // attempt to get a CGImage from our CIImage
            let uiImage = UIImage(cgImage: cgimg) // convert that to a UIImage
            imageSepiaTone = Image(uiImage: uiImage) // and convert that to a SwiftUI image
        }
        
        guard let outputImage = currentFilterPixellate.outputImage else {return} // get a CIImage from our filter or exit if that fails
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) { // attempt to get a CGImage from our CIImage
            let uiImage = UIImage(cgImage: cgimg) // convert that to a UIImage
            imagePixellate = Image(uiImage: uiImage) // and convert that to a SwiftUI image
        }
        
        guard let outputImage = currentFilterCrystallize.outputImage else {return} // get a CIImage from our filter or exit if that fails
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) { // attempt to get a CGImage from our CIImage
            let uiImage = UIImage(cgImage: cgimg) // convert that to a UIImage
            imageCrystallize = Image(uiImage: uiImage) // and convert that to a SwiftUI image
        }
        guard let outputImage = currentFilterTwirlDistortion.outputImage else {return} // get a CIImage from our filter or exit if that fails
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) { // attempt to get a CGImage from our CIImage
            let uiImage = UIImage(cgImage: cgimg) // convert that to a UIImage
            imageTwirlDistortion = Image(uiImage: uiImage) // and convert that to a SwiftUI image
        }
    }
}

struct CoreImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoreImageView()
    }
}


/*
 Apart from SwiftUI’s Image view, the three other image types are:
 
 1) UIImage, which comes from UIKit. This is an extremely powerful image type capable of working with a variety of image types, including bitmaps (like PNG), vectors (like SVG), and even sequences that form an animation. UIImage is the standard image type for UIKit, and of the three it’s closest to SwiftUI’s Image type.
 2) CGImage, which comes from Core Graphics. This is a simpler image type that is really just a two-dimensional array of pixels.
 3) CIImage, which comes from Core Image. This stores all the information required to produce an image but doesn’t actually turn that into pixels unless it’s asked to. Apple calls CIImage “an image recipe” rather than an actual image.
 There is some interoperability between the various image types:
 
 - We can create a UIImage from a CGImage, and create a CGImage from a UIImage.
 - We can create a CIImage from a UIImage and from a CGImage, and can create a CGImage from a CIImage.
 - We can create a SwiftUI Image from both a UIImage and a CGImage.
 
 */
