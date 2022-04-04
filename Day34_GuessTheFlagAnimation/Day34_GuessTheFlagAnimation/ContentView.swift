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

/* Project 6, part 3
 Diana Scharf-Hunt once said, “goals are dreams with deadlines.” Well, we know your goal is to learn SwiftUI because that’s why you’re here, so it’s time to add a deadline too: your mission today is to complete three animation challenges that will really put your skills – and your creativity! – to the test.
 
 As you’ll see, one of the challenges today specifically asks you to be creative and try something yourself. You have all the tools now to create a huge variety of animations and transitions, so all that’s holding you back is the opportunity to practice.
 
 Well, this is it – good luck!
 
 Today you should work through the wrap up chapter for project 6, complete its review, then work through all three of its challenges.
 
 Animation: Wrap up
 Review for Project 6: Animation
 I look forward to seeing what you create with the third challenge – make a video and share it on Twitter, making sure to add @twostraws somewhere in there so I see it!
 
 Need help? Tweet me @twostraws!
 */

/* Animation: Wrap up
 Paul Hudson     @twostraws    November 2nd 2021
 
 This technique project started off easier, took a few twists and turns, and progressed into more advanced animations, but I hope it’s given you an idea of just how powerful – and how flexible! – SwiftUI’s animation system is.
 
 As I’ve said previously, animation is about both making your app look great and also adding extra meaning. So, rather than making a view disappear abruptly, can you add a transition to help the user understand something is changing?
 
 Also, don’t forget what it looks like to be playful in your user interface. My all-time #1 favorite iOS animation is one that Apple ditched when they moved to iOS 7, and it was the animation for deleting passes in the Wallet app – a metal shredder appeared and cut your pass into a dozen strips that then dropped away. It only took a fraction of a second more than the current animation, but it was beautiful and fun too!
 
 Review what you learned
 Anyone can sit through a tutorial, but it takes actual work to remember what was taught. It’s my job to make sure you take as much from these tutorials as possible, so I’ve prepared a short review to help you check your learning.
 
 Click here to review what you learned in this project.
 
 Challenge
 One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on.
 
 Go back to the Guess the Flag project and add some animation:
 
 When you tap a flag, make it spin around 360 degrees on the Y axis.
 Make the other two buttons fade out to 25% opacity.
 Add a third effect of your choosing to the two flags the user didn’t choose – maybe make them scale down? Or flip in a different direction? Experiment!
 These challenges aren’t easy. They take only a few lines of code, but you’ll need to think carefully about what modifiers you use to get the exact animations you want. Try adding an @State property to track which flag the user tapped on, then using that inside conditional modifiers for rotation, fading, and whatever you decide for the third challenge.
 */
