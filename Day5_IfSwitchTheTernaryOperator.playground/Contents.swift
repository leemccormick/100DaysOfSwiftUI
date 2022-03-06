import Cocoa

var greeting = "Hello, playground"

// Day 5 - 100 Days Of SwiftUI : 03/05/2022
// 1) How to check a condition is true or false
let someCondition = true
if someCondition {
    print("Do something")
}

if someCondition {
    print("Do something")
    print("Do something else")
    print("Do a third thing")
}

let score = 85

if score > 80 {
    print("Great job!")
}

let speed = 88
let percentage = 85
let age = 18

if speed >= 88 {
    print("Where we're going we don't need roads.")
}

if percentage < 85 {
    print("Sorry, you failed the test.")
}

if age >= 18 {
    print("You're eligible to vote")
}

let ourName = "Dave Lister"
let friendName = "Arnold Rimmer"
let leeName = "Lee McCormick"

if leeName > ourName && leeName > friendName {
    print("Lee is the best!")
}

print(" ourName < friendName : \( ourName < friendName)")
if ourName < friendName {
    print(ourName.count)
    print(friendName.count)
    print("It's \(ourName) vs \(friendName)")
}

print(" ourName > friendName : \( ourName > friendName)")
if ourName > friendName {
    print(ourName.count)
    print(friendName.count)
    print("It's \(friendName) vs \(ourName)")
}

// Make an array of 3 numbers
var numbers = [1, 2, 3]

// Add a 4th
numbers.append(4)

// If we have over 3 items
if numbers.count > 3 {
    // Remove the oldest number
    numbers.remove(at: 0)
}

// Display the result
print(numbers)

let country = "Canada"

if country == "Australia" {
    print("G'day!")
}

let name = "Taylor Swift"

if name != "Anonymous" {
    print("Welcome, \(name)")
}

// Create the username variable
var username = "taylorswift13"

// If `username` contains an empty string
if username == "" {
    // Make it equal to "Anonymous"
    username = "Anonymous"
}

// Now print a welcome message
print("Welcome, \(username)!")


if username.count == 0 {
    username = "Anonymous"
}

if username.isEmpty == true {
    username = "Anonymous"
}

if username.isEmpty {
    username = "Anonymous"
}

// Optional: How does Swift let us compare many types of data?
// Swift lets us compare many kinds of values out of the box, which means we can check a variety of values for equality and comparison. For example, if we had values such as these:
let firstName = "Paul"
let secondName = "Sophie"
let thirdName = "Patty"

let firstAge = 40
let secondAge = 10

print(firstName == secondName)
print(firstName != secondName)
print(firstName < secondName)
print(firstName >= secondName)
print(firstName >= thirdName)

print(firstAge == secondAge)
print(firstAge != secondAge)
print(firstAge < secondAge)
print(firstAge >= secondAge)

// We can even ask Swift to make our enums comparable, like this:
enum Sizes: Comparable {
    case small
    case medium
    case large
}

let first = Sizes.small
let second = Sizes.large
print(first < second) // That will print “true”, because small comes before large in the enum case list.

// Behind the scenes, Swift implements this in a remarkably clever way that actually allows it to compare a wide variety of things. For example, Swift has a special type for storing dates called Date, and you can compare dates using the same operators: someDate < someOtherDate, for example.

// 2) How to check multiple conditions
let ageAgain = 16

if ageAgain >= 18 {
    print("You can vote in the next election.")
}

if ageAgain < 18 {
    print("Sorry, you're too young to vote.")
}

if ageAgain >= 18 {
    print("You can vote in the next election.")
} else {
    print("Sorry, you're too young to vote.")
}

if someCondition {
    print("This will run if the condition is true")
} else {
    print("This will run if the condition is false")
}

let a = false
let b = true

if a {
    print("Code to run if a is true")
} else if b {
    print("Code to run if a is false but b is true")
} else {
    print("Code to run if both a and b are false")
}

let temp = 25

if temp > 20 {
    if temp < 30 {
        print("It's a nice day.")
    }
}

if temp > 20 && temp < 30 {
    print("It's a nice day.")
}

let userAge = 14
let hasParentalConsent = true

if userAge >= 18 || hasParentalConsent == true {
    print("You can buy the game")
}

if userAge >= 18 || hasParentalConsent {
    print("You can buy the game")
}

enum TransportOption {
    case airplane, helicopter, bicycle, car, scooter
}

let transport = TransportOption.airplane

if transport == .airplane || transport == .helicopter {
    print("Let's fly!")
} else if transport == .bicycle {
    print("I hope there's a bike path…")
} else if transport == .car {
    print("Time to get stuck in traffic.")
} else {
    print("I'm going to hire a scooter now!")
}

// Optional: What’s the difference between if and else if?
// You can have as many else if checks as you want, but you need exactly one if and either zero or one else.
let scoreAgain = 9001
if scoreAgain > 9000 {
    print("It's over 9000!")
}
if scoreAgain > 9000 {
    print("It's over 9000!")
}

if scoreAgain <= 9000 {
    print("It's not over 9000!")
}

if scoreAgain > 9000 {
    print("It's over 9000!")
} else {
    print("It's not over 9000!")
}

if scoreAgain > 9000 {
    print("It's over 9000!")
} else {
    if scoreAgain == 9000 {
        print("It's exactly 9000!")
    } else {
        print("It's not over 9000!")
    }
}

if score > 9000 {
    print("It's over 9000!")
} else if score == 9000 {
    print("It's exactly 9000!")
} else {
    print("It's not over 9000!")
}

// Optional: How to check multiple conditions
// Swift gives us && and || for checking multiple conditions at the same time, and when used with just two conditions they are fairly straightforward.
let isOwner = true
let isAdmin = true
let isEditingEnabled = true
if isOwner == true || isAdmin == true {
    print("You can delete this post")
}

