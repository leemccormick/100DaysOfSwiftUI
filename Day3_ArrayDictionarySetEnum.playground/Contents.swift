import Cocoa

var greeting = "Hello, playground"

// Day 3 - 100 Days Of SwiftUI : 03/03/2022
// How to store ordered data in arrays

var beatles = ["John", "Paul", "George", "Ringo"]
let numbers = [4, 8, 15, 16, 23, 42]
var temperatures = [25.3, 28.2, 26.4]

print(beatles[0])
print(numbers[1])
print(temperatures[2])

beatles.append("Adrian")
beatles.append("Allen")
beatles.append("Adrian")
beatles.append("Novall")
beatles.append("Vivian")

// temperatures.append("Chris")

let firstBeatle = beatles[0]
let firstNumber = numbers[0]
// let notAllowed = firstBeatle + firstNumber

var scores = Array<Int>()
scores.append(100)
scores.append(80)
scores.append(85)
print(scores[1])

var albums = Array<String>()
albums.append("Folklore")
albums.append("Fearless")
albums.append("Red")

var albumsAgain = [String]()
albumsAgain.append("Folklore")
albumsAgain.append("Fearless")
albumsAgain.append("Red")

// Swift’s type safety means that it must always know what type of data an array is storing. That might mean being explicit by saying albums is an Array<String>, but if you provide some initial values Swift can figure it out for itself:
var albumsAgainAgain = ["Folklore"]
albumsAgainAgain.append("Fearless")
albumsAgainAgain.append("Red")

print(albumsAgainAgain.count)

var characters = ["Lana", "Pam", "Ray", "Sterling"]
print(characters.count)

characters.remove(at: 2)
print(characters.count)

characters.removeAll()
print(characters.count)

let bondMovies = ["Casino Royale", "Spectre", "No Time To Die"]
print(bondMovies.contains("Frozen"))

let cities = ["London", "Tokyo", "Rome", "Budapest"]
print(cities.sorted())

let presidents = ["Bush", "Obama", "Trump", "Biden"]
let reversedPresidents = presidents.reversed()
print(reversedPresidents)

let names = ["Muay", "Lynn", "Night", "News"]
print(names.reversed())
print(names.sorted())

let intTryReverse = [1,2,3,4]
print(intTryReverse.reversed())
print(intTryReverse.sorted())

// Why does Swift have arrays?
// Swift’s strings, integers, Booleans, and Doubles allow us to temporarily store single values, but if you want to store many values you will often use arrays instead. Arrays in Swift can be as large or as small as you want. If they are variable, you can add to them freely to build up your data over time, or you can remove or even rearrange items if you want.

// How to store and find data in dictionaries
var employee = ["Taylor Swift", "Singer", "Nashville"]
print("Name: \(employee[0])")
print("Job title: \(employee[1])")
print("Location: \(employee[2])")

employee.remove(at: 1)
print("Job title: \(employee[1])")

let employee2 = ["name": "Taylor Swift",
                 "job": "Singer",
                 "location": "Nashville"]

// When it comes to reading data out from the dictionary, you use the same keys you used when creating it:
print(employee2["name"])
print(employee2["job"])
print(employee2["location"])

// If you try that in a playground, you’ll see Xcode throws up various warnings along the lines of “Expression implicitly coerced from 'String?' to 'Any’”. Worse, if you look at the output from your playground you’ll see it prints Optional("Taylor Swift") rather than just Taylor Swift – what gives?
print(employee2["password"])
print(employee2["status"])
print(employee2["manager"])

// Optionals are a pretty complex issue that we’ll be covering in detail later on, but for now I’ll show you a simpler approach: when reading from a dictionary, you can provide a default value to use if the key doesn’t exist.
print(employee2["name", default: "Unknown"])
print(employee2["job", default: "Unknown"])
print(employee2["location", default: "Unknown"])

let hasGraduated = [
    "Eric": false,
    "Maeve": true,
    "Otis": false,
]

