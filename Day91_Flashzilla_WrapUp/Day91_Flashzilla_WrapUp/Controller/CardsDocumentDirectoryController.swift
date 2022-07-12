//
//  CardsDocument.swift
//  Day91_Flashzilla_WrapUp
//
//  Created by Lee McCormick on 7/12/22.
//

import Foundation
import SwiftUI

// MARK: - CardsDocument
class CardsDocumentDirectoryController: ObservableObject {
    @Published private(set) var cards: [Card]
    @Published private(set) var timeRemaining = 100
    @Published private var isActive = true
    @Published var newPrompt = ""
    @Published var newAnswer = ""
    private let saveCardsKey = "Cards"
    
    // MARK: - init
    init() {
        cards = []
        self.loadCardsFromDocumentDirectory()
    }
    
    // MARK: - Functions for ContentView
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        cards.remove(at: index)
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func restackCard(at index: Int) { //  Challenge 3
        guard index >= 0 else { return }
        let newCard = cards[index]
        cards.remove(at: index)
        cards.insert(newCard, at: 0)
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        timeRemaining = 100
        isActive = true
        loadCardsFromDocumentDirectory()
    }
    
    func updateTimeRemaining() {
        if timeRemaining > 0 {
            guard isActive else { return }
            timeRemaining -= 1
        }
    }
    func updateIsActiveStatus(with newPhase: ScenePhase ) {
        if newPhase == .active {
            if cards.isEmpty == false {
                isActive = true
            }
        } else {
            isActive = false
        }
    }
    
    // MARK: - Functions for EditView
    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }
        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        cards.insert(card, at: 0)
        //  Challenge 1 : When adding a card, the textfields keep their current text – fix that so that the textfields clear themselves after a card is added.
        newPrompt = ""
        newAnswer = ""
        saveCardsInDocumentDirectory()
    }
    
    func removeCards(at offset: IndexSet) {
        cards.remove(atOffsets: offset)
        saveCardsInDocumentDirectory()
    }
    
    // MARK: - Document Directory
    /* Challenge
     1) Make it use documents JSON rather than UserDefaults – this is generally a good idea, so you should get practice with this.
     2) Try to find a way to centralize the loading and saving code for the cards. You might need to experiment a little to find something you like!
     */
    private func getDocumentDirectoryFileURL() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = path[0].appendingPathComponent(saveCardsKey)
        return fileURL
    }
    
    private func loadCardsFromDocumentDirectory() {
        let fileURL = getDocumentDirectoryFileURL()
        do {
            let data = try Data(contentsOf: fileURL)
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            } else {
                print("Error Loading Data in Directory : Error Decoded Data to Cards.")
                cards = []
            }
        } catch {
            print("Error Loading Data in Directory : \(error.localizedDescription)")
            cards = []
        }
    }
    
    private func saveCardsInDocumentDirectory() {
        if let data = try? JSONEncoder().encode(cards) {
            do {
                let fileURL = getDocumentDirectoryFileURL()
                try data.write(to: fileURL, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Error Saving Data in Directory : \(error.localizedDescription)")
            }
        } else {
            print("Error Saving Data in Directory : Error Encoded Data from Cards.")
        }
    }
}
