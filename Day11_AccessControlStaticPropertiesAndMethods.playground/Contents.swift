import Cocoa

// Day 11 – Access Control, Static Properties And Methods, And Checkpoint 6 : 03/11/2022

// 1) How to limit access to internal data using access control
// By default, Swift’s structs let us access their properties and methods freely, but often that isn’t what you want – sometimes you want to hide some data from external access. For example, maybe you have some logic you need to apply before touching your properties, or maybe you know that some methods need to be called in a certain way or order, and so shouldn’t be touched externally.

// We can demonstrate the problem with an example struct:

struct BankAccount {
    var funds = 0
    
    mutating func deposit(amount: Int) {
        funds += amount
    }
    
    mutating func withdraw(amount: Int) -> Bool {
        if funds > amount {
            funds -= amount
            return true
        } else {
            return false
        }
    }
}

// That has methods to deposit and withdraw money from a bank account, and should be used like this:

var account = BankAccount()
account.deposit(amount: 100)
let success = account.withdraw(amount: 200)

if success {
    print("Withdrew money successfully")
} else {
    print("Failed to get the money")
}

// But the funds property is just exposed to us externally, so what’s stopping us from touching it directly? The answer is nothing at all – this kind of code is allowed:

account.funds -= 1000

// That completely bypasses the logic we put in place to stop people taking out more money than they have, and now our program could behave in weird ways.

// To solve this, we can tell Swift that funds should be accessible only inside the struct – by methods that belong to the struct, as well as any computed properties, property observers, and so on.

// This takes only one extra word:

private var funds = 0

//And now accessing funds from outside the struct isn’t possible, but it is possible inside both deposit() and withdraw(). If you try to read or write funds from outside the struct Swift will refuse to build your code.

// This is called access control, because it controls how a struct’s properties and methods can be accessed from outside the struct.

// Swift provides us with several options, but when you’re learning you’ll only need a handful:
/*
 - Use private for “don’t let anything outside the struct use this.”
 - Use fileprivate for “don’t let anything outside the current file use this.”
 - Use public for “let anyone, anywhere use this.”
 - There’s one extra option that is sometimes useful for learners, which is this: private(set). This means “let anyone read this property, but only let my methods write it.” If we had used that with BankAccount, it would mean we could print account.funds outside of the struct, but only deposit() and withdraw() could actually change the value.
 */
// In this case, I think private(set) is the best choice for funds: you can read the current bank account balance at any time, but you can’t change it without running through my logic. If you think about it, access control is really about limiting what you and other developers on your team are able to do – and that’s sensible! If we can make Swift itself stop us from making mistakes, that’s always a smart move. Important: If you use private access control for one or more properties, chances are you’ll need to create your own initializer.

// 1.1)  What’s the point of access control?
/*
 Swift’s access control keywords let us restrict how different parts of our code can be accessed, but a lot of the time it’s just obeying the rules we put into place – we could remove them if we wanted and bypass the restrictions, so what’s the point?
 
 There are a few answers to that, but one is particularly easy so I’ll start there: sometimes access control is used in code you don’t own, so you can’t remove the restriction. This is common when you’re building apps with Apple’s APIs, for example: they place restrictions about what you can and cannot do, and you need to abide by those restrictions.
 
 In your own code, yes of course you can remove any access control restrictions you put in place, but that doesn’t make it pointless. Access control lets us determine how a value should be used, so that if something needs to accessed very carefully then you must follow the rules.
 
 Previously I’ve mentioned Unwrap, my Swift learning app, and I want to use another example from there. When users learn different parts of Swift, I store the name of the thing they learned in a private Set inside a User struct, declared like this:
 */

private var learnedSections = Set<String>()

/*
 It’s private, which means no one can read or write to it directly. Instead, I provide public methods for reading or writing values that should be used instead. That’s intentional, because learning a section needs to do more than just insert a string into that set – it needs to update the user interface to reflect the change, and needs to save the new information so the app remembers it was learned.
 
 If I hadn’t made the learnedSections property private, it’s possible I might forget and write things to it directly. That would result in my UI being inconsistent with its data, and also not saving the change – bad all around!
 
 So, by using private here I’m asking Swift to enforce the rules for me: don’t let me read or write this property from anywhere outside the User struct.
 
 One other advantage to access control is that it lets us control how other people see our code – known as its “surface area”. Think about it: if I gave you a struct to use and it had 30 public properties and methods, you might not be sure which ones are there for you to use and which ones are really just for internal use. On the other hand, if I mark 25 of those as private then it’s immediately clear that you shouldn’t be using them externally.
 
 Access control can be quite a thorny issue, particularly when you take into account external code. So, it’s not a surprise Apple’s own documentation on it is quite long – you can find it here: https://docs.swift.org/swift-book/LanguageGuide/AccessControl.html
 
 *** Access Levels ***
 
 - Swift provides five different access levels for entities within your code. These access levels are relative to the source file in which an entity is defined, and also relative to the module that source file belongs to.
 
 - Open access and public access enable entities to be used within any source file from their defining module, and also in a source file from another module that imports the defining module. You typically use open or public access when specifying the public interface to a framework. The difference between open and public access is described below.
 - Internal access enables entities to be used within any source file from their defining module, but not in any source file outside of that module. You typically use internal access when defining an app’s or a framework’s internal structure.
 - File-private access restricts the use of an entity to its own defining source file. Use file-private access to hide the implementation details of a specific piece of functionality when those details are used within an entire file.
 - Private access restricts the use of an entity to the enclosing declaration, and to extensions of that declaration that are in the same file. Use private access to hide the implementation details of a specific piece of functionality when those details are used only within a single declaration.
 - Open access is the highest (least restrictive) access level and private access is the lowest (most restrictive) access level.
 
 - Open access applies only to classes and class members, and it differs from public access by allowing code outside the module to subclass and override, as discussed below in Subclassing. Marking a class as open explicitly indicates that you’ve considered the impact of code from other modules using that class as a superclass, and that you’ve designed your class’s code accordingly.
 */
