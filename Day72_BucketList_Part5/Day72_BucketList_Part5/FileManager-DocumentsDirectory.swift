//
//  FileManager-DocumentsDirectory.swift
//  Day72_BucketList_Part5
//
//  Created by Lee McCormick on 5/23/22.
//

import Foundation

/*
 Anyway, in this case now that we have our view model all set up, we can upgrade it to support loading and saving of data. This will look in the documents directory for a particular file, then use either JSONEncoder or JSONDecoder to convert it ready for use.
 
 Previously I showed you how to find our app’s documents directory with a reusable function, but here we’re going to package it up as an extension on FileManager for easier access in any project.
 
 Create a new Swift file called FileManager-DocumentsDirectory.swift, then give it this code:
 */

extension FileManager {
    static var documentsDirectory : URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
