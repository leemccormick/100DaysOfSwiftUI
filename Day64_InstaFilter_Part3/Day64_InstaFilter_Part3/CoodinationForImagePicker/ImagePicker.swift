//
//  ImagePicker.swift
//  Day64_InstaFilter_Part3
//
//  Created by Lee McCormick on 5/15/22.
//
import PhotosUI
import SwiftUI

struct ImagePicker : UIViewControllerRepresentable {
    @Binding var image: UIImage? // What we need here is SwiftUI’s @Binding property wrapper, which allows us to create a binding from ImagePicker up to whatever created it. This means we can set the binding value in our image picker and have it actually update a value being stored somewhere else – in ContentView, for example.
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        /*
         That does three things:

         1) It makes the class inherit from NSObject, which is the parent class for almost everything in UIKit. NSObject allows Objective-C to ask the object what functionality it supports at runtime, which means the photo picker can say things like “hey, the user selected an image, what do you want to do?”
         2) It makes the class conform to the PHPickerViewControllerDelegate protocol, which is what adds functionality for detecting when the user selects an image. (NSObject lets Objective-C check for the functionality; this protocol is what actually provides it.)
         3) It stops our code from compiling, because we’ve said that class conforms to PHPickerViewControllerDelegate but we haven’t implemented the one method required by that protocol.

         */
        var parent: ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // Code
            picker.dismiss(animated: true) // Tell the picker to go away
            guard let provider = results.first?.itemProvider else {return} // Exit if no selection was made
            if provider.canLoadObject(ofClass: UIImage.self) { // If this has an image we can use, use it
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator // The next step is to tell the PHPickerViewController that when something happens it should tell our coordinator. This takes just one line of code in makeUIViewController(), so add this directly before the return picker line, We don’t call makeCoordinator() ourselves; SwiftUI calls it automatically when an instance of ImagePicker is created. Even better, SwiftUI automatically associated the coordinator it created with our ImagePicker struct, which means when it calls makeUIViewController() and updateUIViewController() it will automatically pass that coordinator object to us.
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // To Continue with coordinators....
    }
    
    func makeCoordinator() -> Coordinator { // Even though that class is inside a UIViewControllerRepresentable struct, SwiftUI won’t automatically use it for the view’s coordinator. Instead, we need to add a new method called makeCoordinator(), which SwiftUI will automatically call if we implement it. All this needs to do is create and configure an instance of our Coordinator class, then send it back. Right now our Coordinator class doesn’t do anything special, so we can just send one back by adding this method to the ImagePicker struct
        Coordinator(self)
    }
}
