//
//  DiceViewModel.swift
//  Day95_RollDice
//
//  Created by Lee McCormick on 7/14/22.
//

import Foundation

// MARK: - ObservableObject
class DiceViewModel: ObservableObject {
    // MARK: - Properties
    @Published var dice: Dice
    @Published var rollingDiceState: RollingDiceState
    @Published var totalPoints: String
    @Published var numberOfRolled : Int
    @Published var currentRandomPoints: Int
    @Published var isShowingPointsHistory = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var timeRemaining = 0
    var dicesData: [DiceData]
    private  var random : Int {
        switch dice {
        case .sideOf4:
            return Int.random(in: 1..<5)
        case .sideOf6:
            return Int.random(in: 1..<7)
        case .sideOf8:
            return Int.random(in: 1..<9)
        case .sideOf10:
            return Int.random(in: 1..<11)
        case .sideOf12:
            return Int.random(in: 1..<13)
        case .sideOf20:
            return Int.random(in: 1..<21)
        case .sideOf100:
            return Int.random(in: 1..<101)
        }
    }
    
    // MARK: - Init
    init() {
        dice = .sideOf4
        totalPoints = "0 | 0"
        currentRandomPoints = 0
        dicesData = []
        numberOfRolled = 0
        rollingDiceState = .shakeDice
        timeRemaining = 0
        self.loadFromDocumentDirectory()
    }
    
    // MARK: - Roll Dice
    func rollDice() {
        timeRemaining = 0
        var newRandom = 0
        for _ in 0..<20  {
            newRandom = random
        }
        currentRandomPoints = newRandom
        let newData = DiceData(points: currentRandomPoints, sides: dice.sides)
        dicesData.insert(newData, at: 0)
        saveInDocumentDirectory()
        loadTotalPoints(from: dicesData)
    }
    
    // MARK: - Reset Game
    func resetDiceGame() {
        deleteInDocumentDirectory()
        dice = .sideOf4
        totalPoints = "0 | 0"
        currentRandomPoints = 0
        dicesData = []
        numberOfRolled = 0
        rollingDiceState = .shakeDice
        timeRemaining = 0
        self.loadFromDocumentDirectory()
    }
    
    // MARK: - Helper Functions
    private func loadTotalPoints(from dicesData: [DiceData]) {
        let points = dicesData.map { $0.points }.reduce(0, +)
        let totalOfSides = dicesData.map { $0.sides }.reduce(0, +)
        totalPoints = "\(points) | \(totalOfSides)"
        numberOfRolled = dicesData.count
    }
    
    private func getDocumentDirectoryFileURL() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = path[0].appendingPathComponent("saveDiceKey")
        return fileURL
    }
    
    private func loadFromDocumentDirectory() {
        let fileURL = getDocumentDirectoryFileURL()
        do {
            let data = try Data(contentsOf: fileURL)
            if let decoded = try? JSONDecoder().decode([DiceData].self, from: data) {
                dicesData = decoded
                loadTotalPoints(from: decoded)
            } else {
                print("Error Loading Data in Directory : Error Decoded Data.")
                dicesData = []
            }
        } catch {
            print("Error Loading Data in Directory : \(error.localizedDescription)")
            dicesData = []
        }
    }
    
    private func saveInDocumentDirectory() {
        if let data = try? JSONEncoder().encode(dicesData) {
            do {
                let fileURL = getDocumentDirectoryFileURL()
                try data.write(to: fileURL, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Error Saving Data in Directory : \(error.localizedDescription)")
            }
        } else {
            print("Error Saving Data in Directory : Error Encoded Data.")
        }
    }
    
    private func deleteInDocumentDirectory() {
        let fileURL = getDocumentDirectoryFileURL()
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                print("Error Deleting Data in Directory : \(error.localizedDescription)")
            }
        }
    }
}
