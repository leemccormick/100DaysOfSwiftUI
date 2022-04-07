//
//  Expense.swift
//  Day37_iExpensePart2
//
//  Created by Lee McCormick on 4/6/22.
//

import Foundation

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        // This takes four steps in total: we need to create an instance of JSONEncoder that will do the work of converting our data to JSON, we ask that to try encoding our items array, and then we can write that to UserDefaults using the key “Items”.
        didSet {
            if let encoded = try? JSONEncoder().encode(items) { // Tip: Using JSONEncoder().encode() means “create an encoder and use it to encode something,” all in one step, rather than creating the encoder first then using it later.
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    /* With that change, we’ve written all the code needed to make sure our items are saved when the user adds them. However, it’s not effective by itself: the data might be saved, but it isn’t loaded again when the app relaunches. To solve that – and also to make our code compile again – we need to implement a custom initializer. That will:
     1) Attempt to read the “Items” key from UserDefaults.
     2) Create an instance of JSONDecoder, which is the counterpart of JSONEncoder that lets us go from JSON data to Swift objects.
     3) Ask the decoder to convert the data we received from UserDefaults into an array of ExpenseItem objects.
     4) If that worked, assign the resulting array to items and exit.
     5) Otherwise, set items to be an empty array.
     Add this initializer to the Expenses class now:
     */
    init() {
        // The two key parts of that code are the data(forKey: "Items") line, which attempts to read whatever is in “Items” as a Data object, and try? JSONDecoder().decode([ExpenseItem].self, from: savedItems), which does the actual job of unarchiving the Data object into an array of ExpenseItem objects.
        if let savedItem = UserDefaults.standard.data(forKey: "Items") {
            
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItem) { //It’s common to do a bit of a double take when you first see [ExpenseItem].self – what does the .self mean? Well, if we had just used [ExpenseItem], Swift would want to know what we meant – are we trying to make a copy of the class? Were we planning to reference a static property or method? Did we perhaps mean to create an instance of the class? To avoid confusion – to say that we mean we’re referring to the type itself, known as the type object – we write .self after it.
                items = decodedItems
                return
            }
        }
        items = []
    }
}

/* We’re going to leverage four important technologies to help us save and load data in a clean way:
 - The Codable protocol, which will allow us to archive all the existing expense items ready to be stored.
 - UserDefaults, which will let us save and load that archived data.
 - A custom initializer for the Expenses class, so that when we make an instance of it we load any saved data from UserDefaults
 - A didSet property observer on the items property of Expenses, so that whenever an item gets added or removed we’ll write out changes.
 
 */
