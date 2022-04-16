//
//  ContentView.swift
//  Day38_iExpenseWrapup
//
//  Created by Lee McCormick on 4/7/22.
//

import SwiftUI

/*
 Challenge
 1) Use the user’s preferred currency, rather than always using US dollars.
 2) Modify the expense amounts in ContentView to contain some styling depending on their value – expenses under $10 should have one style, expenses under $100 another, and expenses over $100 a third style. What those styles are depend on you.
 3) For a bigger challenge, try splitting the expenses list into two sections: one for personal expenses, and one for business expenses. This is tricky for a few reasons, not least because it means being careful about how items are deleted!
 */

struct ContentView: View {
    
    @StateObject private var expense = Expense()
    @State private var showingAddView = false
    
    var body: some View {
        NavigationView {
            List {
                
                let sections = getSection(expense: expense)
                
                ForEach (sections, id: \.self) { s in
                    
                    Section(s) {
                        ForEach (expense.items) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.name)
                                    Text(item.type)
                                }
                                Spacer()
                                
                                Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD")) // Challenge 1
                                    .foregroundColor(item.amount < 10 ? .purple : item.amount < 100 ? .orange : .red)
                                    .fontWeight(item.amount < 100 ? .light : .bold) // Challenge 2
                               
                            }
                        }
                        .onDelete(perform: removeItems)
                    }
                }
                
               /* ForEach (expense.items) { item in
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                            Text(item.type)
                        }
                        Spacer()
                        
                        Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD")) // Challenge 1
                            .foregroundColor(item.amount < 10 ? .purple : item.amount < 100 ? .orange : .red)
                            .fontWeight(item.amount < 100 ? .light : .bold) // Challenge 2
                       
                    }
                }
                .onDelete(perform: removeItems)*/
            }
            .navigationTitle("iExpense Wrap Up")
            .toolbar {
                Button() {
                    showingAddView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddView) {
            AddView(expense: expense)
        }
    }
    
    func removeItems(at offSet: IndexSet) {
        expense.items.remove(atOffsets: offSet)
    }
    
    func getSection(expense : Expense) -> [String] {
        var expenseTypes: [String] = []
        for item in expense.items {
            expenseTypes.append(item.type)
        }
        return Array(Set(expenseTypes))
    }
    
    func getSection(expense : Expense) -> [String] {
        var expenseTypes: [String] = []
        for item in expense.items {
            expenseTypes.append(item.type)
        }
        return Array(Set(expenseTypes))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/* Project 7, part 3
 That’s another project done, and another massive amount of Swift and SwiftUI knowledge covered. There are more projects to cover, but as F1 racer Sebastian Vettel once said, “sometimes you need to press pause to let everything sink in.”
 
 Today is your chance to press pause and let SwiftUI sink in. Complete the review, take the challenges, and, if you need to, go back to previous consolidation day challenges and work on them.
 
 So many people email me with questions like “how fast can I learn app development?” and honestly I feel sorry for them. You can’t learn when you rush. The two goals are incompatible with your brain. Focused learning is when we actively consume information through studying and that’s really important, but diffuse learning is when we stop studying and let our brain passively make connections between what we already studied. Taking a break, sleeping, or working on something else for a while are all important parts of the process.
 
 So, if you’re keen to rush ahead to tomorrow’s new project, please follow Vettel’s advice: press pause and let everything sink in.
 
 Today you should work through the wrap up chapter for project 7, complete its review, then work through all three of its challenges.
 
 iExpense: Wrap up
 Review for Project 7: iExpense
 */

/* iExpense: Wrap up
 Although the app we were building wasn’t itself difficult, getting there took quite a bit of learning – we had to cover UserDefaults, Codable, sheet(), onDelete(), @StateObject, and more. Some of those things – particularly UserDefaults and Codable – have only been introduced at a high level in this project, which is intentional; we’ll be getting into them more later on.
 
 Now that your SwiftUI skills are coming along, I hope you noticed we were able to skip past some parts with very little explanation. For example, you know very well how to create forms with text fields and pickers because we’ve already covered that extensively, which means we can spend our time focusing on new stuff.
 
 Review what you learned
 Anyone can sit through a tutorial, but it takes actual work to remember what was taught. It’s my job to make sure you take as much from these tutorials as possible, so I’ve prepared a short review to help you check your learning.
 
 Click here to review what you learned in this project.
 
 Challenge
 - One of the best ways to learn is to write your own code as often as possible, so here are three ways you should try extending this app to make sure you fully understand what’s going on.
 
 1) Use the user’s preferred currency, rather than always using US dollars.
 2) Modify the expense amounts in ContentView to contain some styling depending on their value – expenses under $10 should have one style, expenses under $100 another, and expenses over $100 a third style. What those styles are depend on you.
 3) For a bigger challenge, try splitting the expenses list into two sections: one for personal expenses, and one for business expenses. This is tricky for a few reasons, not least because it means being careful about how items are deleted!
 */
