//
//  Bundle-Decodable.swift
//  Day97_SnowSeeker_Part2
//
//  Created by Lee McCormick on 7/15/22.
//

import Foundation

// MARK: - Bundle
extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) in bundle.")
        }
        let decoder = JSONDecoder()
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) in bundle.")
        }
        return loaded
    }
}