/*-----------------------------------------------------------*/
// 2) Static properties and methods
// You’ve seen how we can attach properties and methods to structs, and how each struct has its own unique copy of those properties so that calling a method on the struct won’t read the properties of a different struct from the same type.Well, sometimes – only sometimes – you want to add a property or method to the struct itself, rather than to one particular instance of the struct, which allows you to use them directly. I use this technique a lot with SwiftUI for two things: creating example data, and storing fixed data that needs to be accessed in various places. First, let’s look at a simplified example of how to create and use static properties and methods:

struct School {
    static var studentCount = 0
    
    static func add(student: String) {
        print("\(student) joined the school.")
        studentCount += 1
    }
}

//Notice the keyword static in there, which is what means both the studentCount and add() methods belong to the School struct itself rather than to individual instances of the struct. To use that code, we’d write the following:

School.add(student: "Taylor Swift")
print(School.studentCount)

// I haven’t created an instance of student – we can literally use add() and studentCount directly on the struct. This is because those are both static, which means they don’t exist uniquely on instances of the struct. This should also explain why we’re able to modify the studentCount property without marking the method as mutating – that’s only needed with regular struct functions for times when an instance of struct was created as a constant, and there is no instance when calling add(). If you want to mix and match static and non-static properties and methods, there are two rules:

// To access non-static code from static code… you’re out of luck: static properties and methods can’t refer to non-static properties and methods because it just doesn’t make sense – which instance of School would you be referring to?
// To access static code from non-static code, always use your type’s name such as School.studentCount. You can also use Self to refer to the current type.
// Now we have self and Self, and they mean different things: self refers to the current value of the struct, and Self refers to the current type.

// Tip: It’s easy to forget the difference between self and Self, but if you think about it it’s just like the rest of Swift’s naming – we start all our data types with a capital letter (Int, Double, Bool, etc), so it makes sense for Self to start with a capital letter too.

// Now, that sound you can hear is a thousand other learners saying “why the heck is this needed?” And I get it – this can seem like a rather redundant feature at first. So, I want to show you the two main ways I use static data. First, I use static properties to organize common data in my apps. For example, I might have a struct like AppData to store lots of shared values I use in many places:

struct AppData {
    static let version = "1.3 beta 2"
    static let saveFilename = "settings.json"
    static let homeURL = "https://www.hackingwithswift.com"
}

// Using this approach, everywhere I need to check or display something like my app’s version number – an about screen, debug output, logging information, support emails, etc – I can read AppData.version.

// The second reason I commonly use static data is to create examples of my structs. As you’ll see later on, SwiftUI works best when it can show previews of your app as you develop, and those previews often require sample data. For example, if you’re showing a screen that displays data on one employee, you’ll want to be able to show an example employee in the preview screen so you can check it all looks correct as you work. This is best done using a static example property on the struct, like this:

struct Employee {
    let username: String
    let password: String
    
    static let example = Employee(username: "cfederighi", password: "hairforceone")
}

// And now whenever you need an Employee instance to work with in your design previews, you can use Employee.example and you’re done. Like I said at the beginning, there are only a handful of occasions when a static property or method makes sense, but they are still a useful tool to have around.

// 2.1) What’s the point of static properties and methods in Swift?
// Most people learning Swift immediately see the value of regular properties and methods, but struggle to understand why static properties and methods would be useful. It’s certainly true that they are less useful than regular properties and methods, but they are still fairly common in Swift code. One common use for static properties and methods is to store common functionality you use across an entire app. For example, I make an app called Unwrap, which is a free iOS app for folks learning Swift. In the app I want to store some common information, such as the URL to the app on the App Store, so I can reference that anywhere the app needs it. So, I have code like this storing my data:

struct Unwrap {
    static let appURL = "https://itunes.apple.com/app/id1440611372"
}

