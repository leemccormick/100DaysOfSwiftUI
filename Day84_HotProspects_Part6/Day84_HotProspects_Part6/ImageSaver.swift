//
//  ImageSaver.swift
//  Day84_HotProspects_Part6
//
//  Created by Lee McCormick on 7/6/22.
//

import UIKit

/*
 In terms of saving the image, we can use the same ImageSaver class we used back in project 13 (Instafilter), because that takes care of all the complex work for us. If you have ImageSaver.swift around from the previous project you can just drag it into your new project now, but if not here’s the code again:
 */

class ImageSaver: NSObject {
    var successHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            errorHandler?(error)
        } else {
            successHandler?()
        }
    }
}

/*
 Before you try the context menu yourself, make sure you add the same project option we had for the Instafilter project – you need to add a permission request string to your project’s configuration options.
 
 In case you’ve forgotten how to do that, here are the steps you need:
 
 - Open your target settings
 - Select the Info tab
 - Right-click on an existing option
 - Choose Add Row
 - Select “Privacy - Photo Library Additions Usage Description” for the key name.
 - Enter “We want to save your QR code.” as the value.
 */
