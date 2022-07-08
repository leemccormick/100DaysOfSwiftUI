//
//  Prospects.swift
//  Day85_HotProspects_WrapUp
//
//  Created by Lee McCormick on 7/7/22.
//

import Foundation

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var date = Date()
    fileprivate(set) var isContacted = false
}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    let saveKey = "SaveData"
    
    init() {
        /* This is UserDefaults to store local data.
         if let data = UserDefaults.standard.data(forKey: saveKey) {
         if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
         people = decoded
         return
         }
         }
         */
        /* Challenge 2 : Use JSON and the documents directory for saving and loading our user data.
         */
        people = []
        if let data = self.loadFileFromDirectory() {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                people = decoded
                return
            }
        }
    }
    
    private func save() {
        /* This is UserDefaults to store local data.
         if let encoded = try? JSONEncoder().encode(people) {
         UserDefaults.standard.set(encoded, forKey: saveKey)
         }
         */
        /* Challenge 2 : Use JSON and the documents directory for saving and loading our user data.
         */
        if let encoded = try? JSONEncoder().encode(people) {
            saveFileInDirectory(data: encoded)
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    /* Challenge 2 : Use JSON and the documents directory for saving and loading our user data.
     */
    private func getDocumentsDirectoryFileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = paths[0].appendingPathComponent(saveKey)
        return fileURL
    }
    
    private func loadFileFromDirectory() -> Data? {
        let fileURL = getDocumentsDirectoryFileURL()
        do {
            let data = try Data(contentsOf: fileURL)
            return data
        } catch {
            print("Error Loading Data in Directory : \(error.localizedDescription)")
            return nil
        }
    }
    
    private func saveFileInDirectory(data: Data) {
        let fileURL = getDocumentsDirectoryFileURL()
        do {
            try data.write(to: fileURL, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Error Saving Data in Directory : \(error.localizedDescription)")
        }
    }
}
