import Cocoa

// Day9 - Closures, Passing Functions into Functions, and Checkpoint 5 : 03/09/2022

// Today the topic is closures, which are a bit like anonymous functions – functions we can create and assign directly to a variable, or pass into other functions to customize how they work. Yes, you read that right: passing one function into another as a parameter.
// Closures are really difficult. I’m not saying that to put you off, only so that you know in advance if you’re finding closures hard to understand or hard to remember, it’s okay – we’ve all been there!
// SwiftUI uses closures extensively so it’s worth taking the time to understand what’s going on here. Yes, closures are probably the most complex feature of Swift, but it’s a bit like cycling up a hill – once you’ve reached the top, once you’ve mastered closures, it all gets much easier.

// 1) How to create and use closures
// Functions are powerful things in Swift. Yes, you’ve seen how you can call them, pass in values, and return data, but you can also assign them to variables, pass functions into functions, and even return functions from functions.

// For example:
func greetUser() {
    print("Hi there!")
}

greetUser()

// Important: When you’re copying a function, you don’t write the parentheses after it – it’s var greetCopy = greetUser and not var greetCopy = greetUser(). If you put the parentheses there you are calling the function and assigning its return value back to something else.
// That creates a trivial function and calls it, but then creates a copy of that function and calls the copy. As a result, it will print the same message twice.
var greetCopy = greetUser
greetCopy()

// Swift gives this the grandiose name closure expression, which is a fancy way of saying we just created a closure – a chunk of code we can pass around and call whenever we want. This one doesn’t have a name, but otherwise it’s effectively a function that takes no parameters and doesn’t return a value.
let sayHello = {
    print("Hi there!")
}

sayHello()

// If you want the closure to accept parameters, they need to be written in a special way. You see, the closure starts and ends with the braces, which means we can’t put code outside those braces to control parameters or return value. So, Swift has a neat workaround: we can put that same information inside the braces, like this:
let sayHelloAgain = { (name: String) -> String in
    "Hi \(name)!"
}

sayHelloAgain("Lee")
/*
 1) The empty parentheses marks a function that takes no parameters.
 2) The arrow means just what it means when creating a function: we’re about to declare the return type for the function.
 3) Void means “nothing” – this function returns nothing. Sometimes you might see this written as (), but we usually avoid that because it can be confused with the empty parameter list.
 */

// It’s the in keyword, and it comes directly after the parameters and return type of the closure. Again, with a regular function the parameters and return type would come outside the braces, but we can’t do that with closures. So, in is used to mark the end of the parameters and return type – everything after that is the body of the closure itself. There’s a reason for this, and you’ll see it for yourself soon enough.

// However, as you’ll see this gets used extensively in Swift, and almost everywhere in SwiftUI. Seriously, you’ll use them in every SwiftUI app you write, sometimes hundreds of times – maybe not necessarily in the form you see above, but you’re going to be using it a lot.

var greetCopyAgain: () -> Void = greetUser

func getUserData(for id: Int) -> String {
    if id == 1989 {
        return "Taylor Swift"
    } else {
        return "Anonymous"
    }
}

let data: (Int) -> String = getUserData
let user = data(1989)
print(user)

let team = ["Gloria", "Suzanne", "Piper", "Tiffany", "Tasha"]
let sortedTeam = team.sorted()
print(sortedTeam)

func captainFirstSorted(name1: String, name2: String) -> Bool {
    if name1 == "Suzanne" {
        return true
    } else if name2 == "Suzanne" {
        return false
    }
    
    return name1 < name2
}

let captainFirstTeam = team.sorted(by: captainFirstSorted)
print(captainFirstTeam)

let captainFirstTeamAgain = team.sorted(by: { (name1: String, name2: String) -> Bool in
    if name1 == "Suzanne" {
        return true
    } else if name2 == "Suzanne" {
        return false
    }
    return name1 < name2
})

/*
 1) We’re calling the sorted() function as before.
 2) Rather than passing in a function, we’re passing a closure – everything from the opening brace after by: down to the closing brace on the last line is part of the closure.
 3) Directly inside the closure we list the two parameters sorted() will pass us, which are two strings. We also say that our closure will return a Boolean, then mark the start of the closure’s code by using in.
 4) Everything else is just normal function code.
 */

