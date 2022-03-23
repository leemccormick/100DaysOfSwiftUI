//
//  ContentView.swift
//  Day22_GuessTheFlagPart3
//
//  Created by Lee McCormick on 3/22/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var scores = 0
    @State private var numberOfQuestion = 0
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score : \(scores) / \(numberOfQuestion)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action:  askQuestion)
        } message: {
            Text("Your score is \(scores) / \(numberOfQuestion)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scores += 1
            scoreTitle = "Correct"
        } else {
            scoreTitle = "Wrong !\n That's the flag of  \(countries[number])."
        }
        showingScore = true
        numberOfQuestion += 1
    }
    
    func askQuestion() {
        if numberOfQuestion < 8 {
            countries = countries.shuffled()
            correctAnswer = Int.random(in: 0...2)
        } else {
            scores = 0
            numberOfQuestion = 0
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*
 That’s another SwiftUI app completed, including lots of important new techniques. You’ll use VStack, HStack, and ZStack in almost every project you make, and you’ll see find you can quickly build complex layouts by combining them together.
 
 Many people find SwiftUI’s way of showing alerts a little odd at first: creating it, adding a condition, then simply triggering that condition at some point in the future seems like a lot more work than just asking the alert to show itself. But like I said, it’s important that our views always be a reflection of our program state, and that rules out us just showing alerts whenever we want to.
 
 Review what you learned
 Anyone can sit through a tutorial, but it takes actual work to remember what was taught. It’s my job to make sure you take as much from these tutorials as possible, so I’ve prepared a short review to help you check your learning.
 
 Challenge
 One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on:
 
 1) Add an @State property to store the user’s score, modify it when they get an answer right or wrong, then display it in the alert and in the score label.
 2) When someone chooses the wrong flag, tell them their mistake in your alert message – something like “Wrong! That’s the flag of France,” for example.
 3) Make the game show only 8 questions, at which point they see a final alert judging their score and can restart the game.
 
 Note: That last one takes a little more thinking than the others. A good place to start would be to add a second alert() modifier watching a different Boolean property, then connect its button to a reset() method to set the game back to its initial state.
 */
