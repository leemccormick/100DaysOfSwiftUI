import Cocoa
import Foundation

var greeting = "Hello, playground"

// Day 2 - 100 Days Of SwiftUI : 03/02/2022
// How to store truth with Booleans

let filename = "paris.jpg"
print(filename.hasSuffix(".jpg"))

let number = 120
print(number.isMultiple(of: 3))

let goodDogs = true
let gameOver = false

let isMultiple = 120.isMultiple(of: 3)

var isAuthenticated = false
isAuthenticated = !isAuthenticated
print(isAuthenticated)
isAuthenticated = !isAuthenticated
print(isAuthenticated)

var gameOverAgain = false
print(gameOverAgain)

gameOverAgain.toggle()
print(gameOverAgain)

// How to join string together

let firstPart = "Hello, "
let secondPart = "world!"
let greetingAgain = firstPart + secondPart

let people = "Haters"
let action = "hate"
let lyric = people + " gonna " + action
print(lyric)

let luggageCode = "1" + "2" + "3" + "4" + "5"

let quote = "Then he tapped a sign saying \"Believe\" and walked away."

// String interpolation is much more efficient than using + to join strings one by one, but there’s another important benefit too: you can pull in integers, decimals, and more with no extra work.

let name = "Taylor"
let age = 26
let message = "Hello, my name is \(name) and I'm \(age) years old."
print(message)

let numberAgain = 11
// let missionMessage = "Apollo " + numberAgain + " landed on the moon."
let missionMessage = "Apollo " + "\(numberAgain)" + " landed on the moon."
let missionMessageAgain = "Apollo " + String(numberAgain) + " landed on the moon."
let missionMessageAgainAgain = "Apollo \(number) landed on the moon."

// Tip: You can put calculations inside string interpolation if you want to. For example, this will print “5 x 5 is 25”:
print("5 x 5 is \(5 * 5)")

// Why does Swift have string interpolation?
// Tip: String interpolation is extremely powerful in Swift. If you’re keen to see just what it can do, check out this more advanced blog post from me:
// https://www.hackingwithswift.com/articles/178/super-powered-string-interpolation-in-swift-5-0
// String interpolation has been around since the earliest days of Swift, but in Swift 5.0 it’s getting a massive overhaul to make it faster and more powerful.
var city = "Cardiff"
var messageCity = "Welcome to \(city)!"

// Swift 5 String interpolation
// Basic
let ageAgain = 38
print("You are \(ageAgain)")
var user: String?
user = "Lee"
print("Hi, \(user ?? "Anonymous")")

// Swift5 With this extention
extension String.StringInterpolation {
    mutating func appendInterpolation(format value: Int) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        
        if let result = formatter.string(from: value as NSNumber) {
            appendLiteral(result)
        }
    }
    
    
    mutating func appendInterpolation(_ value: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        
        let dateString = formatter.string(from: value)
        appendLiteral(dateString)
    }
    
    // Interpolation with parameters
    //  That small change shows how we have complete control over the way string interpolation handles parameters. You see, appendInterpolation() so that we can handle various different data types in unique ways.
    mutating func appendInterpolation(twitter: String) {
        appendLiteral("<a href=\"https://twitter.com/\(twitter)\">@\(twitter)</a>")
    }
    
    mutating func appendInterpolation(format value: Int, using style: NumberFormatter.Style) {
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        
        if let result = formatter.string(from: value as NSNumber) {
            appendLiteral(result)
        }
    }
    
    mutating func appendInterpolation(_ values: [String], empty defaultValue: @autoclosure () -> String) {
        if values.count == 0 {
            appendLiteral(defaultValue())
        } else {
            appendLiteral(values.joined(separator: ", "))
        }
    }
    
    mutating func appendInterpolation<T: Encodable>(debug value: T) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        if let result = try? encoder.encode(value) {
            let str = String(decoding: result, as: UTF8.self)
            appendLiteral(str)
        }
    }
}

