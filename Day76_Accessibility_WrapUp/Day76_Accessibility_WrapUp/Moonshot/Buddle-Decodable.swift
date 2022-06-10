//
//  Buddle-Decodable.swift
//  Day76_Accessibility_WrapUp
//
//  Created by Lee McCormick on 6/9/22.
//

import Foundation

extension Bundle {
    func decode<T : Codable>(_ file: String) -> T {
        guard let url =  url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate url of \(file) in bundle.")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to get data from \(url) of \(file) in bundle.")
        }
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode data : \(data) of \(file) in bundle.")
        }
        return loaded
    }
}