// That way I can write Unwrap.appURL when someone shares something from the app, which helps other folks discover the app. Without the static keyword I’d need to make a new instance of the Unwrap struct just to read the fixed app URL, which isn’t really necessary. I also use both a static property and a static method to store some random entropy in the same struct, like this:

struct Entropy {
    static var entropy = Int.random(in: 1...1000)
    
    static func getEntropy() -> Int {
        entropy += 1
        return entropy
    }
}

// Random entropy is some randomness collected by software to make random number generation more effective, but I cheat a little in my app because I don’t want truly random data. The app is designed to give you various Swift tests in a random order, but if it were truly random then it’s likely you’d see the same question back to back sometimes. I don’t want that, so my entropy actually makes randomness less random so we get a fairer spread of questions. So, what my code does is store an entropy integer that starts off random, but increments by 1 every time getEntropy() is called. This “fair random” entropy is used throughout the app so that duplicates won’t appear, so again they are shared statically by the Unwrap struct so everywhere can access them. Before I move on, there are two more things I want to mention that might interest you. First, my Unwrap struct isn’t really a struct at all – I actually declare it as an enum rather than a struct. The enum doesn’t have any cases, but it’s a better choice than a struct here because I don’t ever want to create an instance of this type – there’s no reason to. Making an enum stops this from happening, which helps clarify my intent. Second, because I have a dedicated getEntropy() method, I actually ask Swift to restrict access to the entropy so that I can’t access it from anywhere. This is called access control, and look like this in Swift:

struct EntropyAgain {
    private static var entropy = Int.random(in: 1...1000)
}
// We’ll be looking more at access control in the very next chapter.
/*-----------------------------------------------------------*/
// 3) Summary: Structs
/*
 Structs are used almost everywhere in Swift: String, Int, Double, Array and even Bool are all implemented as structs, and now you can recognize that a function such as isMultiple(of:) is really a method belonging to Int.
 
 Let’s recap what else we learned:
 
 - You can create your own structs by writing struct, giving it a name, then placing the struct’s code inside braces.
 - Structs can have variable and constants (known as properties) and functions (known as methods)
 - If a method tries to modify properties of its struct, you must mark it as mutating.
 - You can store properties in memory, or create computed properties that calculate a value every time they are accessed.
 - We can attach didSet and willSet property observers to properties inside a struct, which is helpful when we need to be sure that some code is always executed when the property changes.
 - Initializers are a bit like specialized functions, and Swift generates one for all structs using their property names.
 - You can create your own custom initializers if you want, but you must always make sure all properties in your struct have a value by the time the initializer finishes, and before you call any other methods.
 - We can use access to mark any properties and methods as being available or unavailable externally, as needed.
 - It’s possible to attach a property or methods directly to a struct, so you can use them without creating an instance of the struct.
 */
/*-----------------------------------------------------------*/
// 4) Checkpoint 6
/*
 Structs sit at the core of every SwiftUI app, so it’s really important you take some extra time to make sure you understand what they do and how they work.
 
 To check your knowledge, here’s a small task for you: create a struct to store information about a car, including its model, number of seats, and current gear, then add a method to change gears up or down. Have a think about variables and access control: what data should be a variable rather than a constant, and what data should be exposed publicly? Should the gear-changing method validate its input somehow?
 
 As always I’ll write some hints below, but first I’m going to leave some space so you don’t see the hints by accident. As always, it’s a really good idea to try this challenge yourself before looking at the hints – it’s the fastest way to identify parts you feel less confident with.
 
 Still here? Okay, here are some hints:
 
 - A car’s model and seat count aren’t going to change once produced, so they can be constant. But its current gear clearly does change, so make that a variable.
 - Changing gears up or down should ensure such a change is possible – there is no gear 0, for example, and it’s safe to assume a maximum of 10 gears should cover most if not all cars.
 - If you use private access control, you will probably also need to create your own initializer. (Is private the best choice here? Try it for yourself and see what you think!)
 - Remember to use the mutating keyword on methods that change properties!
 */

struct Car {
    let model: String
    let seat: Int
    private var currentGear: Int {
        willSet {
            print("willSet - CurrentGear : \(currentGear), newValue : \(newValue)")
        }
        didSet {
            print("didSet - CurrentGear : \(currentGear), oldValue : \(oldValue)")
        }
    }
    
    init(model: String, seat: Int) {
        self.model = model
        self.seat = seat
        currentGear = 0
    }
    
    mutating func changeGearUp() {
        if currentGear == 10 {
            print("Can not change the gear up anymore, you are at the maximun gear. \(currentGear)")
        } else {
            currentGear += 1
        }
    }
    
    mutating func changeGearDown() {
        if currentGear == 0 {
            print("Can not change the gear down anymore, you are at the minumum gear. \(currentGear)")
        } else {
            currentGear -= 1
        }
    }
}

var myCar = Car(model: "Lincoln", seat: 4)
myCar.changeGearUp()
myCar.changeGearUp()
myCar.changeGearDown()
/*-----------------------------------------------------------*/
