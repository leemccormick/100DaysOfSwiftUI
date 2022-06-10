//
//  Order.swift
//  Day76_Accessibility_WrapUp
//
//  Created by Lee McCormick on 6/9/22.
//

import Foundation

struct CupCakeOrder : Codable {
    var type = 0
    var quantity = 2
    var specialRequest = false {
        didSet {
            extraFrosting = false
            specialSprinkles = false
        }
    }
    var extraFrosting = false
    var specialSprinkles = false
    var name = ""
    var street  = ""
    var city  = ""
    var zip  = ""
}

class Order : ObservableObject  {
    let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    @Published var cupCakeOrder = CupCakeOrder()
    var hasValidAddress : Bool {
        if cupCakeOrder.name.trimmingCharacters(in: .whitespaces).isEmpty || cupCakeOrder.street.trimmingCharacters(in: .whitespaces).isEmpty || cupCakeOrder.city.trimmingCharacters(in: .whitespaces).isEmpty || cupCakeOrder.zip.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        return true
    }
    
    var cost : Double {
        var cost = Double(cupCakeOrder.quantity) * 2.0
        cost += cost * Double(cupCakeOrder.type)
        if cupCakeOrder.extraFrosting {
            cost += Double(cupCakeOrder.quantity)
        }
        if cupCakeOrder.specialSprinkles {
            cost += Double(cupCakeOrder.quantity) / 2
        }
        return cost
    }
}
