//
//  DocDirectoryView.swift
//  Day68_BacketList_Part1
//
//  Created by Lee McCormick on 5/19/22.
//

import SwiftUI

struct DocDirectoryView: View {
    let info =
    """
     Now that we have a directory to work with, we can read and write files there freely. You already met String(contentsOf:) and Data(contentsOf:) for reading data, but for writing data we need to use the write(to:) method. When used with strings this takes three parameters:
    
     1) A URL to write to.
     2) Whether to make the write atomic, which means “all at once”.
     3) What character encoding to use.
     
     The first of those can be created by combining the documents directory URL with a filename, such as myfile.txt.
    
     The second should nearly always be set to true. If this is set to false and we try to write a big file, it’s possible that another part of our app might try and read the file while it’s still being written. This shouldn’t cause a crash or anything, but it does mean that it’s going to read only part of the data, because the other part hasn’t been written yet. Atomic writing causes the system to write our full file to a temporary filename (not the one we asked for), and when that’s finished it does a simple rename to our target filename. This means either the whole file is there or nothing is.
    
     The third parameter is something we looked at briefly in project 5, because we had to use a Swift string with an Objective-C API. Back then we used the character encoding UTF-16, which is what Objective-C uses, but Swift’s native encoding is UTF-8, so we’re going to use that instead.
    """
    
    var body: some View {
        Form {
            Text("Writing data to the documents directory")
                .onTapGesture {
                    let str = "Test Message"
                    let url = getDocumentsDirectory().appendingPathComponent("message.txt")
                    do {
                        try str.write(to: url, atomically: true, encoding: .utf8)
                        let input = try String(contentsOf: url)
                        print(input)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            ScrollView {
                Text(info)
            }
        }
        .navigationTitle("Writing data to the documents directory")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) // find all possible documents directories for this user
        return paths[0] // just send back the first one, which ought to be the only one
    }
}

struct DocDirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        DocDirectoryView()
    }
}
