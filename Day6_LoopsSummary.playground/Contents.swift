import Cocoa

var greeting = "Hello, playground"

// Day 6 - Loops, Summary : 100 Days Of SwiftUI
// 1) How to use a for loop to repeat work
let platforms = ["iOS", "macOS", "tvOS", "watchOS"]

for os in platforms {
    print("Swift works great on \(os).")
}

for name in platforms {
    print("Swift works great on \(name).")
}

for rubberChicken in platforms {
    print("Swift works great on \(rubberChicken).")
}

for i in 1...12 {
    print("5 x \(i) is \(5 * i)")
}

for i in 1...12 {
    print("The \(i) times table:")
    for j in 1...12 {
        print("  \(j) x \(i) is \(j * i)")
    }
    print()
}

var lyric = "Haters gonna"

for _ in 1...5 {
    lyric += " hate"
}

print(lyric)

// Why does Swift use underscores with loops?
// Every time the loop goes around, Swift will take one item from the names array, put it into the name constant, then execute the body of our loop – that’s the print() method. However, sometimes you don’t actually need the value that is currently being read, which is where the underscore comes in: Swift will recognize you don’t actually need the variable, and won’t make the temporary constant for you. Of course, Swift can really see that anyway – it can see whether or not you’re using name inside the loop, so it can do the same job without the underscore. However, using an underscore does something very similar for our brain: we can look at the code and immediately see the loop variable isn’t being used, no matter how many lines of code are inside the loop body.

let names = ["Sterling", "Cyril", "Lana", "Ray", "Pam"]

for name in names {
    print("\(name) is a secret agent")
}

for _ in names {
    print("[CENSORED] is a secret agent!")
}
// Why does Swift have two range operators?
// When we think about ranges of values, English is quite confusing. If I say “give me the sales figures up to yesterday” does that mean including yesterday or excluding yesterday? Both are useful in their own right, so Swift gives us a way of representing them both: ..< is the half-open range that specifies “up to but excluding” and ... is the closed range operator that specifies “up to and including”. To make the distinction easier when talking, Swift regularly uses very specific language: “1 to 5” means 1, 2, 3, and 4, but “1 through 5” means 1, 2, 3, 4, and 5. If you remember, Swift’s arrays start at index 0, which means an array containing three items have items at indexes 0, 1, and 2 – a perfect use case for the half-open range operator. Things get more interesting when you want only part of a range, such as “anything from 0 upwards” or “index 5 to the end of the array.” You see, these are fairly useful in programming, so Swift make them easier to create by letting us specify only part of a range.

let namesAgain = ["Piper", "Alex", "Suzanne", "Gloria"]
print(namesAgain[0])
// That carries a small risk, though: if our array didn’t contain at least four items then 1...3 would fail. Fortunately, we can use a one-sided range to say “give me 1 to the end of the array”, like this:
print(namesAgain[1...3])
print(namesAgain[2...])

// So, ranges are great for counting through specific values, but they are also helpful for reading groups of items from arrays. If you’d like to keep learning more about ranges in Swift, you should check out Antoine van der Lee’s article on the topic: https://www.avanderlee.com/swift/ranges-explained/

// 2) How to use a while loop to repeat work
// You’ll find yourself using both for and while loops in your own code: for loops are more common when you have a finite amount of data to go through, such as a range or an array, but while loops are really helpful when you need a custom condition.
// Swift has a second kind of loop called while: provide it with a condition, and a while loop will continually execute the loop body until the condition is false. Although you’ll still see while loops from time to time, they aren’t as common as for loops. As a result, I want to cover them so you know they exist, but let’s not dwell on them too long, okay?

var countdown = 10

while countdown > 0 {
    print("\(countdown)…")
    countdown -= 1
}
print("Blast off!")

// while loops are really useful when you just don’t know how many times the loop will go around. To demonstrate this, I want to introduce you to a really useful piece of functionality that Int and Double both have: random(in:). Give that a range of numbers to work with, and it will send back a random Int or Double somewhere inside that range.
let id = Int.random(in: 1...1000)
let amount = Double.random(in: 0...1)
// We can use this functionality with a while loop to roll some virtual 20-sided dice again and again, ending the loop only when a 20 is rolled – a critical hit for all you Dungeons & Dragons players out there.
// create an integer to store our roll
var roll = 0

// carry on looping until we reach 20
while roll != 20 {
    // roll a new dice and print what it was
    roll = Int.random(in: 1...20)
    print("I rolled a \(roll)")
}

// if we're here it means the loop ended – we got a 20!
print("Critical hit!")

// When should you use a while loop?
/*
 The main difference is that for loops are generally used with finite sequences: we loop through the numbers 1 through 10, or through the items in an array, for example. On the other hand, while loops can loop until any arbitrary condition becomes false, which allows them until we tell them to stop.
 
 This means we can repeat the same code until…
 …the user asks us to stop
 …a server tell us to stop
 …we’ve found the answer we’re looking for
 …we’ve generated enough data
 
 And those are just a handful of examples. Think about it: if I asked you to roll 10 dice and print their results, you could do that with a simple for loop by counting from 1 through 10. But if I asked you to roll 10 dice and print the results, while also automatically rolling another dice if the previous dice had the same result, then you don’t know ahead of time how many dice you’ll need to roll. Maybe you’ll get lucky and need only 10 rolls, but maybe you’ll get a few duplicate rolls and need 15 rolls. Or perhaps you’ll get lots of duplicate rolls and need 30 – who knows?
 
 That’s where a while loop comes in handy: we can keep the loop going around until we’re ready to exit.
 */