// What the heck are closures and why does Swift love them so much?
/*
 Go on, admit it: you asked yourself exactly this question. If you didn’t I’d be surprised, because closures are one of the most powerful features of Swift but also easily the feature that confuses people.
 
 So, if you’re sitting here thinking “wow, closures are really hard”, don’t be dismayed – they are hard, and you finding them hard just means your brain is operating correctly.
 
 One of the most common reasons for closures in Swift is to store functionality – to be able to say “here’s some work I want you to do at some point, but not necessarily now.” Some examples:
 
 - Running some code after a delay.
 - Running some code after an animation has finished.
 - Running some code when a download has finished.
 - Running some code when a user has selected an option from your menu.
 
 Closures let us wrap up some functionality in a single variable, then store that somewhere. We can also return it from a function, and store the closure somewhere else.
 
 When you’re learning, closures are a little hard to read – particularly when they accept and/or return their own parameters. But that’s OK: take small steps, and backtrack if you get stuck, and you’ll be fine.
 */

// Why are Swift’s closure parameters inside the braces?
// Both closures and functions can take parameters, but the way they take parameters is very different. Here’s a function that accepts a string and an integer:
func pay(user: String, amount: Int) {
    // code
}

// And here’s exactly the same thing written as a closure:
let payment = { (user: String, amount: Int) in
    // code
}

// As you can see, the parameters have moved inside the braces, and the in keyword is there to mark the end of the parameter list and the start of the closure’s body itself. Closures take their parameters inside the brace to avoid confusing Swift: if we had written let payment = (user: String, amount: Int) then it would look like we were trying to create a tuple, not a closure, which would be strange. If you think about it, having the parameters inside the braces also neatly captures the way that whole thing is one block of data stored inside the variable – the parameter list and the closure body are all part of the same lump of code, and stored in our variable. Having the parameter list inside the braces shows why the in keyword is so important – without that it’s hard for Swift to know where your closure body actually starts, because there’s no second set of braces.

// How do you return a value from a closure that takes no parameters?
// Closures in Swift have a distinct syntax that really separates them from simple functions, and one place that can cause confusion is how we accept and return parameters.

// First, here’s a closure that accepts one parameter and returns nothing:
let paymentOnParameter = { (user: String) in
    print("Paying \(user)…")
}

// Now here’s a closure that accepts one parameter and returns a Boolean:
let paymentReturnBool = { (user: String) -> Bool in
    print("Paying \(user)…")
    return true
}

// If you want to return a value without accepting any parameters, you can’t just write -> Bool in – Swift won’t understand what you mean. Instead, you should use empty parentheses for your parameter list, like this:
let paymentNoParameterReturnBool = { () -> Bool in
    print("Paying an anonymous person…")
    return true
}

// 2) How to use trailing closures and shorthand syntax
// Swift has a few tricks up its sleeve to reduce the amount of syntax that comes with closures, but first let’s remind ourselves of the problem. Here’s the code we ended up with at the end of the previous chapter:
let teamAgain = ["Gloria", "Suzanne", "Piper", "Tiffany", "Tasha"]

let captainFirstTeamAgainAgain = teamAgain.sorted(by: { (name1: String, name2: String) -> Bool in
    if name1 == "Suzanne" {
        return true
    } else if name2 == "Suzanne" {
        return false
    }
    
    return name1 < name2
})

print(captainFirstTeamAgainAgain)

// Think it through: in this code, the function we provide to sorted() must provide two strings and return a Boolean, so why do we need to repeat ourselves in our closure? The answer is: we don’t. We don’t need to specify the types of our two parameters because they must be strings, and we don’t need to specify a return type because it must be a Boolean. So, we can rewrite the code to this:
let captainFirstTeamShorter = teamAgain.sorted { name1, name2 in
    if name1 == "Suzanne" {
        return true
    } else if name2 == "Suzanne" {
        return false
    }
    return name1 < name2
}

// Rather than passing the closure in as a parameter, we just go ahead and start the closure directly – and in doing so remove (by: from the start, and a closing parenthesis at the end. Hopefully you can now see why the parameter list and in come inside the closure, because if they were outside it would look even weirder! There’s one last way Swift can make closures less cluttered: Swift can automatically provide parameter names for us, using shorthand syntax. With this syntax we don’t even write name1, name2 in any more, and instead rely on specially named values that Swift provides for us: $0 and $1, for the first and second strings respectively. Using this syntax our code becomes even shorter:

let captainFirstTeamShorterLastone = team.sorted {
    if $0 == "Suzanne" {
        return true
    } else if $1 == "Suzanne" {
        return false
    }
    return $0 < $1
}

let reverseTeam = team.sorted {
    return $0 > $1
}

let reverseTeamShortest = team.sorted { $0 > $1 }

// More Examples
let tOnly = team.filter { $0.hasPrefix("T") }
print(tOnly)

