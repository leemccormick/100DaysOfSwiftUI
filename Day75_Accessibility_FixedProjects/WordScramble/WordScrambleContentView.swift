//
//  WordScrambleContentView.swift
//  Day75_Accessibility_FixedProjects
//
//  Created by Lee McCormick on 6/6/22.
//

import SwiftUI

struct WordScrambleContentView: View {
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
                        // Alternatively, you could break that text up to have a hint as well as a label, like this:
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(word)
                        .accessibilityHint("\(word.count) letters")
                        /*
                         To fix this we need to group the elements inside the HStack together so we can apply our VoiceOver customization:
                         .accessibilityElement(children: .ignore)
                         .accessibilityLabel("\(word), \(word.count) letters")
                         */
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


struct WordScrambleContentView_Previews: PreviewProvider {
    static var previews: some View {
        WordScrambleContentView()
    }
}
