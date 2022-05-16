//
//  ContentView.swift
//  Day66_InstaFilter_Part5
//
//  Created by Lee McCormick on 5/16/22.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage : UIImage? // You can actually go straight from a CGImage to a SwiftUI Image view, and previously I said we’re going via UIImage because the CGImage equivalent requires some extra parameters. That’s all true, but there’s an important second reason that now becomes important: we need a UIImage to send to our ImageSaver class, and this is the perfect place to create it.
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone() // So, again, CIFilter.sepiaTone() returns a CIFilter object that conforms to the CISepiaTone protocol. Adding that explicit type annotation means we’re throwing away some data: we’re saying that the filter must be a CIFilter but doesn’t have to conform to CISepiaTone any more.
    let context = CIContext()
    @State private var showingFilterSheet = false
    
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
                HStack {
                    Button("Change Filter") {
                    showingFilterSheet = true
                    }
                    Spacer()
                    Button("Save", action: saveImage)
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Day 66 : InstaFilter Part5")
            .onChange(of: inputImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
                // dialog here..
                // I picked out those from the vast range of Core Image filters, but you’re welcome to try using code completion to try something else – type CIFilter. and see what comes up!
                Button("Crystallize") { setFilter(CIFilter.crystallize())}
                Button("Edges") { setFilter(CIFilter.edges())}
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur())}
                Button("Pixellate") { setFilter(CIFilter.pixellate())}
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone())}
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask())}
                Button("Vignette") { setFilter(CIFilter.vignette())}
                Button("Cancel", role: .cancel) { }
            }
           
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else {return}
        image = Image(uiImage: inputImage)
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKeyPath: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
       // currentFilter.intensity = Float(filterIntensity) ==> As a result of this change we lose access to the intensity property, which means this code won’t work any more
        // Instead, we need to replace that with a call to setValue(:_forKey:). This is all the protocol was doing anyway, but it did provide valuable extra type safety. Replace that broken line of code with this
        let inputKeys = currentFilter.inputKeys
        /*
         To fix this – and also to make our single slider do much more work – we’re going to add some more code that reads all the valid keys we can use with setValue(_:forKey:), and only sets the intensity key if it’s supported by the current filter. Using this approach we can actually query as many keys as we want, and set all the ones that are supported. So, for sepia tone this will set intensity, but for Gaussian blur it will set the radius (size of the blur), and so on.

         This conditional approach will work with any filters you choose to apply, which means you can experiment with others safely. The only thing you need be careful with is to make sure you scale up filterIntensity by a number that makes sense – a 1-pixel blur is pretty much invisible, for example, so I’m going to multiply that by 200 to make it more pronounced.
         */
        if inputKeys.contains(kCIInputIntensityKey) {
        currentFilter.setValue(filterIntensity, forKeyPath: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
        currentFilter.setValue(filterIntensity * 200, forKeyPath: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
        currentFilter.setValue(filterIntensity * 10, forKeyPath: kCIInputScaleKey)
        }
        guard let outputImage = currentFilter.outputImage else { return }
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func saveImage() {
        // TO SAVE IMAGE HERE...
        guard let processedImage = processedImage else { return }
        let imageSaver = ImageSaver()
        
        // Although the code is very different, the concept here is identical to what we did with ImagePicker: we wrapped up some UIKit functionality in such a way that we get all the behavior we want, just in a nicer, more SwiftUI-friendly way. Even better, this gives us another reusable piece of code that we can put into other projects in the future – we’re slowly building a library!
        imageSaver.successHandler = {
            print("Success !")
        }
        imageSaver.errorHandler = {
            print("Oops! \($0.localizedDescription)")
        }
        
        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
