import Cocoa

// Day 1 - 100 Days Of SwiftUI : 03/01/2022
// How to create constants and variable

var greeting = "Hello, playground"
var day1 = "I am on Day 1 in 100 days Of SwiftUI"

var name = "Lee"
name = "MuayLy"
name = "Tittaporn"

let character = "aaaaa" // Constanst can not change

var nickName = "News"
print(nickName)

nickName = "Night"
print(nickName)

nickName = "Lyn"
print(nickName)

let managerName = "Admin"
let meaningOfLife = "Coding to build something for the world."

// Why does swift have variables?
let infoFromPualHudson = "Variables allow us to store temporary information in our program, and form a key part of almost every Swift program. Ultimately, your program is going to transform data somehow: maybe you let the user enter in todo list tasks then check them off, maybe you let them roam around a deserted island working for a capitalist raccoon, or maybe you read the device time and display it in a clock. Regardless, you’re taking some sort of data, transforming it somehow, and showing it to the user."

var favoriteShow = "Orange is the New Black"
favoriteShow = "The Good Place"
favoriteShow = "Doctor Who"

// Why does swift have constants as well as variable?
let whyConstants = "Swift really loves constants, and in fact will recommend you use one if you created a variable then never changed its value. The reason for this is about avoiding problems: any variable you create can be changed by you whenever you want and as often as you want, so you lose some control – that important piece of user data you stashed away might be removed or replaced at any point in the future."

// How to create strings
let testMutilines = """
A day of
learning swiftUI
Start with my first day
from the first day  of March 2022
"""
let actor = "Denzel Washington"
let filename = "paris.jpg"
let result = "⭐️ You win! ⭐️"
var quote = "Then he tapped a sign saying \"Believe\" and walked away."

/* Not acceptable in swift
let movie = "A day in
the life of an
Apple engineer"
 */
let movie = """
A day in
the life of an
Apple engineer
"""

print(actor.count)
let nameLength = actor.count
print(nameLength)
print(result.uppercased())
print(movie.hasPrefix("A day"))
print(filename.hasSuffix(".jpg"))

// Why does Swift need multi-line strings?

// Swift’s standard strings start and end with quotes, but must never contain any line breaks. For example, this is a standard string:
 quote = "Change the world by being yourself"

// That works fine for small pieces of text, but becomes ugly in source code if you have lots of text you want to store. That’s where multi-line strings come in: if you use triple quotes you can write your strings across as many lines as you need, which means the text remains easy to read in your code:
var burns = """
The best laid schemes
O’ mice and men
Gang aft agley
"""

// How to store whole numbers
let score = 10
let reallyBig = 100000000

// If we were writing that out by hand we’d probably write “100,000,000” at which point it’s clear that the number is 100 million. Swift has something similar: you can use underscores, _, to break up numbers however you want. So, we could change our previous code to this:
let reallyBigWithUnderscroll = 100_000_000
let reallyVeryBigBig = 1_00__00___00____00
let lowerScore = score - 2
let higherScore = score + 10
let doubledScore = score * 2
let squaredScore = score * score
let halvedScore = score / 2
print(score)


// Rather than writing counter = counter + 5, you can use the shorthand operator +=, which adds a number directly to the integer in question:
var counter = 10
counter = counter + 5
counter += 5
print(score)

// Before we’re done with integers, I want to mention one last thing: like strings, integers have some useful functionality attached. For example, you can call isMultiple(of:) on an integer to find out whether it’s a multiple of another integer.
let number = 120
print(number.isMultiple(of: 3))
print(110.isMultiple(of: 3))

// How to store decimal
let numberDecimal = 0.1 + 0.2
print(numberDecimal)

let a = 1
let b = 2.0
// let c = a + b
let c = a + Int(b)
let cc = Double(a) + b

let double1 = 3.1
let double2 = 3131.3131
let double3 = 3.0
let int1 = 3

var nameAgain = "Nicolas Cage"
nameAgain = "John Travolta"

var nameTest = "Nicolas Cage"
// nameTest = 57
 nameTest = String(57)

var rating = 5.0
rating *= 2

// Many older APIs use a slightly different way of storing decimal numbers, called CGFloat. Fortunately, Swift lets us use regular Double numbers everywhere a CGFloat is expected, so although you will see CGFloat appear from time to time you can just ignore it.

// Why does Swift need both Doubles and Integers?
let whyDoubleAndIntegers = "Swift gives us several different ways of storing numbers in our code, and they are designed to solve different problems. Swift doesn’t let us mix them together because doing so will (as in, 100% guaranteed) lead to problems."

// Why is Swift a type-safe language?
// Swift lets us create variables as strings and integers, but also many other types of data too. When you create a variable Swift can figure out what type the variable is based on what kind of data you assign to it, and from then on that variable will always have that one specific type.
let meaningOfLife42 = 42 // Int
// meaningOfLife42 = "Forty two"