let uppercaseTeam = team.map { $0.uppercased() }
print(uppercaseTeam)

/*
 There are no fixed rules about when to use shorthand syntax and when not to, but in case it’s helpful I use shorthand syntax unless any of the following are true:
 
 The closure’s code is long.
 $0 and friends are used more than once each.
 You get three or more parameters (e.g. $2, $3, etc).
 
 Like I said, you’re going to be using closures a lot with SwiftUI:
 
 - When you create a list of data on the screen, SwiftUI will ask you to provide a function that accepts one item from the list and converts it something it can display on-screen.
 - When you create a button, SwiftUI will ask you to provide one function to execute when the button is pressed, and another to generate the contents of the button – a picture, or some text, and so on.
 - Even just putting stacking pieces of text vertically is done using a closure.
 */

// Why does Swift have trailing closure syntax?
// Trailing closure syntax is designed to make Swift code easier to read, although some prefer to avoid it. Let’s start with a simple example first. Here’s a function that accepts a Double then a closure full of changes to make:
/*
 animate(duration: 3, animations: {
 print("Fade out the image")
 })
 */
// Trailing closures work best when their meaning is directly attached to the name of the function – you can see what the closure is doing because the function is called animate().

// If you’re not sure whether to use trailing closures or not, my advice is to start using them everywhere. Once you’ve given them a month or two you’ll have enough usage to look back and decide more clearly, but hopefully you get used to them because they are really common in Swift!

// When should you use shorthand parameter names?
/*
 When working with closures, Swift gives us a special shorthand parameter syntax that makes it extremely concise to write closures. This syntax automatically numbers parameter names as $0, $1, $2, and so on – we can’t use names such as these in our own code, so when you see them it’s immediately clear these are shorthand syntax for closures.
 
 As for when you should use them it’s really a big “it depends”:
 
 Are there many parameters? If so, shorthand syntax stops being useful and in fact starts being counterproductive – was it $3 or $4 that you need to compare against $0 Give them actual names and their meaning becomes clearer.
 Is the function commonly used? As your Swift skills progress, you’ll start to realize that there are a handful – maybe 10 or so – extremely common functions that use closures, so others reading your code will easily understand what $0 means.
 Are the shorthand names used several times in your method? If you need to refer to $0 more than maybe two or three times, you should probably just give it a real name.
 What matters is that your code is easy to read and easy to understand. Sometimes that means making it short and simple, but not always – choose shorthand syntax on a case by case basis.
 */

// 3) How to accept functions as parameters
// There’s one last closure-related topic I want to look at, which is how to write functions that accept other functions as parameters. This is particularly important for closures because of trailing closure syntax, but it’s a useful skill to have regardless. I’ve added the type annotation in there intentionally, because that’s exactly what we use when specifying functions as parameters: we tell Swift what parameters the function accepts, as well its return type. Once again, brace yourself: the syntax for this is a little hard on the eyes at first! Here’s a function that generates an array of integers by repeating a function a certain number of times:

func makeArray(size: Int, using generator: () -> Int) -> [Int] {
    var numbers = [Int]()
    for _ in 0..<size {
        let newNumber = generator()
        numbers.append(newNumber)
    }
    return numbers
}

let rolls = makeArray(size: 50) {
    Int.random(in: 1...20)
}

print(rolls)

func generateNumber() -> Int {
    Int.random(in: 1...20)
}

let newRolls = makeArray(size: 50, using: generateNumber)
print(newRolls)

// There’s one last thing before we move on: you can make your function accept multiple function parameters if you want, in which case you can specify multiple trailing closures. The syntax here is very common in SwiftUI, so it’s important to at least show you a taste of it here. To demonstrate this here’s a function that accepts three function parameters, each of which accept no parameters and return nothing:
/*
 Let’s break that down…
 
 1) The function is called makeArray(). It takes two parameters, one of which is the number of integers we want, and also returns an array of integers.
 2) The second parameter is a function. This accepts no parameters itself, but will return one integer every time it’s called.
 3) Inside makeArray() we create a new empty array of integers, then loop as many times as requested.
 4) Each time the loop goes around we call the generator function that was passed in as a parameter. This will return one new integer, so we put that into the numbers array.
 5) Finally the finished array is returned.
 */

func doImportantWork(first: () -> Void, second: () -> Void, third: () -> Void) {
    print("About to start first work")
    first()
    print("About to start second work")
    second()
    print("About to start third work")
    third()
    print("Done!")
}

