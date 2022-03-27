//
//  ContentView.swift
//  Day24_WeSplit_Review
//
//  Created by Lee McCormick on 3/24/22.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocus: Bool
    let tipPercentages = [0, 10, 20, 25]
    let currentCountyCode = Locale.current.currencyCode ?? "US"
    var totalAmountForCheck: Double {
        return checkAmount + (checkAmount * Double(tipPercentage) / 100)
    }
    var totalPerPerson: Double {
        return (checkAmount + (checkAmount * Double(tipPercentage) / 100)) / Double(numberOfPeople + 2)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: currentCountyCode))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocus)
                    
                    Picker("Number of People", selection: $numberOfPeople) {
                        ForEach (2..<100) {
                            Text("\($0) people")
                        }
                    }
                }
                Section {
                    Picker("Tip Percentages", selection: $tipPercentage) {
                        ForEach (tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("More option for tip", selection: $tipPercentage) {
                        ForEach (0..<101) {
                            Text($0, format: .percent)
                        }
                    }
                } header: {
                    Text("How much tip do you want to leave?")
                        .foregroundColor(tipPercentage == 0 ?.red : .black)
                }
                Section {
                    Text(totalPerPerson, format: .currency(code: currentCountyCode))
                        .foregroundColor(tipPercentage == 0 ?.red : .black)
                } header: {
                    Text("Amount per person")
                        .foregroundColor(tipPercentage == 0 ?.red : .black)
                }
                Section {
                    Text(totalAmountForCheck, format: .currency(code: currentCountyCode))
                        .foregroundColor(tipPercentage == 0 ? .red : .black)
                } header: {
                    Text("Total amount for check")
                        .foregroundColor(tipPercentage == 0 ?.red : .black)
                }
            }
            .navigationTitle("WeSpilt Review")
            .toolbar {
                ToolbarItemGroup {
                    Spacer()
                    Button("Done") {
                        amountIsFocus = false
                    }
                }
            }
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
