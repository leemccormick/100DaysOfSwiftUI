import Cocoa

var greeting = "Hello, playground"

// Day 8 - Function Part 2 : 03/08/2022
// 1) How to provide default values for parameters
//  Swift lets us specify default values for any or all of our parameters. In this case, we could set end to have the default value of 12, meaning that if we don’t specify it 12 will be used automatically. Default parameter values let us keep flexibility in our functions without making them annoying to call most of the time – you only need to send in some parameters when you need something unusual.


func printTimesTables(for number: Int, end: Int = 12) {
    for i in 1...end {
        print("\(i) x \(number) is \(i * number)")
    }
}

printTimesTables(for: 5, end: 20)
printTimesTables(for: 8)

var characters = ["Lana", "Pam", "Ray", "Sterling"]
print(characters.count)
characters.removeAll()
print(characters.count)
characters.removeAll(keepingCapacity: true)
// This is accomplished using a default parameter value: keepingCapacity is a Boolean with the default value of false so that it does the sensible thing by default, while also leaving open the option of us passing in true for times we want to keep the array’s existing capacity.

// When to use default parameters for functions
// Default parameters let us make functions easier to call by letting us provide common defaults for parameters. So, when we want to call that function using those default values we can just ignore the parameters entirely – as if they didn’t exist – and our function will just do the right thing. Of course, when we want something custom it’s there for us to change.Swift developers use default parameters very commonly, because they let us focus on the important parts that do need to change regularly. This can really help simplify complex function, and make your code easier to write. That assumes that most of the time folks want to drive between two locations by the fastest route, without avoiding highways – sensible defaults that are likely to work most of the time, while giving us the scope to provide custom values when needed.
func findDirections(from: String, to: String, route: String = "fastest", avoidHighways: Bool = false) {
    // code here
}

// As a result, we can call that same function in any of three ways:
findDirections(from: "London", to: "Glasgow")
findDirections(from: "London", to: "Glasgow", route: "scenic")
findDirections(from: "London", to: "Glasgow", route: "scenic", avoidHighways: true)

// 2) How to handle errors in functions
/*
 This takes three steps:
 
 1) Telling Swift about the possible errors that can happen.
 2) Writing a function that can flag up errors if they happen.
 3) Calling that function, and handling any errors that might happen.
 */

// That says there are two possible errors with password: short and obvious. It doesn’t define what those mean, only that they exist.

// Most errors thrown by Apple provide a meaningful message that you can present to your user if needed. Swift makes this available using an error value that’s automatically provided inside your catch block, and it’s common to read error.localizedDescription to see exactly what happened.

enum PasswordError: Error {
    case short, obvious
}

func checkPassword(_ password: String) throws -> String {
    if password.count < 5 {
        throw PasswordError.short
    }
    
    if password == "12345" {
        throw PasswordError.obvious
    }
    
    if password.count < 8 {
        return "OK"
    } else if password.count < 10 {
        return "Good"
    } else {
        return "Excellent"
    }
}

let string = "12345"

do {
    let result = try checkPassword(string)
    print("Password rating: \(result)")
} catch {
    print("There was an error.")
}

do {
    let result = try checkPassword(string)
    print("Password rating: \(result)")
} catch PasswordError.short {
    print("Please use a longer password.")
} catch PasswordError.obvious {
    print("I have the same combination on my luggage!")
} catch {
    print("There was an error.")
}

/*
 Let’s break that down…
 
 1) If a function is able to throw errors without handling them itself, you must mark the function as throws before the return type.
 2) We don’t specify exactly what kind of error is thrown by the function, just that it can throw errors.
 3) Being marked with throws does not mean the function must throw errors, only that it might.
 4) When it comes time to throw an error, we write throw followed by one of our PasswordError cases. This immediately exits the function, meaning that it won’t return a string.
 5) If no errors are thrown, the function must behave like normal – it needs to return a string.
 
 That completes the second step of throwing errors: we defined the errors that might happen, then wrote a function using those errors.
 
 The final step is to run the function and handle any errors that might happen. Swift Playgrounds are pretty lax about error handling because they are mostly meant for learning, but when it comes to working with real Swift projects you’ll find there are three steps:
 
 Starting a block of work that might throw errors, using do.
 Calling one or more throwing functions, using try.
 Handling any thrown errors using catch.
 
 In pseudocode, it looks like this:
 
 do {
 try someRiskyWork()
 } catch {
 print("Handle errors here")
 }
 */

