//
//  ContentView.swift
//  Day24_GuessTheFlagReview
//
//  Created by Lee McCormick on 3/24/22.
//

import SwiftUI

// 2) Go back to project 2 and replace the Image view used for flags with a new FlagImage() view that renders one flag image using the specific set of modifiers we had.
struct FlagImage: View {
    var image: String
    
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

// 3) Create a custom ViewModifier (and accompanying View extension) that makes a view have a large, blue font suitable for prominent titles in a view.
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
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700)
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
                            flagTapped(number)
                        } label: {
                            FlagImage(image: countries[number])
                        }
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
            scoreTitle = "Wrong ! \n That's the flag of \(countries[number])."
        }
        showingScore = true
        numberOfQuestions += 1
    }
    
    func askQuestion() {
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

/*
 Albert Einstein once said, “any fool can know; the point is to understand,” and this project was specifically about giving you a deeper understanding of what makes SwiftUI tick. After all, you’ll be spending the next 76 days working with it, so it’s a good idea to make sure your foundations are rock solid before moving on.
 
 I could have said to you “SwiftUI uses structs for views” or “SwiftUI uses some View a lot”, and in fact did say exactly that to begin with when it was all you needed to know. But now that you’re progressing beyond the basics, it’s important to feel comfortable with what you’re using – to eliminate the nagging sense that you don’t quite get what something is for when you look at your code.
 
 So much of Swift was built specifically for SwiftUI, so don’t be worried if you’re looking at some of the features and thinking they are way beyond your level. If you think about it, they were well above everyone’s level until Swift shipped with them!
 
 Today you should work through the wrap up chapter for project 3, complete its review, then work through all three of its challenges.
 
 Views and modifiers: Wrap up
 Review for Project 3: Views and Modifiers
 Once you’re done, don’t forget to stay accountable and tell other people about your progress!
 */

/*
 These technique projects are designed to dive deep into specific SwiftUI topics, and I hope you’ve learned a lot about views and modifiers here – why SwiftUI uses structs for views, why some View is so useful, how modifier order matters, and much more.
 
 Views and modifiers are the fundamental building blocks of any SwiftUI app, which is why I wanted to focus on them so early in this course. View composition is particularly key, as it allows to build small, reusable views that can be assembled like bricks into larger user interfaces.
 
 Review what you learned
 Anyone can sit through a tutorial, but it takes actual work to remember what was taught. It’s my job to make sure you take as much from these tutorials as possible, so I’ve prepared a short review to help you check your learning.
 
 Click here to review what you learned in this project.
 
 Challenge
 One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on:
 
 1) Go back to project 1 and use a conditional modifier to change the total amount text view to red if the user selects a 0% tip.
 2) Go back to project 2 and replace the Image view used for flags with a new FlagImage() view that renders one flag image using the specific set of modifiers we had.
 3) Create a custom ViewModifier (and accompanying View extension) that makes a view have a large, blue font suitable for prominent titles in a view.
 */