// Where things get more confusing is when we want to check several things. For example, we could say that regular users can delete messages only we allowed them, but admins can always delete posts. We might write code like this:

if isOwner == true && isEditingEnabled || isAdmin == true {
    print("You can delete this post")
}

// But what is that trying to check? What order are the && and || checks executed? It could mean this:
if (isOwner == true && isEditingEnabled) || isAdmin == true {
    print("You can delete this post")
}

if isOwner == true && (isEditingEnabled || isAdmin == true) {
    print("You can delete this post")
}

if (isOwner == true && isEditingEnabled) || isAdmin == true {
    print("You can delete this post")
}
// Swift gives us && and || for checking multiple conditions at the same time, and when used with just two conditions they are fairly straightforward.
// However, honestly it’s not a nice experience to leave this to Swift to figure out, which is why we can insert the parentheses ourselves to clarify exactly what we mean. There is no specific advice on this, but realistically any time you mix && and || in a single condition you should almost certainly use parentheses to make the result clear.

// 3) How to use switch statements to check multiple conditions
enum Weather {
    case sun, rain, wind, snow, unknown
}

let forecast = Weather.sun

if forecast == .sun {
    print("It should be a nice day.")
} else if forecast == .rain {
    print("Pack an umbrella.")
} else if forecast == .wind {
    print("Wear something warm")
} else if forecast == .rain {
    print("School is cancelled.")
} else {
    print("Our forecast generator is broken!")
}

switch forecast {
case .sun:
    print("It should be a nice day.")
case .rain:
    print("Pack an umbrella.")
case .wind:
    print("Wear something warm")
case .snow:
    print("School is cancelled.")
case .unknown:
    print("Our forecast generator is broken!")
}

let place = "Metropolis"

switch place {
case "Gotham":
    print("You're Batman!")
case "Mega-City One":
    print("You're Judge Dredd!")
case "Wakanda":
    print("You're Black Panther!")
default: // Remember: Swift checks its cases in order and runs the first one that matches. If you place default before any other case, that case is useless because it will never be matched and Swift will refuse to build your code.
    print("Who are you?")
}

// We can use fallthrough to get exactly that behavior:
// That will match the first case and print “5 golden rings”, but the fallthrough line means case 4 will execute and print “4 calling birds”, which in turn uses fallthrough again so that “3 French hens” is printed, and so on. It’s not a perfect match to the song, but at least you can see the functionality in action!
let day = 5
print("My true love gave to me…")

switch day {
case 5:
    print("5 golden rings")
    fallthrough
case 4:
    print("4 calling birds")
    fallthrough
case 3:
    print("3 French hens")
    fallthrough
case 2:
    print("2 turtle doves")
    fallthrough
default:
    print("A partridge in a pear tree")
}

// Optional: When should you use switch statements rather than if?
/*
 There are three reasons why you might want to consider using switch rather than if:
 
 1) Swift requires that its switch statements are exhaustive, which means you must either have a case block for every possible value to check (e.g. all cases of an enum) or you must have a default case. This isn’t true for if and else if, so you might accidentally miss a case.
 2) When you use switch to check a value for multiple possible results, that value will only be read once, whereas if you use if it will be read multiple times. This becomes more important when you start using function calls, because some of these can be slow.
 3) Swift’s switch cases allow for advanced pattern matching that is unwieldy with if.
 
 There’s one more situation, but it’s a little fuzzier: broadly speaking, if you want to check the same value for three or more possible states, you’ll find folks prefer to use switch rather than if for legibility purposes if nothing else – it becomes clearer that we’re checking the same value repeatedly, rather than writing different conditions.
 
 PS: I’ve covered the fallthrough keyword because it’s important to folks coming from other programming languages, but it’s fairly rare to see it used in Swift – don’t worry if you’re struggling to think up scenarios when it might be useful, because honestly most of the time it isn’t!
 */

// 4) How to use the ternary conditional operator for quick tests
// This option is called the ternary conditional operator. To understand why it has that name, you first need to know that +, -, ==, and so on are all called binary operators because they work with two pieces of input: 2 + 5, for example, works with 2 and 5.
// Ternary operators work with three pieces of input, and in fact because the ternary conditional operator is the only ternary operator in Swift, you’ll often hear it called just “the ternary operator.”
let canVoteAge = 18
let canVote = canVoteAge >= 18 ? "Yes" : "No"

// ternary
let hour = 23
print(hour < 12 ? "It's before noon" : "It's after noon")

// Or run print() twice, like this:
if hour < 12 {
    print("It's before noon")
} else {
    print("It's after noon")
}

let names = ["Jayne", "Kaylee", "Mal"]
let crewCount = names.isEmpty ? "No one" : "\(names.count) people"
print(crewCount)

enum Theme {
    case light, dark
}

let theme = Theme.dark

let background = theme == .dark ? "black" : "white"
print(background)

// Optional: When should you use the ternary operator in Swift?
// The ternary operator lets us choose from one of two results based on a condition, and does so in a really concise way:

let isAuthenticated = true
print(isAuthenticated ? "Welcome!" : "Who are you?")

// Some people rely very heavily on the ternary operator because it makes for very short code, whereas some stay away from it as much as possible because it can make code harder to read. I’m very much in the “avoid where possible” camp because even though this code is longer I do find it easier to follow.

// Now, there is one time when the ternary operator gets a lot of use and that’s with SwiftUI. I don’t want to give code examples here because it can be a bit overwhelming, but you can really go to town with the ternary operator there if you want to. Even then, I prefer to remove them when possible, to make my code easier to read, but you should try it for yourself and come to your own conclusions.


