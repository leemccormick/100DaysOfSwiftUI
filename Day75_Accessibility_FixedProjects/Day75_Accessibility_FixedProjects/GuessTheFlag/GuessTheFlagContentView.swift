//
//  GuessTheFlagContentView.swift
//  Day75_Accessibility_FixedProjects
//
//  Created by Lee McCormick on 6/6/22.
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

struct GuessTheFlagContentView: View {
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
    
    // So, the easiest way to attach labels there – the way that doesn’t require us to change any of our code – is to create a dictionary with country names as keys and accessibility labels as values, like this. Please add this to ContentView:
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
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
                                .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                            /*
                             And now all we need to do is add the accessibilityLabel() modifier to the flag images. I realize that sounds simple, but the code has to do three things:
                             
                             1) Use countries[number] to get the name of the country for the current flag.
                             2) Use that name as the key for labels.
                             3) Provide a string to use as a default if somehow the country name doesn’t exist in the dictionary. (This should never happen, but there’s no harm being safe!)
                             */
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

struct GuessTheFlagContentView_Previews: PreviewProvider {
    static var previews: some View {
        GuessTheFlagContentView()
    }
}
