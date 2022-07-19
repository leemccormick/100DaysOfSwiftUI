//
//  Questions.swift
//  Day100_FinalExam
//
//  Created by Lee McCormick on 7/17/22.
//

import Foundation

// MARK: - Question
struct Question : Identifiable, Equatable {
    var id = UUID()
    let propmt: String
    let chioces: [MutipleChoice]
    let correctChoice: Int
    var didAnswer = false
    
    static let example = Question(propmt: "Which of these statements are true?",
                                  chioces: [MutipleChoice(choice: "This is day 100 of SwiftUI.", explianationChoice: "Yes, I finally did it! 100 days of SwiftUI. "),
                                            MutipleChoice(choice: "This is day 100 of C#.", explianationChoice: "No, It is 100 days of SwiftUI. ")],
                                  correctChoice: 0)
    
    // MARK: - Equatable
    static func ==(lhs: Question, rhs: Question) -> Bool {
        return lhs.propmt == rhs.propmt && lhs.chioces == rhs.chioces && lhs.correctChoice == rhs.correctChoice
    }
}

// MARK: - MutipleChoice
struct MutipleChoice :  Equatable {
    let choice: String
    let explianationChoice: String
    
    // MARK: - Equatable
    static func ==(lhs: MutipleChoice, rhs: MutipleChoice) -> Bool {
        return lhs.choice == rhs.choice && lhs.explianationChoice == rhs.explianationChoice
    }
}