// 3) How to skip loop items with break and continue
// So, use continue when you want to skip the rest of the current loop iteration, and use break when you want to skip all remaining loop iterations.
// Swift gives us two ways to skip one or more items in a loop: continue skips the current loop iteration, and break skips all remaining iterations. Like while loops these are sometimes used, but in practice much less than you might think.
let filenames = ["me.jpg", "work.txt", "sophie.jpg", "logo.psd"]

for filename in filenames {
    if filename.hasSuffix(".jpg") == false {
        continue
    }
    print("Found picture: \(filename)")
}

// As for break, that exits a loop immediately and skips all remaining iterations. To demonstrate this, we could write some code to calculate 10 common multiples for two numbers:
let number1 = 4
let number2 = 14
var multiples = [Int]()

for i in 1...100_000 {
    if i.isMultiple(of: number1) && i.isMultiple(of: number2) {
        multiples.append(i)
        if multiples.count == 10 {
            break
        }
    }
}

print(multiples)

// Why would you want to exit a loop?
// Swift’s break keyword lets us exit a loop immediately, regardless of what kind of loop we’re talking about. A lot of the time you won’t need this, because you’re looping over items in an array and want to process them all, or because you’re counting from 1 through 10 and want to handle all those values.However, sometimes you do want to end your loop prematurely. For example, if you had an array of scores and you want to figure out how many of them the player achieved without getting a 0, you might write this:
let scores = [1, 8, 4, 3, 0, 5, 2]
var count = 0

for score in scores {
    if score == 0 {
        break
    }
    count += 1
}

print("You had \(count) scores before you got 0.")
// Without break we’d need to continue looping through scores even after we found the first 0, which is wasteful.

// When to use break and when to use continue
// When we use continue we’re saying “I’m done with the current run of this loop” – Swift will skip the rest of the loop body, and go to the next item in the loop. But when we say break we’re saying “I’m done with this loop altogether, so get out completely.” That means Swift will skip the remainder of the body loop, but also skip any other loop items that were still to come.

// 4) Summary: Conditions and loops
/*
 - We use if statements to check a condition is true. You can pass in any condition you want, but ultimately it must boil down to a Boolean.
 - If you want, you can add an else block, and/or multiple else if blocks to check other conditions. Swift executes these in order.
 - You can combine conditions using ||, which means that the whole condition is true if either subcondition is true, or &&, which means the whole condition is true if both subconditions are true.
 - If you’re repeating the same kinds of check a lot, you can use a switch statement instead. These must always be exhaustive, which might mean adding a default case.
 - If one of your switch cases uses fallthrough, it means Swift will execute the following case afterwards. This is not used commonly.
 - The ternary conditional operator lets us check WTF: What, True, False. Although it’s a little hard to read at first, you’ll see this used a lot in SwiftUI.
 - for loops let us loop over arrays, sets, dictionaries, and ranges. You can assign items to a loop variable and use it inside the loop, or you can use underscore, _, to ignore the loop variable.
 - while loops let us craft custom loops that will continue running until a condition becomes false.
 - We can skip some or all loop items using continue or break respectively.
 */

// 5) Checkpoint 3
/*
 Now that you’re able to use conditions and loops, I’d like you to try a classic computer science problem. It’s not hard to understand, but it might take you a little time to solve depending on your prior experience!
 
 The problem is called fizz buzz, and has been used in job interviews, university entrance tests, and more for as long as I can remember. Your goal is to loop from 1 through 100, and for each number:
 
 1) If it’s a multiple of 3, print “Fizz”
 2) If it’s a multiple of 5, print “Buzz”
 3) If it’s a multiple of 3 and 5, print “FizzBuzz”
 4) Otherwise, just print the number.
 */

for i in 1...100 {
    if i.isMultiple(of: 3) && i.isMultiple(of: 5)  {
        print("FizzBuzz")
    } else if i.isMultiple(of: 3) {
        print("Fizz")
    } else if i.isMultiple(of: 5){
        print("Buzz")
    } else {
        print(i)
    }
}

// Example Tests
var cats: Int = 0
while cats < 10 {
    cats += 1
    print("I'm getting another cat.")
    if cats == 4 {
        print("Enough cats!")
        cats = 10
    }
}

let i = 1000 % 10000

var number: Int = 10
while number > 0 {
    number -= 2
    if number % 2 == 0 {
        print("\(number) is an even number.")
    }
}

var averageScore = 2.5
while averageScore < 15.0 {
    averageScore += 2.5
    print("The average score is \(averageScore)")
}

var password = "1"
while true {
    password += "1"
    if password == "11111" {
        print("That's a terrible password.")
    }
    break
}

var people = 2
while people < 10 {
    people += 2
    if people == 10 {
        print("We got 10 people.")
    }
}

var counter: Int = 1
while counter < 100 {
    counter += 10
    if counter % 10 == 5 {
        print("Matching number found")
    }
}
