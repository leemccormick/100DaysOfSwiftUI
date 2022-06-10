//
//  iExpenseContentView.swift
//  Day76_Accessibility_WrapUp
//
//  Created by Lee McCormick on 6/9/22.
//

import SwiftUI

/*
 *** Challenge ***
 2) Fix the list rows in iExpense so they read out the name and value in one single VoiceOver label, and their type in a hint.
 */

struct iExpenseContentView: View {
    @StateObject private var expense = Expense()
    @State private var showingAddView = false
    
    var body: some View {
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
                            Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                                .foregroundColor(item.amount < 10 ? .purple : item.amount < 100 ? .orange : .red)
                                .fontWeight(item.amount < 100 ? .light : .bold)
                            
                        }
                        // Challenge  2 : Fix the list rows in iExpense so they read out the name and value in one single VoiceOver label, and their type in a hint.
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("\(item.name). Expense's type is  \(item.type). It cost \(item.amount) dollars.")
                        
                    }
                    .onDelete(perform: removeItems)
                }
            }
        }
        .navigationTitle("iExpense Wrap Up")
        .toolbar {
            Button() {
                showingAddView = true
            } label: {
                Image(systemName: "plus")
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
}

struct iExpenseContentView_Previews: PreviewProvider {
    static var previews: some View {
        iExpenseContentView()
    }
}

