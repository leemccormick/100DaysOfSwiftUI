//
//  ContentView.swift
//  Day28_BetterRestPart3
//
//  Created by Lee McCormick on 3/28/22.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 0
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    static var defaultWakeTime : Date {
        var commponents = DateComponents()
        commponents.hour = 7
        commponents.minute = 0
        return Calendar.current.date(from: commponents) ?? Date.now
    }
    
    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .center, spacing: 5) {
                    Text("\(alertTitle)")
                        .font(.subheadline)
                    Text("\(alertMessage)")
                        .font(.headline)
                }
                Section {
                    DatePicker("Please enter a time", selection:  $wakeUp,
                               displayedComponents: .hourAndMinute)
                        .labelsHidden()
                } header: {
                    Text("When do you want to wake up?")
                }
                
                Section  {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                } header: {
                    Text("Desired amount of sleep")
                }
                
                Section  {
                    Picker("Number Of Cups", selection: $coffeeAmount) {
                        ForEach (0..<21) {
                            Text("\($0) cups")
                        }
                    }
                } header: {
                    Text("Daily coffee intake")
                }
            }
            .navigationTitle("Better Rest")
            .toolbar {
                Button("Calculate", action: calculateBedTime)
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") {
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            let predition = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - predition.actualSleep
            alertTitle = "Your idea bedtime is ..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error !"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*
 This project was a chance for you to practice some fundamentals of SwiftUI, learn some new UI controls with DatePicker and Stepper, see for yourself how Swift makes it easy to handle dates, and – just for fun – dip your toe into the world of machine learning.
 
 All these things work independently of each other, by which I mean you can now use Stepper, or DateComponents, or Create ML all by themselves, in other projects – the stuff you’ve learned can be taken anywhere you want. As you progress with SwiftUI you’ll add more and more of these jigsaw pieces, and in doing so you’ll find you soon have hundreds of pieces that you can rearrange and build together to make remarkable things.
 
 One of my favorite Steve Jobs quotes is this:
 
 “Creativity is just connecting things. When you ask creative people how they did something, they feel a little guilty because they didn't really do it, they just saw something. It seemed obvious to them after a while. That's because they were able to connect experiences they've had and synthesize new things.”
 
 That’s where I want you to reach with SwiftUI – to know that when you have a new project idea you can reach for part of project 1, part of project 3, part of project 4, and beyond, and already be 75% towards your goal. You’ll get there – just keep coming back each day!
 
 Today you should work through the wrap up chapter for project 4, complete its review, then work through all three of its challenges.
 
 BetterRest: Wrap up
 Review for Project 4: BetterRest
 Good job!
 */

/* BetterRest: Wrap up
 This project gave you the chance to get some practice with forms and bindings, while also introducing you to DatePicker, Stepper, Date, DateComponents, and more, while also seeing how to place buttons into the navigation bar – these are things you’ll be using time and time again, so I wanted to get them in nice and early.
 
 Of course, I also took the chance to give you a glimpse of some of the incredible things we can build using Apple’s frameworks, all thanks to Create ML and Core ML. As you saw, these frameworks allow us to take advantage of decades of research and development in machine learning, all using a drag and drop user interface and a couple of lines of code – it really couldn’t be any easier.
 
 The truly fascinating thing about machine learning is that it doesn’t need big or clever scenarios to be used. You could use machine learning to predict used car prices, to figure out user handwriting, or even detect faces in images. And most importantly of all, the entire process happens on the user’s device, in complete privacy.
 
 Review what you learned
 Anyone can sit through a tutorial, but it takes actual work to remember what was taught. It’s my job to make sure you take as much from these tutorials as possible, so I’ve prepared a short review to help you check your learning.
 
 Click here to review what you learned in this project.
 
 Challenge
 - One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on:
 
 1) Replace each VStack in our form with a Section, where the text view is the title of the section. Do you prefer this layout or the VStack layout? It’s your app – you choose!
 2) Replace the “Number of cups” stepper with a Picker showing the same range of values.
 3) Change the user interface so that it always shows their recommended bedtime using a nice and large font. You should be able to remove the “Calculate” button entirely.
 */
