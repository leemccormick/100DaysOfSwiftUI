//
//  FileManager-DocumentsDirectory.swift
//  Day73_BuckList_WrapUp
//
//  Created by Lee McCormick on 5/24/22.
//

import Foundation

extension FileManager {
    static var documentDirectory : URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
