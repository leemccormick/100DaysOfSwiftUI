import Cocoa

var greeting = "Hello, playground"

// Day 7 - Function Part One : 100 Days Of SwiftUI
// Functions let us wrap up pieces of code so they can be used in lots of places. We can send data into functions to customize how they work, and get back data that tells us the result that was calculated.

// 1) How to reuse code with functions
func showWelcome() {
    print("Welcome to my app!")
    print("By default This prints out a conversion")
    print("chart from centimeters to inches, but you")
    print("can also set a custom range if you want.")
}
showWelcome()

func printTimesTables(number: Int) {
    for i in 1...12 {
        print("\(i) x \(number) is \(i * number)")
    }
}

printTimesTables(number: 5)

func printTimesTables(number: Int, end: Int) {
    for i in 1...end {
        print("\(i) x \(number) is \(i * number)")
    }
}

printTimesTables(number: 5, end: 20)

// What code should be put in a function?
/*
 Functions are designed to let us re-use code easily, which means we don’t have to copy and paste code to get common behaviors. You could use them very rarely if you wanted, but honestly there’s no point – they are wonderful tools for helping us write clearer, more flexible code.
 
 There are three times you’ll want to create your own functions:
 
 1) The most common time is when you want the same functionality in many places. Using a function here means you can change one piece of code and have everywhere that uses your function get updated.
 2) Functions are also useful for breaking up code. If you have one long function it can be hard to follow everything that’s going on, but if you break it up into three or four smaller functions then it becomes easier to follow.
 3) The last reason is more advanced: Swift lets us build new functions out of existing functions, which is a technique called function composition. By splitting your work into multiple small functions, function composition lets us build big functions by combining those small functions in various ways, a bit like Lego bricks.
 */

// How many parameters should a function accept?
/*
 At first glance, this question seems like “how long is a piece of a string?” That is, it’s something where there is no real, hard answer – a function could take no parameters or take 20 of them.
 
 That’s certainly true, but when a function takes many parameters – perhaps six or more, but this is extremely subjective – you need to start asking whether that function is perhaps doing a bit too much work.
 
 - Does it need all six of those parameters?
 - Could that function be split up into smaller functions that take fewer parameters?
 - Should those parameters be grouped somehow?
 
 We’ll look at some techniques for solving this later on, but there’s an important lesson to be learned here: this is called a “code smell” – something about our code that suggests an underlying problem in the way we’ve structured our program.
 */

// 2) How to return values from functions
func rollDice() -> Int {
    return Int.random(in: 1...6)
}

// We can go back and do the same for the rollDice() function too:
func rollDiceNoReturnKeyWord() -> Int {
    Int.random(in: 1...6)
}


let result = rollDice()
print(result)
let rollAgain = rollDiceNoReturnKeyWord()

func areLettersIdentical(string1: String, string2: String) -> Bool {
    let first = string1.sorted()
    let second = string2.sorted()
    return first == second
}

func areLettersIdenticalOneLine(string1: String, string2: String) -> Bool {
    return string1.sorted() == string2.sorted()
}

func pythagoras(a: Double, b: Double) -> Double {
    let input = a * a + b * b
    let root = sqrt(input)
    return root
}

func pythagorasShorter(a: Double, b: Double) -> Double {
    sqrt(a * a + b * b)
}

let c = pythagoras(a: 3, b: 4)
print(c)
let a = pythagorasShorter(a: 5, b: 6)

//  If your function doesn’t return a value, you can still use return by itself to force the function to exit early. For example, perhaps you have a check that the input matches what you expected, and if it doesn’t you want to exit the function immediately before continuing.

// When is the return keyword not needed in a Swift function?
// We use the return keyword to send back values from functions in Swift, but there is one specific case where it isn’t needed: when our function contains only a single expression.
// Now, “expression” isn’t a word I use often, but it’s important to understand here. When we write programs we do things like this:
5 + 8

func greet(_ name: String) -> String {
    "Hello, \(name)"
}

let greetingPual = greet("Paul")