let olympics = [
    2012: "London",
    2016: "Rio de Janeiro",
    2021: "Tokyo"]

print(olympics[2012, default: "Unknown"])

// You can also create an empty dictionary using whatever explicit types you want to store, then set keys one by one :
var heights = [String: Int]()
heights["Yao Ming"] = 229
heights["Shaquille O'Neal"] = 216
heights["LeBron James"] = 206

var archEnemies = [String: String]()
archEnemies["Batman"] = "The Joker"
archEnemies["Superman"] = "Lex Luthor"
// If your friend disagrees that The Joker is Batman’s arch-enemy, you can just rewrite that value by using the same key:
archEnemies["Batman"] = "Penguin"

print(archEnemies.count)
print(archEnemies.removeAll())
print(archEnemies.count)

// Why does Swift have default values for dictionaries?
// Whenever you read a value from a dictionary, you might get a value back or you might get back nil – there might be no value for that key. Having no value can cause problems in your code, not least because you need to add extra functionality to handle missing values safely, and that’s where dictionary default values come in: they let you provide a backup value to use for when the key you ask for doesn’t exist. For example, here’s a dictionary that stores the exam results for a student:

let results = [
    "english": 100,
    "french": 85,
    "geography": 75
]

// So, it’s not like you always need a default value when working with dictionaries, but when you do it’s easy:
let historyResult = results["history", default: 0]

// Why does Swift have dictionaries as well as arrays?
// Dictionaries and arrays are both ways of storing lots of data in one variable, but they store them in different ways: dictionaries let us choose a “key” that identifies the item we want to add, whereas arrays just add each item sequentially. So, rather than trying to remember that array index 7 means a user’s country, we could just write user["country"] – it’s much more convenient. Dictionaries don’t store our items using an index, but instead they optimize the way they store items for fast retrieval. So, when we say user["country"] it will send back the item at that key (or nil) instantly, even if we have a dictionary with 100,000 items inside. Remember, you can’t be guaranteed that a key in a dictionary exists. This is why reading a value from a dictionary might send back nothing – you might have requested a key that doesn’t exist!

// How to use sets for fast data lookup
// A set – they are similar to arrays, except you can’t add duplicate items, and they don’t store their items in a particular order.

let people = Set(["Denzel Washington", "Tom Cruise", "Nicolas Cage", "Samuel L Jackson", "Lee", "Lee"])
print(people.count)
print(people)
print(people)

// When adding items to a set is visible when you add items individually. Notice how we’re using insert()? When we had an array of strings, we added items by calling append(), but that name doesn’t make sense here – we aren’t adding an item to the end of the set, because the set will store the items in whatever order it wants.
var peopleAgain = Set<String>()
peopleAgain.insert("Lee McCormick")
peopleAgain.insert("Lee McCormick")
peopleAgain.insert("Lee McCormick")
peopleAgain.insert("Denzel Washington")
peopleAgain.insert("Tom Cruise")
peopleAgain.insert("Nicolas Cage")
peopleAgain.insert("Samuel L Jackson")
peopleAgain.insert("Lee McCormick")

// if you have an array of 1000 movie names and use something like contains() to check whether it contains “The Dark Knight” Swift needs to go through every item until it finds one that matches – that might mean checking all 1000 movie names before returning false, because The Dark Knight wasn’t in the array. In comparison, calling contains() on a set runs so fast you’d struggle to measure it meaningfully. Heck, even if you had a million items in the set, or even 10 million items, it would still run instantly, whereas an array might take minutes or longer to do the same work.
// Tip: Alongside contains(), you’ll also find count to read the number of items in a set, and sorted() to return a sorted array containing the the set’s items.

// Why are sets different from arrays in Swift?
// Both sets and arrays are collections of data, meaning that they hold multiple values inside a single variable. However, how they hold their values is what matters: sets are unordered and cannot contain duplicates, whereas arrays retain their order and can contain duplicates.
// This difference means that sets are more useful for times when you want to say “does this item exist?” For example, if you want to check whether a word appears in a dictionary, you should use a set: you don’t have duplicates, and you want to do a fast look up.