// When it comes to calling that, the first trailing closure is identical to what we’ve used already, but the second and third are formatted differently: you end the brace from the previous closure, then write the external parameter name and a colon, then start another brace.

// Here’s how that looks:
doImportantWork {
    print("This is the first work")
} second: {
    print("This is the second work")
} third: {
    print("This is the third work")
}

// Why would you want to use closures as parameters?
/*
 Swift’s closures can be used just like any other type of data, which means you can pass them into functions, take copies of them, and so on. But when you’re just learning, this can feel very much like “just because you can, doesn’t mean you should” – it’s hard to see the benefit.
 
 One of the best examples I can give is the way Siri integrates with apps. Siri is a system service that runs from anywhere on your iOS device, but it’s able to communicate with apps – you can book a ride with Lyft, you can check the weather with Carrot Weather, and so on. Behind the scenes, Siri launches a small part of the app in the background to pass on our voice request, then shows the app’s response as part of the Siri user interface.
 
 Now think about this: what if my app behaves badly, and takes 10 seconds to respond to Siri? Remember, the user doesn’t actually see my app, just Siri, so from their perspective it looks like Siri has completely frozen.
 
 This would be a terrible user experience, so Apple uses closures instead: it launches our app in the background and passes in a closure that we can call when we’re done. Our app then can take as long as it wants to figure out what work needs to be done, and when we’re finished we call the closure to send back data to Siri. Using a closure to send back data rather than returning a value from the function means Siri doesn’t need to wait for the function to complete, so it can keep its user interface interactive – it won’t freeze up.
 
 Another common example is making network requests. Your average iPhone can do several billion things a second, but connecting to a server in Japan takes half a second or more – it’s almost glacial compared to the speed things happen on your device. So, when we request data from the internet we do so with closures: “please fetch this data, and when you’re done run this closure.” Again, it means we don’t force our user interface to freeze while some slow work is happening.
 */

// 4) Summary: Closures
/*
 We’ve covered a lot about closures in the previous chapters, so let’s recap:
 
 - You can copy functions in Swift, and they work the same as the original except they lose their external parameter names.
 -  All functions have types, just like other data types. This includes the parameters they receive along with their return type, which might be Void – also known as “nothing”.
 - You can create closures directly by assigning to a constant or variable.
 - Closures that accept parameters or return a value must declare this inside their braces, followed by the keyword in.
 - Functions are able to accept other functions as parameters. They must declare up front exactly what data those functions must use, and Swift will ensure the rules are followed.
 - In this situation, instead of passing a dedicated function you can also pass a closure – you can make one directly. Swift allows both approaches to work.
 - When passing a closure as a function parameter, you don’t need to explicitly write out the types inside your closure if Swift can figure it out automatically. The same is true for the return value – if Swift can figure it out, you don’t need to specify it.
 - If one or more of a function’s final parameters are functions, you can use trailing closure syntax.
 - You can also use shorthand parameter names such as $0 and $1, but I would recommend doing that only under some conditions.
 - You can make your own functions that accept functions as parameters, although in practice it’s much more important to know how to use them than how to create them.
 - Of all the various parts of the Swift language, I’d say closures are the single toughest thing to learn. Not only is the syntax a little hard on your eyes at first, but the very concept of passing a function into a function takes a little time to sink in.
 
 - So, if you’ve read through these chapters and feel like your head is about to explode, that’s great – it means you’re half way to understanding closures!
 */

// 5) Checkpoint 5
/*
 With closures under your belt, it’s time to try a little coding challenge using them.
 
 You’ve already met sorted(), filter(), map(), so I’d like you to put them together in a chain – call one, then the other, then the other back to back without using temporary variables.
 
 Your input is this:
 */

let luckyNumbers = [7, 4, 38, 21, 16, 15, 12, 33, 31, 49]

/*
 Your job is to:
 
 Filter out any numbers that are even
 Sort the array in ascending order
 Map them to strings in the format “7 is a lucky number”
 Print the resulting array, one item per line
 So, your output should be as follows:
 
 7 is a lucky number
 15 is a lucky number
 21 is a lucky number
 31 is a lucky number
 33 is a lucky number
 49 is a lucky number
 
 1) You need to use the filter(), sorted(), and map() functions.
 2) The order you run the functions matters – if you convert the array to a string first, sorted() will do a string sort rather than an integer sort. That means 15 will come before 7, because Swift will compare the “1” in “15” against “7”.
 3) To chain these functions, use luckyNumbers.first { }.second { }, obviously putting the real function calls in there.
 4) You should use isMultiple(of:) to remove even numbers.
 */