// These lines of code get resolved to a single value: 5 + 8 gets resolved to 13, and greet("Paul") might return a string “Hi, Paul!” Even some longer code will get resolved to a single value. For example, if we had three Boolean constants like this:
let isAdmin = true
let isOwner = false
let isEditingEnabled = false

isOwner == true && isEditingEnabled || isAdmin == true

// All this matters because Swift lets us skip using the return keyword when we have only one expression in our function. So, these two functions do the same thing:
func doMath() -> Int {
    return 5 + 5
}

func doMoreMath() -> Int {
    5 + 5
}

// Remember, the expression inside there can be as long as you want, but it can’t contain any statements – no loops, no conditions, no new variables, and so on. Now, you might think this is pointless, and you would always use the return keyword. However, this functionality is used very commonly with SwiftUI, so it’s worth keeping in mind.

func greet(name: String) -> String {
    if name == "Taylor Swift" {
        return "Oh wow!"
    } else {
        return "Hello, \(name)"
    }
}

func greetOneExpression(name: String) -> String {
    name == "Taylor Swift" ? "Oh wow!" : "Hello, \(name)"
}

func greetOhWow(name: String) -> String {
    "Oh wow!"
}

/*
 That is a single expression. If name is equal to “Taylor Swift” then it will resolve something like this:
 
 Swift will check whether name is Taylor Swift or not.
 It is, so name == "Taylor Swift" is true.
 The ternary operator will realize its condition is now true, so it will pick “Oh wow” rather than “Hello, (name)”.
 */

// 3) How to return multiple values from functions
func isUppercase(string: String) -> Bool {
    string == string.uppercased()
}

/*
 That compares a string against the uppercased version of itself. If the string was already fully uppercased then nothing will have changed and the two strings will be identical, otherwise they will be different and == will send back false.
 
 If you want to return two or more values from a function, you could use an array. For example, here’s one that sends back a user’s details:
 */
func getUser() -> [String] {
    ["Taylor", "Swift"]
}

let user = getUser()
print("Name: \(user[0]) \(user[1])")

/*
 That’s problematic, because it’s hard to remember what user[0] and user[1] are, and if we ever adjust the data in that array then user[0] and user[1] could end up being something else or perhaps not existing at all.
 
 We could use a dictionary instead, but that has its own problems:
 */

func getUserDictionary() -> [String: String] {
    [
        "firstName": "Taylor",
        "lastName": "Swift"
    ]
}

let userDict = getUserDictionary()
print("Name: \(userDict["firstName", default: "Anonymous"]) \(userDict["lastName", default: "Anonymous"])")

// Both of these solutions are pretty bad, but Swift has a solution in the form of tuples. Like arrays, dictionaries, and sets, tuples let us put multiple pieces of data into a single variable, but unlike those other options tuples have a fixed size and can have a variety of data types.

func getUserTuples() -> (firstName: String, lastName: String) {
    (firstName: "Taylor", lastName: "Swift")
}

let userTuples = getUserTuples()
print("Name: \(userTuples.firstName) \(userTuples.lastName)")

/*
 1) When you access values in a dictionary, Swift can’t know ahead of time whether they are present or not. Yes, we knew that user["firstName"] was going to be there, but Swift can’t be sure and so we need to provide a default value.
 2) When you access values in a tuple, Swift does know ahead of time that it is available because the tuple says it will be available.
 3) We access values using user.firstName: it’s not a string, so there’s also no chance of typos.
 4) Our dictionary might contain hundreds of other values alongside "firstName", but our tuple can’t – we must list all the values it will contain, and as a result it’s guaranteed to contain them all and nothing else.
 */

func getUserShortTuple() -> (firstName: String, lastName: String) {
    ("Taylor", "Swift")
}

func getUserShortestTuple() -> (String, String) {
    ("Taylor", "Swift")
}

let userShortest = getUserShortestTuple()
print("Name: \(userShortest.0) \(userShortest.1)")
let userShortTuple = getUserShortTuple()
let firstName = userShortTuple.firstName
let lastName = userShortTuple.lastName

