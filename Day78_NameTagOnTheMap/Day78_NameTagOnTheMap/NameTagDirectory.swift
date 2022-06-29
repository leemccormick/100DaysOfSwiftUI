//
//  NameTagDirectory.swift
//  Day78_NameTagOnTheMap
//
//  Created by Lee McCormick on 6/23/22.
//

import UIKit

struct NameTagDirectory {
    func load(fileName: String) -> UIImage? {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
    func save(image: UIImage, id: String) -> String? {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileName = "\(id)"
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            try? imageData.write(to: fileURL, options: .atomic)
            return fileName
        }
        print("Error saving image with id : \(id)")
        return nil
    }
    
    func delete(fileName: String) {
        guard let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for fileURL in fileURLs where fileURL.pathExtension == fileName {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch  {
            print("Error deleting image : \(error)")
        }
    }
}
