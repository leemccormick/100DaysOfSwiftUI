//
//  AddView.swift
//  Day37_iExpensePart2
//
//  Created by Lee McCormick on 4/6/22.
//

import SwiftUI

struct AddView: View {
    // So, what we’re going to do is add a property to AddView to store an Expenses object. It won’t create the object there, which means we need to use @ObservedObject rather than @StateObject.
    @ObservedObject var expenses: Expenses
    
    // First, dismissing AddView is done by calling dismiss() on the environment when the time is right. This is controlled by the view’s environment, and links to the isPresented parameter for our sheet – that Boolean gets set to true by us to show AddView, but will be flipped back to false by the environment when we call dismiss().
    @Environment(\.dismiss) var dismissAddView
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar {
                // We need to put those two things together: we need a button that, when tapped, creates an ExpenseItem out of our properties and adds it to the expenses items.
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
                    // You’ll notice we don’t specify a type for that – Swift can figure it out thanks to the @Environment property wrapper. Next, we need to call dismiss() when we want the view to dismiss itself. This causes the showingAddExpense Boolean in ContentView to go back to false, and hides the AddView. We already have a Save button in AddView that creates a new expense item and appends it to our existing expenses, so add this on the line directly after:
                    dismissAddView()
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        // AddView() ==> The compilation failure happens because when we made the new SwiftUI view, Xcode also added a preview provider so we can look at the design of the view while we were coding. If you find that down at the bottom of AddView.swift, you’ll see that it tries to create an AddView instance without providing a value for the expenses property. That isn’t allowed any more, but we can just pass in a dummy value instead, like this:
        AddView(expenses: Expenses())
    }
}