// When should you write throwing functions?
// Throwing functions in Swift are those that are able to encounter errors they are unable or unwilling to handle. That doesn’t mean they will throw errors, just that it’s possible they can. As a result, Swift will make sure we’re careful when we use them, so that any errors that do occur are catered for. But when you’re writing your code, chances are you’ll think to yourself “should this function throw any errors it encounters, or should it maybe handle them itself?” This is really common, and to be honest there is no single answer – you can handle the errors inside the function (thus making it not a throwing function), you can send them all back to whatever called the function (called “error propagation” or sometimes “bubbling up errors”), and you can even handle some errors in the function and send some back. All of those are valid solutions, and you will use all of them at some point.When you’re just getting started, I would recommend you avoid throwing functions most of the time. They can feel a bit clumsy at first because you need to make sure all the errors are handled wherever you use the function, so it feels almost a bit “infectious” – suddenly you have errors needing to be handled in several places in your code, and if those errors bubble up further then the “infection” just spreads. So, when you’re learning start small: keep the number of throwing functions low, and work outwards from there. Over time you’ll get a get better grip on managing errors to keep your program flow smooth, and you’ll feel more confident about adding throwing functions. For a different perspective on throwing functions, see this blog post from Donny Wals: https://www.donnywals.com/working-with-throwing-functions-in-swift/

// Why does Swift make us use try before every throwing function?
// Using Swift’s throwing functions relies on three unique keywords: do, try, and catch. We need all three to be able to call a throwing function, which is unusual – most other languages use only two, because they don’t need to write try before every throwing function. The reason Swift is different is fairly simple: by forcing us to use try before every throwing function, we’re explicitly acknowledging which parts of our code can cause errors. This is particularly useful if you have several throwing functions in a single do block, like this:

/*
 do {
 try throwingFunction1()
 nonThrowingFunction1()
 try throwingFunction2()
 nonThrowingFunction2()
 try throwingFunction3()
 } catch {
 // handle errors
 }
 */

// As you can see, using try makes it clear that the first, third, and fifth function calls can throw errors, but the second and fourth cannot.

// 3) Summary Fuctions
/*
 - Functions let us reuse code easily by carving off chunks of code and giving it a name.
 - All functions start with the word func, followed by the function’s name. The function’s body is contained inside opening and closing braces.
 - We can add parameters to make our functions more flexible – list them out one by one separated by commas: the name of the parameter, then a colon, then the type of the parameter.
 - You can control how those parameter names are used externally, either by using a custom external parameter name or by using an underscore to disable the external name for that parameter.
 - If you think there are certain parameter values you’ll use repeatedly, you can make them have a default value so your function takes less code to write and does the smart thing by default.
 - Functions can return a value if you want, but if you want to return multiple pieces of data from a function you should use a tuple. These hold several named elements, but it’s limited in a way a dictionary is not – you list each element specifically, along with its type.
 - Functions can throw errors: you create an enum defining the errors you want to happen, throw those errors inside the function as needed, then use do, try, and catch to handle them at the call site.
 */

// 4) Checkpoint
/*
 The challenge is this: write a function that accepts an integer from 1 through 10,000, and returns the integer square root of that number. That sounds easy, but there are some catches:
 
 - You can’t use Swift’s built-in sqrt() function or similar – you need to find the square root yourself.
 - If the number is less than 1 or greater than 10,000 you should throw an “out of bounds” error.
 - You should only consider integer square roots – don’t worry about the square root of 3 being 1.732, for example.
 - If you can’t find the square root, throw a “no root” error.
 - As a reminder, if you have number X, the square root of X will be another number that, when multiplied by itself, gives X. So, the square root of 9 is 3, because 3x3 is 9, and the square root of 25 is 5, because 5x5 is 25.
 
 - This is a problem you should “brute force” – create a loop with multiplications inside, looking for the integer you were passed in.
 - The square root of 10,000 – the largest number I want you to handle – is 100, so your loop should stop there.
 - If you reach the end of your loop without finding a match, throw the “no root” error.
 - You can define different out of bounds errors for “less than 1” and “greater than 10,000” if you want, but it’s not really necessary – just having one is fine.
 */
// Squar Root Error
enum SquarRootError: Error {
    case tooLittle
    case tooMuch
    case noRoot
}

// Squar Root Function
func squareRoot(of number: Int) throws -> Int {
    if number < 1 {
        throw SquarRootError.tooLittle
    } else if number > 10_00 {
        throw SquarRootError.tooMuch
    }
    var nReturn: Int?
    for i in 0...number {
        if i * i == number {
            nReturn = i
            break
        }
    }
    if let n = nReturn {
        return n
    } else {
        throw SquarRootError.noRoot
    }
}

// Call Throw Function
do {
    let result = try squareRoot(of: 16)
    print("Result of square root : \(result)")
} catch SquarRootError.tooLittle {
    print("Error : Number is less than 1.")
} catch SquarRootError.tooMuch {
    print("Error : Number is more than 10000.")
} catch SquarRootError.noRoot {
    print("Error : No Root Found.")
} catch {
    print("Error : Error On Square Root Function.")
}
