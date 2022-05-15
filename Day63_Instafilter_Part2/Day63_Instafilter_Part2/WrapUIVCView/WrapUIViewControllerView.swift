//
//  WrapUIViewControllerView.swift
//  Day63_Instafilter_Part2
//
//  Created by Lee McCormick on 5/14/22.
//

import SwiftUI

struct WrapUIViewControllerView: View {
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
        .navigationTitle("Wrapping a UIViewController in a SwiftUI view")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WrapUIViewControllerView_Previews: PreviewProvider {
    static var previews: some View {
        WrapUIViewControllerView()
    }
}

/*
 Go ahead and run that, either in the simulator or on your real device. When you tap the button the default iOS image picker should slide up letting you browse through all your photos.

 However, nothing will happen when an image is selected, and the Cancel button won’t do anything either. You see, even though we’ve created and presented a valid PHPickerViewController, we haven’t actually told it how to respond to user interactions.

 To make that happens requires a wholly new concept: coordinators.
 */
