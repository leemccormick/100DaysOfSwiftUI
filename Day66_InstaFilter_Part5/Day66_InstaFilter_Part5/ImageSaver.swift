//
//  ImageSaver.swift
//  Day66_InstaFilter_Part5
//
//  Created by Lee McCormick on 5/16/22.
//

import UIKit
import SwiftUI

class ImageSaver: NSObject {
    /*
     As I explained previously, the UIImageWriteToSavedPhotosAlbum() function does everything we need, but it has the catch that it needs to be used with some code that really doesn’t fit well with SwiftUI: it needs to be a class that inherits from NSObject, have a callback method that is marked with @objc, then point to that method using the #selector compiler directive.

     Like I showed you in an earlier part of this tutorial, the best way to approach this is to isolate the whole image saving functionality in a separate, reusable class. You should already have ImageSaver.swift in place from a previous stage of this project, but if not create a new Swift file with that name now and give it this code:
     */
    var successHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveComplted), nil)
    }
    
    @objc func saveComplted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished")
        if let error = error {
            errorHandler?(error)
        } else {
            successHandler?()
        }
    }
}

/*
 We’re going to return back to that in a moment to make it more useful, but first we need to make sure we request photo saving permission from the user correctly: we need to add a permission request string to our project’s configuration options.

 If you deleted the one you added earlier, please re-add it now:

 1) Open your target settings
 2) Select the Info tab
 3) Right-click on an existing option
 4) Choose Add Row
 5) Select “Privacy - Photo Library Additions Usage Description” for the key name.
 6) Enter “We want to save the filtered photo.” as the value.
 */
