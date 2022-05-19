//
//  ContentView.swift
//  Day67_InstaFilter_WrapUp
//
//  Created by Lee McCormick on 5/16/22.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

/*
 Challenge :
 1) Try making the Save button disabled if there is no image in the image view.
 2) Experiment with having more than one slider, to control each of the input keys you care about. For example, you might have one for radius and one for intensity.
 3) Explore the range of available Core Image filters, and add any three of your choosing to the app.
 */

struct ContentView: View {
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    @State private var filterIntensityAmount = 0.5
    @State private var filterRadiusAmount = 0.5
    @State private var filterScaleAmount = 0.5
    @State private var showingImagePicker = false
    @State private var showingFilterSheet = false
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.black)
                    Text("Tap To Select Image")
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
                    Text("Intensity : ")
                    Slider(value: $filterIntensityAmount)
                        .onChange(of: filterIntensityAmount) { _ in
                            applyingFilter()
                        }
                }
                .padding(.vertical)
                //  Challenge 2 : Experiment with having more than one slider, to control each of the input keys you care about. For example, you might have one for radius and one for intensity.
                HStack {
                    Text("Radius : ")
                    Slider(value: $filterRadiusAmount)
                        .onChange(of: filterRadiusAmount) { _ in
                            applyingFilter()
                        }
                }
                .padding(.vertical)
                HStack {
                    Text("Scale : ")
                    Slider(value: $filterScaleAmount)
                        .onChange(of: filterScaleAmount) { _ in
                            applyingFilter()
                        }
                }
                .padding(.vertical)
                HStack {
                    Button("Change Filter") {
                        showingFilterSheet = true
                    }
                    Spacer()
                    Button("Save", action: saveImage)
                        .disabled(inputImage == nil ? true : false) //  Challenge 1 : Try making the Save button disabled if there is no image in the image view.
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Day67 : InstaFilter Wrapup")
            .onChange(of: inputImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) { ImagePicker(image: $inputImage) }
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
                VStack {
                    Button("Crystallize") {setFilter(CIFilter.crystallize())}
                    Button("Edges") {setFilter(CIFilter.edges())}
                    Button("GaussianBlur") {setFilter(CIFilter.gaussianBlur())}
                    Button("Pixellate") {setFilter(CIFilter.pixellate())}
                    Button("Sepia Tone") {setFilter(CIFilter.sepiaTone())}
                    Button("Unsharp Mask") {setFilter(CIFilter.unsharpMask())}
                    Button("Vignette") {setFilter(CIFilter.vignette())}
                }
                //  Challenge 3 : Explore the range of available Core Image filters, and add any three of your choosing to the app.
                VStack {
                    Button("White Point") {setFilter(CIFilter.whitePointAdjust())}
                    Button("Box Blur") {setFilter(CIFilter.boxBlur())}
                    Button("Color  Clamp") {setFilter(CIFilter.colorClamp())}
                    Button("Color  Map") {setFilter(CIFilter.colorMap())}
                    Button("Median") {setFilter(CIFilter.median())}
                    Button("Affine Clamp") {setFilter(CIFilter.affineClamp())}
                }
                
                VStack {
                    Button("Circular Wrap") {setFilter(CIFilter.circularWrap())}
                    Button("Color  Cube") {setFilter(CIFilter.colorCube())}
                    Button("Blend Mark") {setFilter(CIFilter.blendWithMask())}
                    Button("Darken Blend") {setFilter(CIFilter.darkenBlendMode())}
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKeyPath: kCIInputImageKey)
        applyingFilter()
    }
    
    func applyingFilter() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensityAmount, forKeyPath: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadiusAmount * 200, forKeyPath: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterScaleAmount * 10, forKeyPath: kCIInputScaleKey)
        }
        guard let outputImage = currentFilter.outputImage else {return}
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func saveImage() {
        guard let processedImage = processedImage else {return}
        let imageSaver = ImageSaver()
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
