//
//  ContentView.swift
//  Day35_Edutainment
//
//  Created by Lee McCormick on 4/4/22.
//

import SwiftUI

struct MutiplyQuestion : Hashable {
    let correctAnswer: Int
    let firstNum : Int
    let secondNum : Int
    var userAnswer: Int = 0
    var didAnswer = false
    var questionItem = 0
    var isUserCorrect = false
}

struct ContentView: View {
    // Clear Color for List
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = UIColor.clear
        UITableViewCell.appearance().backgroundColor = UIColor.clear
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().backgroundView = nil
        UITableViewCell.appearance().backgroundView = nil
    }
    
    // Properties For Views
    @State private var numberOfDifficulty = 2
    @State private var numberOfQuestion = 5
    @State private var numberOfQuestions = [5, 10, 15, 20]
    @State private var dragAmount = CGSize.zero
    @State private var gameTextDetail = "Enjoy Edutainment !"
    @State private var showCircleDetail = false
    @State private var animationAmountCircleDetail = 0.0
    let letters = Array("EDUTAINMENT")
    
    // Properties For Game Logic
    @State private var score = 0
    @State private var answer = ""
    @State private var currentQuestion = 0
    @State private var isPlayingGame = false
    @State private var questions = [MutiplyQuestion(correctAnswer: 0, firstNum: 0, secondNum: 0)]
    @State private var listOfDidAnsweredQuestions = [MutiplyQuestion(correctAnswer: 0, firstNum: 0, secondNum: 0)]
    
    var body: some View {
        ZStack {
            AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .orange]), center: .center)
                .ignoresSafeArea()
            
            // Top Views With Start Game Buttton and Edutainment Title
            VStack {
                HStack {
                    Button(isPlayingGame ? "End Game" : "Start Game") {
                        if isPlayingGame {
                            endGame()
                        } else {
                            startGame(levelSelection: numberOfDifficulty, numberOfQuestion: numberOfQuestion)
                        }
                    }
                    .frame(width: 80, height: 80)
                    .background(isPlayingGame ? .orange : .pink)
                    .foregroundColor(.white)
                    .font(.headline)
                    .shadow(color: .brown, radius: 1, x: 1, y: 1)
                    .clipShape(RoundedRectangle(cornerRadius: 360))
                    
                    HStack(spacing: 0) {                    ForEach(0..<letters.count) { num in
                        Text(String(letters[num]))
                            .padding(3)
                            .font(.title)
                            .background(isPlayingGame ? .yellow : .red)
                            .offset(dragAmount)
                            .animation(.default.delay(Double(num) / 20), value: dragAmount)
                    }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { dragAmount = $0.translation }
                            .onEnded { _ in
                                dragAmount = .zero
                            }
                    )
                }
                .padding(10)
                
                // Game Setting Views With Stepper and Picker
                if !isPlayingGame { // Hide Game Setting when user is playing game.
                    VStack {
                        VStack(alignment: .center, spacing: 20)
                        {
                            HStack {
                                Image(systemName: "\(numberOfDifficulty).circle")
                                    .foregroundColor(.gray)
                                    .frame(width: 50, height: 50, alignment: .center)
                                    .font(.largeTitle)
                                    .background(.white)
                                    .cornerRadius(360)
                                
                                Text("Levels Of Mutiplication :")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .bold()
                                    .shadow(color: .brown, radius: 1, x: 1, y: 1)
                                Stepper("Multiple up to \(numberOfDifficulty)", value: $numberOfDifficulty, in: 2...12, step: 1)
                                    .labelsHidden()
                                    .foregroundColor(.white)
                                    .tint(.white)
                                    .background(.white)
                                    .cornerRadius(10)
                            }
                            HStack {
                                Image(systemName: "\(numberOfQuestion).circle")
                                    .foregroundColor(.gray)
                                    .frame(width: 50, height: 50, alignment: .center)
                                    .font(.largeTitle)
                                    .background(.white)
                                    .cornerRadius(360)
                                Text("Questions : ")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .bold()
                                    .shadow(color: .brown, radius: 1, x: 1, y: 1)
                                Picker("Number Of Questions : ", selection: $numberOfQuestion) {
                                    ForEach (numberOfQuestions, id: \.self) {
                                        Text($0, format: .number)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .foregroundColor(.brown)
                                .tint(.red)
                                .background(.white)
                                .cornerRadius(10)
                            }
                        }
                        .padding(20)
                    }
                }
                
                // Question View With 2 Number Text For Multiply Game
                if isPlayingGame { // Show Question when user is playing game
                    HStack {
                        Text(currentQuestion > questions.count - 1 ? "0" : "\(questions[currentQuestion].firstNum)")
                            .foregroundColor(.blue)
                            .font(.largeTitle)
                            .bold()
                            .shadow(color: .brown, radius: 1, x: 1, y: 1)
                            .frame(width: 60, height: 60, alignment: .center)
                            .background(.white)
                            .cornerRadius(10)
                        
                        Image(systemName: "multiply")
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 50, alignment: .center)
                            .font(.largeTitle)
                            .background(.white)
                            .cornerRadius(10)
                            .padding(40)
                        
                        Text(currentQuestion > questions.count - 1  ? "0" : "\(questions[currentQuestion].secondNum)")
                            .foregroundColor(.blue)
                            .font(.largeTitle)
                            .bold()
                            .shadow(color: .brown, radius: 1, x: 1, y: 1)
                            .frame(width: 60, height: 60, alignment: .center)
                            .background(.white)
                            .cornerRadius(10)
                    }
                    
                    // Answer TextField using onCommit when done editing
                    TextField("ANSWER", text: $answer)
                        .frame(width: 200, height: 50, alignment: .center)
                        .foregroundColor(.brown)
                        .keyboardType(.numberPad)
                        .background(.white)
                        .cornerRadius(10)
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    // Show Score Views with  List of questions and score
                    List {
                        // Score Detail
                        Text("Score : \(score) of \(numberOfQuestion)")
                            .font(.title)
                            .bold()
                            .frame(width: 300, height: 40, alignment: .center)
                            .foregroundColor(.gray)
                        
                        if !questions.isEmpty {
                            ForEach (listOfDidAnsweredQuestions, id: \.self) { q in
                                if q.didAnswer {
                                    HStack {
                                        // User Answer Detail
                                        Image(systemName: "questionmark.square")
                                            .foregroundColor(.gray)
                                        Image(systemName: "\(q.questionItem).square")
                                            .foregroundColor(.gray)
                                        Image(systemName: q.isUserCorrect ? "checkmark.circle" : "x.circle" )
                                            .foregroundColor(q.isUserCorrect ? .green : .red)
                                        Text("\(q.firstNum) x \(q.secondNum) = ")
                                            .foregroundColor(q.isUserCorrect ? .green : .red)
                                        Text(q.userAnswer, format: .number)
                                            .foregroundColor(q.isUserCorrect ? .green : .red)
                                        
                                        Text("|")
                                            .foregroundColor(.gray)
                                            .font(.subheadline)
                                            .bold()
                                        
                                        // Correct Answer Detail
                                        Image(systemName: "checkmark.circle")
                                            .foregroundColor(.green)
                                        Text("\(q.firstNum) x \(q.secondNum) = ")
                                            .foregroundColor(.green)
                                        Text("\(q.correctAnswer)")
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                        }
                    }
                    .cornerRadius(10)
                } else { // If user is not  playing game then show game detail and last score.
                    if showCircleDetail {
                        ZStack {
                            Rectangle()
                                .frame(width: 300, height: 100, alignment: .center)
                                .cornerRadius(10)
                            VStack {
                                Text("GAME OVER !")
                                    .frame(width: 250, height: 40, alignment: .center)
                                    .foregroundColor(.white)
                                    .font(.title.bold())
                                Text("\(gameTextDetail)")
                                    .frame(width: 250, height: 40, alignment: .center)
                                    .foregroundColor(.white)
                                    .font(.headline.bold())
                            }
                        }
                        .onTapGesture {
                            showCircleDetail = false
                        }
                    }
                }
            }
        }
        .onSubmit(continuteGame)
    }
    
    func startGame(levelSelection: Int, numberOfQuestion: Int) {
        endGame()
        var index = 1
        for _ in 1...numberOfQuestion {
            var firstNum = Int.random(in: 1...12)
            var secondNum = Int.random(in: 2...levelSelection)
            
            for q in questions {
                if q.firstNum == firstNum {
                    firstNum = Int.random(in: 1...12)
                }
                if q.secondNum == secondNum {
                    secondNum = Int.random(in: 2...levelSelection)
                }
            }
            
            let newQuestion = MutiplyQuestion(correctAnswer: firstNum*secondNum, firstNum: firstNum, secondNum: secondNum, questionItem: index)
            questions.append(newQuestion)
            index += 1
        }
        isPlayingGame = true
        showCircleDetail = false
    }
    
    func endGame() {
        isPlayingGame = false
        questions = []
        currentQuestion = 0
        score = 0
        answer = ""
    }
    
    func continuteGame() {
        listOfDidAnsweredQuestions = []
        questions[currentQuestion].didAnswer = true
        questions[currentQuestion].userAnswer = Int(answer) ?? 0
        if questions[currentQuestion].correctAnswer ==  questions[currentQuestion].userAnswer {
            questions[currentQuestion].isUserCorrect = true
            score += 1
        }
        currentQuestion += 1
        answer = ""
        if currentQuestion > questions.count - 1 {
            gameTextDetail = "Your score is : \(score) out of \(questions.count). "
            showCircleDetail = true
            endGame()
        }
        listOfDidAnsweredQuestions = questions.reversed()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/* Challenge
 Before we proceed onto more complex projects, it’s important you have lots of time to stop and use what you already have. So, today you have a new project to make entirely by yourself, with no help from me other than some hints below. Are you ready?
 
 Your goal is to build an “edutainment” app for kids to help them practice multiplication tables – “what is 7 x 8?” and so on. Edutainment apps are educational at their code, but ideally have enough playfulness about them to make kids want to play.
 
 Breaking it down:
 
 The player needs to select which multiplication tables they want to practice. This could be pressing buttons, or it could be an “Up to…” stepper, going from 2 to 12.
 The player should be able to select how many questions they want to be asked: 5, 10, or 20.
 You should randomly generate as many questions as they asked for, within the difficulty range they asked for.
 If you want to go fully down the “education” route then this is going to be some steppers, a text field and a couple of buttons. I would suggest that’s a good place to start, just to make sure you have the basics covered.
 
 Once you have that, it’s down to you how far you want to take the app down the “entertainment” route – you could throw away fixed controls like Stepper entirely if you wanted, and instead rely on colorful buttons to get the same result.
 
 This is one of those challenges that is best approached step by step: get something working first, then improve it as far as you want. Maybe you’re happy with a simple app, or maybe you really want to spend some time crafting a fun design. It’s down to you!
 
 Important: It’s really easy to get sucked into these challenges and spend hours fighting with a particular bug that only exists because you wanted to get an exact effect. Don’t overload yourself with work, because you’ll just burn out! Instead, start with the simplest possible code that works, then build up slowly.
 
 If you have lots of time on your hands, you could use something like Kenney’s Animal Pack (which is public domain, by the way!) to add a fun theme to make it into a real game. Don’t be afraid to add some animations, too – it needs to appeal to kids 9 and under, so bright and colorful is a good idea!
 
 To solve this challenge you’ll need to draw on skills you learned in all the projects so far, but if you start small and work your way forward you stand the best chance of success. At its core this isn’t a complicated app, so get the basics right and expand only if you have the time.
 
 At the very least, you should:
 
 Start with an App template, then add some state to determine whether the game is active or whether you’re asking for settings.
 Generate a range of questions based on the user’s settings.
 Show the player how many questions they got correct at the end of the game, then offer to let them play again.
 Once you have your code working, try and see if you can break up your layouts into new SwiftUI views rather than putting everything in ContentView. This requires passing data between views, which isn’t something we’ve covered in detail yet, so in the meantime send data using closures – the button action from your settings view would call a function passed in by the parent view that starts the game with the user’s settings, for example.
 
 I’m going to provide some hints below, but I suggest you try to complete as much of the challenge as you can before reading them.
 
 Hints:
 
 You should generate all your questions as soon as your game starts, storing them as an array of questions.
 Those questions should probably be their own Swift struct, Question, storing the text and the answer.
 When it comes to asking questions, use another state property called questionNumber or similar, which is an integer pointing at some position in your question array.
 You can get user input either using buttons on the screen, like a calculator, or using a number pad text field – whichever you prefer.
 If you intend to pass a closure into a view’s initializer for later use, Xcode will force you to mark it as @escaping. This means “will be used outside of the current method.”
 At its simplest, this is not a hard app to build. Get that core right – get the fundamental logic of what you’re trying to do – then think about how to bring it to life. Yes, I know that part is the fun part, but ultimately this app needs to be useful, and it’s better to get the core working than try for everything at once and find you get bored part-way through.
 */
