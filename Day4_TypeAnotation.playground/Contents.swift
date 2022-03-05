import Cocoa

// Day 4 - 100 Days Of SwiftUI : 03/04/2022

// 1) How to use type annotations
// This uses type inference: Swift infers that surname is a string because we’re assigning text to it, and then infers that score is an integer because we’re assigning a whole number to it.
let surname = "Lasso"
var score = 0

// Type annotations let us be explicit about what data types we want, and look like this:
let surnameAnnotations: String = "Lasso"
var scoreAnnotations: Int = 0
var scoreDouble: Double = 0
let playerName: String = "Roy"
var luckyNumber: Int = 13
let pi: Double = 3.141
var isAuthenticated: Bool = true
var albums: [String] = ["Red", "Fearless"]
var user: [String: String] = ["id": "@twostraws"]
var books: Set<String> = Set(["The Bluest Eye", "Foundation", "Girl, Woman, Other"])
var soda: [String] = ["Coke", "Pepsi", "Irn-Bru"]
var teams: [String] = [String]()
var cities: [String] = []
var clues = [String]()

// As well as all those, there are enums. Enums are a little different from the others because they let us create new types of our own, such as an enum containing days of the week, an enum containing which UI theme the user wants, or even an enum containing which screen is currently showing in our app. Values of an enum have the same type as the enum itself, so we could write something like this:
enum UIStyle {
    case light, dark, system
}

var style = UIStyle.light

// The most common exception to this is with constants I don’t have a value for yet. You see, Swift is really clever: you can create a constant that doesn’t have a value just yet, later on provide that value, and Swift will ensure we don’t accidentally use it until a value is present. It will also ensure that you only ever set the value once, so that it remains constant.
let username: String
// lots of complex logic
username = "@twostraws"
// lots more complex logic
print(username)

// Why does swift have type annotatoions ?
/*
 1) Swift can’t figure out what type should be used.
 2) You want Swift to use a different type from its default.
 3) You don’t want to assign a value just yet.
*/

// Why would you want to create an empty collection ?
/*
Sometimes you don’t know all your data up front, and in those cases it’s more common to create an empty collection then add things as you calculate your data.
 For example, we have our fixed names array above, and if we wanted to figure out which names started with J then we would:
1) Creating an empty string array called something like jNames
2) Go over every name in the original names array and check whether it starts with “J”
3) If it does, add it to the jNames array.
 */

// 2) Summary : Complex data
/*
 - Arrays let us store lots of values in one place, then read them out using integer indices. Arrays must always be specialized so they contain one specific type, and they have helpful functionality such as count, append(), and contains().
 - Dictionaries also let us store lots of values in one place, but let us read them out using keys we specify. They must be specialized to have one specific type for key and another for the value, and have similar functionality to arrays, such as contains() and count.
 - Sets are a third way of storing lots of values in one place, but we don’t get to choose the order in which they store those items. Sets are really efficient at finding whether they contain a specific item.
 - Enums let us create our own simple types in Swift so that we can specify a range of acceptable values such as a list of actions the user can perform, the types of files we are able to write, or the types of notification to send to the user.
 - Swift must always know the type of data inside a constant or variable, and mostly uses type inference to figure that out based on the data we assign. However, it’s also possible to use type annotation to force a particular type.
 */

// 3) Checkpoint 2
// This time the challenge is to create an array of strings, then write some code that prints the number of items in the array and also the number of unique items in the array.
/*
 - You should start by creating an array of strings, using something like let albums = ["Red", "Fearless"]
 - You can read the number of items in your array using albums.count.
 - count also exists for sets.
 - Sets can be made from arrays using Set(someArray)
 - Sets never include duplicates.
 */

let namesAtCheckpoint = ["Lee", "Lyn", "Night", "New", "Lee"]
print(namesAtCheckpoint.count)
let namesUnique = Set(namesAtCheckpoint)
print(namesUnique.count)