// Initialization ==> When we compare the initialization of Arrays and Sets we can really see that they’re quite the same.
let arrayOfBlogCategories: [String] = ["Swift", "Debugging", "Xcode", "Workflow", "Optimization"]
var setOfBlogCategories: Set<String> = ["Swift", "Debugging", "Xcode", "Workflow", "Optimization"]
let blogCategories = ["Swift", "Debugging", "Xcode", "Workflow", "Optimization"] // Defaults to Array<String>

// A set stores distinct values of the same type in a collection with no defined ordering. You can use a set instead of an array when the order of items is not important, or when you need to ensure that an item only appears once.

print(arrayOfBlogCategories) // ["Swift", "Debugging", "Xcode", "Workflow", "Optimization", "WWDC"]
print(setOfBlogCategories)   // ["Xcode", "WWDC", "Swift", "Workflow", "Debugging", "Optimization"]

// Another difference here is the return type of the insert(_:) method. It returns both a inserted boolean and a memberAfterInsert property which either contains the already-existing object or the just inserted object. This can be valuable if you want to give feedback to the user if an object already exists:
let (inserted, memberAfterInsert) = setOfBlogCategories.insert("Swift")
if !inserted {
    print("\(memberAfterInsert) already exists")
}
// Prints: "Swift already exists"

// But how about NSOrderedSet? ==> Another available type is NSOrderedSet. However, this is not a Swift type and comes with a cost. As it’s a non-generic type we have to work with Any objects and cast everywhere we use it.

// Core Data, NSSet and converting to Swift types ==> It’s quite tempting to go for a typed Set when working with collections in Core Data. However, this comes with a cost which is not always clear.If your Core Data collection is a constant and will not (often) change it’s more than fine to bridge to a Set as the copy(with:) method, which is used upon bridging, is returning the same set in constant time. The copying performance of mutable NSSet types is unspecified and should. You can read more about this topic in the documentation.

/*
 Conclusion Set VS Array
 It turns out that a Set is quite different compared to an Array. Therefore, a simple cheat sheet to end this blog post!

 Go for an Array if:

 Order is important
 Duplicate elements should be possible
 Performance is not important
 Go for a Set if:

 Order is not important
 Unique elements is a requirement
 Performance is important
 */

// How to create and use enums
var selected = "Monday"
selected = "Tuesday"
selected = "January"

// enum ==> This is where enums come in: they let us define a new data type with a handful of specific values that it can have. Think of a Boolean, that can only have true or false – you can’t set it to “maybe” or “probably”, because that isn’t in the range of values it understands. Enums are the same: we get to list up front the range of values it can have, and Swift will make sure you never make a mistake using them.
enum Weekday {
case monday
case tuesday
case wednesday
case thursday
case friday
}

var day = Weekday.monday
day = Weekday.tuesday
day = Weekday.friday

print(day)

enum Weekend {
    case saturday, sunday
}

var dayAgain = Weekday.monday
dayAgain = .tuesday
dayAgain = .friday

// Why does Swift need enums?
// Enums are an extraordinarily powerful feature of Swift, and you’ll see them used in a great many ways and places. Many languages don’t have enums and get by just fine, so you might wonder why Swift needs enums at all! Well, at their simplest an enum is simply a nice name for a value. We can make an enum called Direction with cases for north, south, east, and west, and refer to those in our code. Sure, we could have used an integer instead, in which case we’d refer to 1, 2, 3, and 4, but could you really remember what 3 meant? And what if you typed 5 by mistake? So, enums are a way of us saying Direction.north to mean something specific and safe. If we had written Direction.thatWay and no such case existed, Swift would simply refuse to build our code – it doesn’t understand the enum case. Behind the scenes, Swift can store its enum values very simply, so they are much faster to create and store than something like a string.
