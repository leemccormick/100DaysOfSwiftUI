//
//  Buddle-Decodable.swift
//  Day99_SnowSeeker_WrapUp
//
//  Created by Lee McCormick on 7/15/22.
//

import Foundation

// MARK: - Bundle
extension Bundle {
    func decoded<T: Decodable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) in bundle")
        }
        guard let loaded = try? JSONDecoder().decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) in bundle")
        }
        return loaded
    }
}
