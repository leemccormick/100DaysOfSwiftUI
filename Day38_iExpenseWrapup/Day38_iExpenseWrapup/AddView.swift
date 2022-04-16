//
//  AddView.swift
//  Day38_iExpenseWrapup
//
//  Created by Lee McCormick on 4/7/22.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismissAddView
    @ObservedObject var expense: Expense
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    let types = ["Personal", "Business"]
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach (types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currencyCode ?? "USD")) // Challenge 1 ==> Use the user’s preferred currency, rather than always using US dollars. Use the user’s preferred currency, rather than always using US dollars.
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add New Expense")
            .toolbar {
                Button("Save") {
                    let newExpense = ExpeneseItem(name: name, type: type, amount: amount)
                    expense.items.append(newExpense)
                    dismissAddView()
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expense: Expense())
    }
}