let (firstNameAgain, lastNameAgain) = getUserShortTuple()
let (firstNameAgainAgain, _) = getUserShortTuple()
print("Name: \(firstNameAgainAgain)")

// When should you use an array, a set, or a tuple in Swift?
/*
 Because arrays, sets, and tuples work in slightly different ways, it’s important to make sure you choose the right one so your data is stored correctly and efficiently.
 
 Remember: arrays keep the order and can have duplicates, sets are unordered and can’t have duplicates, and tuples have a fixed number of values of fixed types inside them.
 So:
 - If you want to store a list of all words in a dictionary for a game, that has no duplicates and the order doesn’t matter so you would go for a set.
 - If you want to store all the articles read by a user, you would use a set if the order didn’t matter (if all you cared about was whether they had read it or not), or use an array if the order did matter.
 - If you want to store a list of high scores for a video game, that has an order that matters and might contain duplicates (if two players get the same score), so you’d use an array.
 - If you want to store items for a todo list, that works best when the order is predictable so you should use an array.
 - If you want to hold precisely two strings, or precisely two strings and an integer, or precisely three Booleans, or similar, you should use a tuple.
 */

// 4) How to customize parameter labels
// You’ve seen how Swift developers like to name their function parameters, because it makes it easier to remember what they do when the function is called. For example, we could write a function to roll a dice a certain number of times, using parameters to control the number of sides on the dice and the number of rolls:

func rollDice(sides: Int, count: Int) -> [Int] {
    // Start with an empty array
    var rolls = [Int]()
    
    // Roll as many dice as needed
    for _ in 1...count {
        // Add each result to our array
        let roll = Int.random(in: 1...sides)
        rolls.append(roll)
    }
    
    // Send back all the rolls
    return rolls
}

let rolls = rollDice(sides: 6, count: 4)

func hireEmployee(name: String) { }
func hireEmployee(title: String) { }
func hireEmployee(location: String) { }

// When we call hasPrefix() we pass in the prefix to check for directly – we don’t say hasPrefix(string:) or, worse, hasPrefix(prefix:). How come?
let lyric = "I see a red door and I want it painted black"
print(lyric.hasPrefix("I see"))

func isUppercaseAgain(string: String) -> Bool {
    string == string.uppercased()
}

let string = "HELLO, WORLD"
let resultAgain = isUppercaseAgain(string: string)

func isUppercase(_ string: String) -> Bool {
    string == string.uppercased()
}

let stringAgain = "HELLO, WORLD"
let resultAgainAgain = isUppercase(string)

func printTimesTablesAgain(number: Int) {
    for i in 1...12 {
        print("\(i) x \(number) is \(i * number)")
    }
}

func printTimesTables(for number: Int) {
    for i in 1...12 {
        print("\(i) x \(number) is \(i * number)")
    }
}

printTimesTables(for: 5)
printTimesTables(number: 5)
/*
 There are three things in there you need to look at closely:
 
 We write for number: Int: the external name is for, the internal name is number, and it’s of type Int.
 When we call the function we use the external name for the parameter: printTimesTables(for: 5).
 Inside the function we use the internal name for the parameter: print("\(i) x \(number) is \(i * number)").
 */

// When should you omit a parameter label?
/*
 The main reason for skipping a parameter name is when your function name is a verb and the first parameter is a noun the verb is acting on. For example:
 
 - Greeting a person would be greet(taylor) rather than greet(person: taylor)
 - Buying a product would be buy(toothbrush) rather than buy(item: toothbrush)
 - Finding a customer would be find(customer) rather than find(user: customer)
 - Singing a song would be sing(song) rather than sing(song: song)
 - Enabling an alarm would be enable(alarm) rather than enable(alarm: alarm)
 - Reading a book would be read(book) rather than read(book: book)
 
 Before SwiftUI came along, apps were built using Apple’s UIKit, AppKit, and WatchKit frameworks, which were designed using an older language called Objective-C. In that language, the first parameter to a function was always left unnamed, and so when you use those frameworks in Swift you’ll see lots of functions that have underscores for their first parameter label to preserve interoperability with Objective-C.
 */

