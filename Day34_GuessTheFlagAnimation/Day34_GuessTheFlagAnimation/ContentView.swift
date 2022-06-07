//
//  ContentView.swift
//  Day34_GuessTheFlagAnimation
//
//  Created by Lee McCormick on 4/3/22.
//

import SwiftUI

struct FlagImage: View {
    var image: String
    
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding()
            .shadow(color: .blue, radius: 2, x: 2, y: 2)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    @State private var scores = 0
    @State private var numberOfQuestions = 0
    @State private var scoreTitle = ""
    @State private var showingScore = false
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    // Properties for animations
    @State private var spinAnimationAmount = 0.0
    @State private var showButtonAnimation = false
    @State private var selectedButtonIndex = 0
    @State private var buttonOpacity = 1.0
    @State private var buttonOffset = CGFloat.zero
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [.init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3), .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .titleStyle()
                    .font(.largeTitle.bold())
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
                            selectedButtonIndex = number
                            flagTapped(number)
                            if number == correctAnswer {
                                withAnimation(.easeInOut(duration: 2)) {
                                    self.spinAnimationAmount += 360
                                    self.buttonOpacity -= 0.75
                                }
                            } else {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    self.buttonOffset = 200
                                }
                            }
                            self.showButtonAnimation = true
                        } label: {
                            FlagImage(image: countries[number])
                        }
                        .rotation3DEffect(.degrees(spinAnimationAmount), axis: (x:0, y: number == self.selectedButtonIndex ? 1 :0, z:0))
                        .offset(x: number != self.correctAnswer ? self.buttonOffset : .zero, y: .zero) // Offset ==> Hide the button by setting the offset to 200
                        .clipped()
                        .opacity(number != self.selectedButtonIndex ? self.buttonOpacity : 1.0) // opacity ==> To set opacity of inCorrect buttons to 0.75
                        .disabled(self.showButtonAnimation)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score : \(scores) / \(numberOfQuestions)")
                    .titleStyle()
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(scores) / \(numberOfQuestions)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scores += 1
            scoreTitle = "Correct"
        } else {
            scoreTitle = "Wrong ! \n That's the flag of \(countries[number])"
        }
        showingScore = true
        numberOfQuestions += 1
    }
    
    func askQuestion() {
        self.showButtonAnimation = false
        self.buttonOpacity = 1
        self.buttonOffset = .zero
        if numberOfQuestions < 8 {
            countries = countries.shuffled()
            correctAnswer = Int.random(in: 0...2)
        } else {
            scores = 0
            numberOfQuestions = 0
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

