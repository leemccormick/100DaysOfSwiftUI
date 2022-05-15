//
//  ImagePicker.swift
//  Day63_Instafilter_Part2
//
//  Created by Lee McCormick on 5/14/22.
//

// All this matters because asking the user to select a photo from their library uses a view controller called PHPickerViewController, and the delegate protocol PHPickerViewControllerDelegate. SwiftUI can’t use these two directly, so we need to wrap them. We’re going to start simple and work our way up. Wrapping a UIKit view controller requires us to create a struct that conforms to the UIViewControllerRepresentable protocol. So, press Cmd+N to make a new file, choose Swift File, and name it ImagePicker.swift. Add import PhotosUI and import SwiftUI to the top of the new file, then give it this code:
import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    /* That creates a new photo picker configuration, asking it to provide us only images, then uses that to create and return a PHPickerViewController that does the actual work of selecting an image.
    
    We’ll add some more code to that shortly, but that’s actually all we need to wrap a basic view controller.

    Our ImagePicker struct is a valid SwiftUI view, which means we can now show it in a sheet just like any other SwiftUI view. This particular struct is designed to show an image, so we need an optional Image view to hold the selected image, plus some state that determines whether the sheet is showing or not.
     */
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // To Continue with coordinators...
    }
    
    // typealias UIViewControllerType = PHPickerViewController ==> hat isn’t enough code to compile correctly, but when Xcode shows an error saying “Type ImagePicker does not conform to protocol UIViewControllerRepresentable”, please click the red and white circle to the left of the error and select “Fix”. This will make Xcode write the two methods we actually need, and in fact those methods are actually enough for Swift to figure out the view controller type so you can delete the typealias line.
}