let ageSwift5 = 38
print("You are \(ageSwift5)")
print("Today's date is \(Date()).")
print("Hi, I'm \(format: ageSwift5).")
print("You should follow me on Twitter: \(twitter: "twostraws").")
print("Hi, I'm \(format: age, using: .spellOut).")

let names = ["Malcolm", "Jayne", "Kaylee"]
print("Crew: \(names, empty: "No one").")

// Using @autoclosure means that we can use simple values or call complex functions for the default value.
extension Array where Element == String {
    func formatted(empty defaultValue: @autoclosure () -> String) -> String {
        if count == 0 {
            return defaultValue()
        } else {
            return self.joined(separator: ", ")
        }
    }
}

print("Crew: \(names.formatted(empty: "No one")).")

extension String.StringInterpolation {
    mutating func appendInterpolation(if condition: @autoclosure () -> Bool, _ literal: StringLiteralType) {
        guard condition() else { return }
        appendLiteral(literal)
    }
}

let doesSwiftRock = true
print("Swift rocks: \(if: doesSwiftRock, "(*)")")
print("Swift rocks \(doesSwiftRock ? "(*)" : "")")


// Adding interpolations for custom types
struct Person {
    var type: String
    var action: String
}

extension String.StringInterpolation {
    mutating func appendInterpolation(_ person: Person) {
        appendLiteral("I'm a \(person.type) and I'm gonna \(person.action).")
    }
}

let hater = Person(type: "hater", action: "hate")
print("Status check: \(hater)")
print(hater)

// We can even combine that custom type with the multiple parameters from earlier:
extension String.StringInterpolation {
    mutating func appendInterpolation(_ person: Person, count: Int) {
        let action = String(repeating: "\(person.action) ", count: count)
        appendLiteral("\n\(person.type.capitalized)s gonna \(action)")
    }
}

let player = Person(type: "player", action: "play")
let heartBreaker = Person(type: "heart-breaker", action: "break")
let faker = Person(type: "faker", action: "fake")

print("Let's sing: \(player, count: 5) \(hater, count: 5) \(heartBreaker, count: 5) \(faker, count: 5)")
// print("Here's some data: \(debug: faker)")
// print(try "Status check: \(debug: hater)")

// Building types with interpolation
/*
 To demonstrate this we’re going to design a new type that can be instantiated from a string using interpolation. So, we’re going to make a type that creates attributed strings in various colors, all using string interpolation:
 */

var interpolation = ColoredString.StringInterpolation(literalCapacity: 10, interpolationCount: 1)

interpolation.appendLiteral("Hello")
// interpolation.appendInterpolation(message: "Hello", color: .red)
interpolation.appendLiteral("Hello")

let valentine = ColoredString(stringInterpolation: interpolation)
struct ColoredString: ExpressibleByStringInterpolation {
    // this nested struct is our scratch pad that assembles an attributed string from various interpolations
    struct StringInterpolation: StringInterpolationProtocol {
        // this is where we store the attributed string as we're building it
        var output = NSMutableAttributedString()
        
        // some default attribute to use for text
        var baseAttributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Georgia-Italic", size: 64) ?? .systemFont(ofSize: 64), .foregroundColor: UIColor.black]
        
        // this initializer is required, and can be used as a performance optimization
        init(literalCapacity: Int, interpolationCount: Int) { }
        
        // called when we need to append some raw text
        mutating func appendLiteral(_ literal: String) {
            // print it out so you can see how it's called at runtime
            print("Appending \(literal)")
            
            // give it our base styling
            let attributedString = NSAttributedString(string: literal, attributes: baseAttributes)
            
            // add it to our scratchpad string
            output.append(attributedString)
        }
        
