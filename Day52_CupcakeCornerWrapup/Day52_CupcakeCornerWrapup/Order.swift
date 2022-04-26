//
//  Order.swift
//  Day52_CupcakeCornerWrapup
//
//  Created by Lee McCormick on 4/21/22.
//

import Foundation

/* Challenge 3 : For a more challenging task, see if you can convert our data model from a class to a struct, then create an ObservableObject class wrapper around it that gets passed around. This will result in your class having one @Published property, which is the data struct inside it, and should make supporting Codable on the struct much easier.
 */

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
    var hasValidAddress : Bool { // Challenge 1 : Improve the validation to make sure a string of pure whitespace is invalid.
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

/* *** This code before challenge 3 ***
class Order : ObservableObject, Codable {
    let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    @Published var type = 0
    @Published var quantity = 2
    @Published var specialRequest = false {
        didSet {
            extraFrosting = false
            specialSprinkles = false
        }
    }
    @Published var extraFrosting = false
    @Published var specialSprinkles = false
    
    @Published var name = ""
    @Published var street  = ""
    @Published var city  = ""
    @Published var zip  = ""
    
    var hasValidAddress : Bool { // Challenge 1 : Improve the validation to make sure a string of pure whitespace is invalid.
        if name.trimmingCharacters(in: .whitespaces).isEmpty || street.trimmingCharacters(in: .whitespaces).isEmpty || city.trimmingCharacters(in: .whitespaces).isEmpty || zip.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        return true
    }
    
    var cost : Double {
        var cost = Double(quantity) * 2.0
        cost += cost * Double(type)
        if extraFrosting {
            cost += Double(quantity)
        }
        if specialSprinkles {
            cost += Double(quantity) / 2
        }
        return cost
    }
    
    enum CodingKeys: CodingKey{
        case type, quantity, extraFrosting, specialSprinkles, name, street, city, zip
    }
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        quantity = try container.decode(Int.self, forKey: .quantity)
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        specialSprinkles = try container.decode(Bool.self, forKey: .specialSprinkles)
        name = try container.decode(String.self, forKey: .name)
        street = try container.decode(String.self, forKey: .street)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(specialSprinkles, forKey: .specialSprinkles)
        try container.encode(name, forKey: .name)
        try container.encode(street, forKey: .street)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
    }
}
*/
