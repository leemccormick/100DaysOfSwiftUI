//
//  ContentView.swift
//  Day18_WeSpiltPart3
//
//  Created by Lee McCormick on 3/18/22.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocus: Bool
    let tipPercentages = [0, 10, 20, 25]
    let currencyCode = Locale.current.currencyCode ?? "USA"
    var totalAmountForCheck: Double {
        return checkAmount + (checkAmount * Double(tipPercentage) / 100)
    }
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount * tipSelection / 100
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        return amountPerPerson
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: currencyCode))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocus)
                    
                    Picker("Number Of People", selection: $numberOfPeople) {
                        ForEach (2..<100) {
                            Text("\($0) people")
                        }
                    }
                }
                
                Section {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        ForEach (tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("More Option For Tip", selection: $tipPercentage) {
                        ForEach (0..<101) {
                            Text($0, format: .percent)
                        }
                    }
                } header: {
                    Text("How much tip do you want to leave ?")
                }
                
                Section {
                    Text(totalPerPerson, format: .currency(code: currencyCode))
                } header: {
                    Text("Amount Per Person")
                }
                
                Section {
                    Text(totalAmountForCheck, format: .currency(code: currencyCode))
                } header: {
                    Text("Total Amount For Check")
                }
            }
            .navigationBarTitle("WeSpilt Part3")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
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
 You’ve reached the end of your first SwiftUI app: good job! We’ve covered a lot of ground, but I’ve also tried to go nice and slowly to make sure it all sinks in – we’ve got lots more to cover in future projects, so taking a little extra time now is OK.
 
 In this project you learn about the basic structure of SwiftUI apps, how to build forms and sections, creating navigation views and navigation bar titles, how to store program state with the @State and @FocusState property wrappers, how to create user interface controls like TextField and Picker, and how to create views in a loop using ForEach. Even better, you have a real project to show off for your efforts.
 
 - Review what you learned
 Anyone can sit through a tutorial, but it takes actual work to remember what was taught. It’s my job to make sure you take as much from these tutorials as possible, so I’ve prepared a short review to help you check your learning.
 
 *** Challenge ***
 - One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on:
 
 - Add a header to the third section, saying “Amount per person”
 - Add another section showing the total amount for the check – i.e., the original amount plus tip value, without dividing by the number of people.
 - Change the tip percentage picker to show a new screen rather than using a segmented control, and give it a wider range of options – everything from 0% to 100%. Tip: use the range 0..<101 for your range rather than a fixed array.
 
 - And if you found those easy, here’s a tough one for you: rather than having to type .currency(code: Locale.current.currencyCode ?? "USD") in two places, can you make a new property to store the currency formatter? You’ll need to give your property a specific return type in order to keep the rest of your code happy: FloatingPointFormatStyle<Double>.Currency.
 
 - You can find that for yourself using Xcode’s Quick Help window – open up the right-hand navigator, then select the Quick Help inspector, and finally click select the .currency code. You’ll see Xcode displays <Value> rather than <Double>, because this thing is able to display other kinds of floating-point numbers too, but here we need Double.
 */