        // called when we need to append a colored message to our string
        mutating func appendInterpolation(message: String, color: UIColor) {
            // print it out again
            print("Appending \(message)")
            
            // take a copy of our base attributes and apply the color
            var coloredAttributes = baseAttributes
            coloredAttributes[.foregroundColor] = color
            
            // wrap it in a new attributed string and add it to our scratchpad
            let attributedString = NSAttributedString(string: message, attributes: coloredAttributes)
            output.append(attributedString)
        }
    }
    
    // the final attributed string, once all interpolations have finished
    let value: NSAttributedString
    
    // create an instance from a literal string
    init(stringLiteral value: String) {
        self.value = NSAttributedString(string: value)
    }
    
    // create an instance from an interpolated string
    init(stringInterpolation: StringInterpolation) {
        self.value = stringInterpolation.output
    }
}

/*
 Wrap up
 As you’ve seen, custom string interpolation lets us wrap up formatting code in one place, so we can keep our call sites clear. At the same time, it also delivers extraordinarily flexibility for us to create types in a really natural way.
 
 Remember, this is only one tool in our toolbox – it's not our only tool. That means sometimes you'll use interpolation, other times functions, and other times something else. Like many things in programming, the key is to be pragmatic: to make choices on a case-by-case basis.
 
 At the same time, this feature is also extremely new, so I really look forward to seeing what folks build with it once Swift 5.0 ships as final.
 
 Speaking of Swift 5.0, string interpolation is just one of many great new features coming in Swift 5.0 – check out my site
 */
// now try it out!
// let str: ColoredString = "\(message: "Red", color: .red), \(message: "White", color: .white), \(message: "Blue", color: .blue)"

// Summary Simple Data
/*
 - Swift lets us create constants using let, and variables using var.
 - If you don’t intend to change a value, make sure you use let so that Swift can help you avoid mistakes.
 - Swift’s strings contain text, from short strings up to whole novels. They work great with emoji and any world language, and have helpful functionality such as count and uppercased().
 - You create strings by using double quotes at the start and end, but if you want your string to go over several lines you need to use three double quotes at the start and end.
 - Swift calls its whole numbers integers, and they can be positive or negative. They also have helpful functionality, such as isMultiple(of:).
 - In Swift decimal numbers are called Double, short for double-length floating-point number. That means they can hold very large numbers if needed, but they also aren’t 100% accurate – you shouldn’t use them when 100% precision is required, such as when dealing with money.
 - There are lots of built-in arithmetic operators, such as +, -, *, and /, along with the special compound assignment operators such as += that modify variables directly.
 - You can represent a simple true or false state using a Boolean, which can be flipped using the ! operator or by calling toggle().
 - String interpolation lets us place constants and variables into our strings in a streamlined, efficient way.
 */

// Checkpoint 1
/*
 
 Your goal is to write a Swift playground that:
 
 1) Creates a constant holding any temperature in Celsius.
 2) Converts it to Fahrenheit by multiplying by 9, dividing by 5, then adding 32.
 3) Prints the result for the user, showing both the Celsius and Fahrenheit values.
 
 - Use let to make your constant. You can call it whatever you want, but I think celsius would be an appropriate name.
 - Celsius is commonly stored as a decimal, so make sure and create it as one. This might mean adding “.0” to the end – using 25.0 rather than 25, for example.
 - We use * for multiplication and / for division.
 - Use \(someVariable) to activate string interpolation.
 If you want to get fancy with print(), you can use Option+Shift+8 to get the degrees symbol: °. This means you can write something like 25°F.
 */

let tempInCelsius: Double = 35
let tempInFahrenheit: Double = ((tempInCelsius * 9) / 5) + 32

func toFahrenheit(c: Double) -> Double {
    return Double(((c * 9) / 5) + 32)
}

let newTempInFahrenheit = toFahrenheit(c: 20)
print("newTempInFahrenheit : \(newTempInFahrenheit)°")
print("tempInCelsius : \(tempInCelsius)°")
print("tempInFahrenheit : \(tempInFahrenheit)°")
