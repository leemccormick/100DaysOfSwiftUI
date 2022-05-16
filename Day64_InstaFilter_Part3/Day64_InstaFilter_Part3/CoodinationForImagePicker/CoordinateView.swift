//
//  CordinateView.swift
//  Day64_InstaFilter_Part3
//
//  Created by Lee McCormick on 5/15/22.
//

import SwiftUI

struct CoordinatorView: View {
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    let info =
    """
    - We created a SwiftUI view that conforms to UIViewControllerRepresentable.
    - We gave it a makeUIViewController() method that created some sort of UIViewController, which in our example was a PHPickerViewController.
    - We added a nested Coordinator class to act as a bridge between the UIKit view controller and our SwiftUI view.
    - We gave that coordinator a didFinishPicking method, which will be triggered by iOS when an image was selected.
    - Finally, we gave our ImagePicker an @Binding property so that it can send changes back to a parent view.
    """
    var body: some View {
        VStack {
            ScrollView {
                Text(info)
            }
            image?
                .resizable()
                .scaledToFit()
            Button("Select Image") {
                showingImagePicker = true
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
        .onChange(of: inputImage) { _ in loadImage() }
        .navigationTitle("Using coordinators to manage SwiftUI view controllers")
        .navigationBarTitleDisplayMode(.inline)
    }
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}

struct CordinateView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatorView()
    }
}
