//
//  ImageSaver.swift
//  Day65_InstaFilter_Part4
//
//  Created by Lee McCormick on 5/16/22.
//

import UIKit
import SwiftUI

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveComplted), nil)
    }
    
    @objc func saveComplted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished")
    }
}
