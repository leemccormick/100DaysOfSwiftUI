//
//  ContentView.swift
//  Day31_WordScrambleWrapUp
//
//  Created by Lee McCormick on 3/31/22.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var scores = 0
    @State private var numbersOfAttempt = 0
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .autocapitalization(.none)
                } header: {
                    Text("Score : \(scores) | \(numbersOfAttempt)")
                        .font(.title)
                }
                Section {
                    ForEach (usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) {}
            } message : {
                Text(errorMessage)
            }
            .toolbar {
                Button("Start Game", action: startGame)
            }
        }
    }
    
    func addWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        numbersOfAttempt += 1
        guard answer.count > 0 else { return }
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already!", message: "Be more original !")
            return
        }
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible!", message: "You can not spell that word from '\(rootWord)'!")
            return
        }
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized!", message: "You can just make up a word!")
            return
        }
        guard isNotTooShot(word: answer) else {
            wordError(title: "Word is too short!", message: "The word should be more than 2 sylables.")
            return
        }
        guard isRootWord(word: answer) else {
            wordError(title: "Same Word!", message: "The word is the root word, try with another word!")
            return
        }
        withAnimation {
            usedWords.insert(answer, at: 0)
            scores += 1
        }
        newWord = ""
    }
    
    func startGame() {
        scores = 0
        numbersOfAttempt = 0
        if let startWordURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func isNotTooShot(word: String) -> Bool {
        word.count >= 3
    }
    
    func isRootWord(word: String) -> Bool {
        word != rootWord
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*
 Challenge
 One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on:
 
 1) Disallow answers that are shorter than three letters or are just our start word.
 2) Add a toolbar button that calls startGame(), so users can restart with a new word whenever they want to.
 3) Put a text view somewhere so you can track and show the player’s score for a given root word. How you calculate score is down to you, but something involving number of words and their letter count would be reasonable.
 */

