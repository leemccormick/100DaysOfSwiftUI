//
//  Bundle-Decodable.swift
//  Day40_MoonShotPart2
//
//  Created by Lee McCormick on 4/10/22.
//

import Foundation

// Create another new Swift file, this time called Bundle-Decodable.swift. This will mostly use code you’ve seen before, but there’s one small difference: previously we used String(contentsOf:) to load files into a string, but because Codable uses Data we are instead going to use Data(contentsOf:). It works in just the same way as String(contentsOf:): give it a file URL to load, and it either returns its contents or throws an error.

extension Bundle {
    //  func decode(_ file: String) -> [String: Astronaut] {
    //  func decode<T>(_ file: String) -> T {
    func decode<T: Codable>(_ file: String) -> T { // Fortunately we can fix this with a constraint: we can tell Swift that T can be whatever we want, as long as that thing conforms to Codable. That way Swift knows it’s safe to use, and will make sure we don’t try to use the method with a type that doesn’t conform to Codable.
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.") // As you can see, that makes liberal use of fatalError(): if the file can’t be found, loaded, or decoded the app will crash. As before, though, this will never actually happen unless you’ve made a mistake, for example if you forgot to copy the JSON file into your project.
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter) //That tells the decoder to parse dates in the exact format we expect.
        
        // guard let loaded = try? decoder.decode([String: Astronaut].self, from: data) else {
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        return loaded
    }
}
