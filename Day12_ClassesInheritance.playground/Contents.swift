import Cocoa

// Day 12 - Classes, Inheritance, And Checkpoint : 03/12/2022
// 1) How to create your own classes
/*
 Swift uses structs for storing most of its data types, including String, Int, Double, and Array, but there is another way to create custom data types called classes. These have many things in common with structs, but are different in key places. First, the things that classes and structs have in common include:
 - You get to create and name them.
 - You can add properties and methods, including property observers and access control.
 - You can create custom initializers to configure new instances however you want.
 
 ** However, classes differ from structs in five key places:
 - You can make one class build upon functionality in another class, gaining all its properties and methods as a starting point. If you want to selectively override some methods, you can do that too.
 - Because of that first point, Swift won’t automatically generate a memberwise initializer for classes. This means you either need to write your own initializer, or assign default values to all your properties.
 - When you copy an instance of a class, both copies share the same data – if you change one copy, the other one also changes.
 - When the final copy of a class instance is destroyed, Swift can optionally run a special function called a deinitializer.
 - Even if you make a class constant, you can still change its properties as long as they are variables.
 - On the surface those probably seem fairly random, and there’s a good chance you’re probably wondering why classes are even needed when we already have structs.
 
 However, SwiftUI uses classes extensively, mainly for point 3: all copies of a class share the same data. This means many parts of your app can share the same information, so that if the user changed their name in one screen all the other screens would automatically update to reflect that change.
 
 The other points matter, but are of varying use:
 
 - Being able to build one class based on another is really important in Apple’s older UI framework, UIKit, but is much less common in SwiftUI apps. In UIKit it was common to have long class hierarchies, where class A was built on class B, which was built on class C, which was built on class D, etc.
 - Lacking a memberwise initializer is annoying, but hopefully you can see why it would be tricky to implement given that one class can be based upon another – if class C added an extra property it would break all the initializers for C, B, and A.
 - Being able to change a constant class’s variables links in to the multiple copy behavior of classes: a constant class means we can’t change what pot our copy points to, but if the properties are variable we can still change the data inside the pot. This is different from structs, where each copy of a struct is unique and holds its own data.
 - Because one instance of a class can be referenced in several places, it becomes important to know when the final copy has been destroyed. That’s where the deinitializer comes in: it allows us to clean up any special resources we allocated when that last copy goes away.
 
 Before we’re done, let’s look at just a tiny slice of code that creates and uses a class:
 */
class Game {
    var score = 0 {
        didSet {
            print("Score is now \(score)")
        }
    }
}

var newGame = Game()
newGame.score += 10
/* Yes, the only difference between that and a struct is that it was created using class rather than struct – everything else is identical. That might make classes seem redundant, but trust me: all five of their differences are important.
 
 I’ll be going into more detail on the five differences between classes and structs in the following chapters, but right now the most important thing to know is this: structs are important, and so are classes – you will need both when using SwiftUI.
 */

// 1.1) Why does Swift have both classes and structs?
/*
 Classes and structs give Swift developers the ability to create custom, complex types with properties and methods, but they have five important differences:
 
 - Classes do not come with synthesized memberwise initializers.
 - One class can be built upon (“inherit from”) another class, gaining its properties and methods.
 - Copies of structs are always unique, whereas copies of classes actually point to the same shared data.
 - Classes have deinitializers, which are methods that are called when an instance of the class is destroyed, but structs do not.
 - Variable properties in constant classes can be modified freely, but variable properties in constant structs cannot.
 I’ll explain these differences in more detail soon, but the point is that they exist and that they matter. Most Swift developers prefer to use structs rather than classes when possible, which means when you choose a class over a struct you’re doing so because you want one of the above behaviors.
 */

// 1.2) Why don’t Swift classes have a memberwise initializer?
/*
 One of the many useful features of Swift’s struct is that they come with a synthesized memberwise initializer, letting us create new instances of the struct just by specifying its properties. However, Swift’s classes don’t have this feature, which is annoying – but why don’t they have it?
 
 The main reason is that classes have inheritance, which would make memberwise initializers difficult to work with. Think about it: if I built a class that you inherited from, then added some properties to my class later on, your code would break – all those places you relied on my memberwise initializer would suddenly no longer work.
 
 So, Swift has a simple solution: rather than automatically generating a memberwise initializer, authors of classes must write their own initializer by hand. This way, you can add properties as much as you want without affecting the initializer for your class, and affecting others who inherit from your class. And when you do decide to change your initializer, you’re doing so yourself, and are therefore fully aware of the implications for any inheriting classes.
 */
/*-------------------------------------------------------*/
// 2) How to make one class inherit from another
// Swift lets us create classes by basing them on existing classes, which is a process known as inheritance. When one class inherits functionality from another class (its “parent” or “super” class), Swift will give the new class access (the “child class” or “subclass”) to the properties and methods from that parent class, allowing us to make small additions or changes to customize the way the new class behaves. To make one class inherit from another, write a colon after the child class’s name, then add the parent class’s name. For example, here is an Employee class with one property and an initializer:

class Employee {
    let hours: Int
    
    init(hours: Int) {
        self.hours = hours
    }
    
    // As well as sharing properties, you can also share methods, which can then be called from the child classes. As an example, try adding this to the Employee class:
    func printSummary() {
        print("I work \(hours) hours a day.")
    }
}

// We could make two subclasses of Employee, each of which will gain the hours property and initializer:

class Developer: Employee {
    func work() {
        print("I'm writing code for \(hours) hours.")
    }
    
    // This is where Swift enforces a simple rule: if a child class wants to change a method from a parent class, you must use override in the child class’s version. This does two things: If you attempt to change a method without using override, Swift will refuse to build your code. This stops you accidentally overriding a method. If you use override but your method doesn’t actually override something from the parent class, Swift will refuse to build your code because you probably made a mistake. So, if we wanted developers to have a unique printSummary() method, we’d add this to the Developer class:
    override func printSummary() {
        print("I'm a developer who will sometimes work \(hours) a day, but other times spend hours arguing about whether code should be indented using tabs or spaces.")
    }
}

class Manager: Employee {
    func work() {
        print("I'm going to meetings for \(hours) hours.")
    }
}

class Worker: Employee {
    func work() {
        print("I'm going to meetings for \(hours) hours.")
    }
    
    override func printSummary() {
        super.printSummary()
        print("I am just a worker who don't like to work longer than \(hours) a day.")
    }
}
// Notice how those two child classes can refer directly to hours – it’s as if they added that property themselves, except we don’t have to keep repeating ourselves. Each of those classes inherit from Employee, but each then adds their own customization. So, if we create an instance of each and call work(), we’ll get a different result:

let robert = Developer(hours: 8)
let joseph = Manager(hours: 10)
robert.work()
joseph.work()

// Because Developer inherits from Employee, we can immediately start calling printSummary() on instances of Developer, like this:

let novall = Developer(hours: 8)
novall.printSummary()
joseph.printSummary()

let lee = Worker(hours: 6)
lee.printSummary()

// Things get a little more complicated when you want to change a method you inherited. For example, we just put printSummary() into Employee, but maybe one of those child classes wants slightly different behavior. Swift is smart about how method overrides work: if your parent class has a work() method that returns nothing, but the child class has a work() method that accepts a string to designate where the work is being done, that does not require override because you aren’t replacing the parent method.

// Tip: If you know for sure that your class should not support inheritance, you can mark it as final. This means the class itself can inherit from other things, but can’t be used to inherit from – no child class can use a final class as its parent.

// 2.1) When would you want to override a method?
/*
 In Swift, any class that inherits from a parent class can override the methods and sometimes the properties of that parent class, which means they can replace the parent’s method implementation with one of their own.
 
 This level of customization is really important, and makes our lives easier as developers. Think about it: if someone has designed a brilliant class that you want to use, but it isn’t quite right, wouldn’t it be nice to just override one part of its behavior rather than having to rewrite the whole thing yourself?
 
 Sure it would, and that’s exactly where method overriding comes in: you can keep all the behavior you want, and just change one or two little parts in a custom subclass.
 
 In UIKit, Apple’s original user interface framework for iOS, this approach was used a lot. For example, consider some of the built-in apps such as Settings and Messages. Both of these present information in rows: Settings has rows such as General, Control Center, Display & Brightness, and so on, and Messages has individual rows for each conversation you’ve had with different people. In UIKit these are called tables, and they have some common behavior: you can scroll through all the rows, you can tap on the rows to select one, there are little gray arrows on the right side of the rows, and so on.
 
 These lists of rows are very common, so Apple provided us existing code to use them that has all that standard behavior built right in. Of course, there are some bits that actually need to change, such as how many rows the lists have and what content they have inside. So, Swift developers would create subclasses of Apple’s table and override the parts they wanted to change, giving them all the built-in functionality and lots of flexibility and control.
 
 Swift makes us use the override keyword before overriding functions, which is really helpful:
 
 If you use it when it isn’t needed (because the parent class doesn’t declare the same method) then you’ll get an error. This stops you from mistyping things, such as parameter names or types, and also stops your override from failing if the parent class changes its method and you don’t follow suit.
 If you don’t use it when it is needed, then you’ll also get an error. This stops you from accidentally changing behavior from the parent class.
 */
// 2.2) Which classes should be declared as final?
/*
 Final classes are ones that cannot be inherited from, which means it’s not possible for users of your code to add functionality or change what they have. This is not the default: you must opt in to this behavior by adding the final keyword to your class.
 
 Remember, anyone who subclasses your class can override your properties and perhaps also your methods, which offers them incredible power. If you do something they don’t like, bam – they can just replace that. They might still call your original method as well as their replacement, but they might not.
 
 This can be problematic: perhaps your class does something really important that mustn’t be replaced, or perhaps you have clients on a support contract and you don’t want them breaking the way your code works.
 
 Much of Apple’s own code was written before Swift came along, in an earlier language called Objective-C. Objective-C didn’t have great support for final classes, so Apple usually resorted to large warnings on their site. For example, there’s a very important class called AVPlayerViewController that is designed to play movies, and its documentation page has a large yellow warning saying: “Subclassing AVPlayerViewController and overriddng its methods isn’t supported, and results in undefined behavior.” We don’t know why, only that we shouldn’t do it. There’s another class called Timer that handles timed events like an alarm, and there the warning is even simpler: “Do not subclass Timer”.
 
 In Swift it used to be the case that final classes were more performant than non-final classes, because we were providing a little bit more information about how our code would run and Swift would use that to make some optimizations.
 
 That hasn’t been true for a while, but even today I think many people instinctively declare their classes as final to mean “you shouldn’t subclass from this unless I specifically allow it.” I certainly do this a lot, because it’s another way I can help folks understand how my code works.
 */
/*-------------------------------------------------------*/
// 3) How to add initializers for classes
//Class initializers in Swift are more complicated than struct initializers, but with a little cherrypicking we can focus on the part that really matters: if a child class has any custom initializers, it must always call the parent’s initializer after it has finished setting up its own properties, if it has any. Like I said previously, Swift won’t automatically generate a memberwise initializer for classes. This applies with or without inheritance happening – it will never generate a memberwise initializer for you. So, you either need to write your own initializer, or provide default values for all the properties of the class. Let’s start by defining a new class:

class Vehicle {
    let isElectric: Bool
    
    init(isElectric: Bool) {
        self.isElectric = isElectric
    }
}
// That has a single Boolean property, plus an initializer to set the value for that property. Remember, using self here makes it clear we’re assigning the isElectric parameter to the property of the same name. Now, let’s say we wanted to make a Car class inheriting from Vehicle – you might start out writing something like this:
/* This class will not run
 class Car: Vehicle {
 let isConvertible: Bool
 
 init(isConvertible: Bool) {
 self.isConvertible = isConvertible
 }
 }
 */
// But Swift will refuse to build that code: we’ve said that the Vehicle class needs to know whether it’s electric or not, but we haven’t provided a value for that. What Swift wants us to do is provide Car with an initializer that includes both isElectric and isConvertible, but rather than trying to store isElectric ourselves we instead need to pass it on – we need to ask the super class to run its own initializer. Here’s how that looks:

class CarWithSuperClassInit: Vehicle {
    let isConvertible: Bool
    
    init(isElectric: Bool, isConvertible: Bool) {
        self.isConvertible = isConvertible
        // super is another one of those values that Swift automatically provides for us, similar to self: it allows us to call up to methods that belong to our parent class, such as its initializer. You can use it with other methods if you want; it’s not limited to initializers.
        super.init(isElectric: isElectric)
    }
}

// Now that we have a valid initializer in both our classes, we can make an instance of Car like so:

let teslaX = CarWithSuperClassInit(isElectric: true, isConvertible: false)
// Tip: If a subclass does not have any of its own initializers, it automatically inherits the initializers of its parent class.
/*-------------------------------------------------------*/
// 4) How to copy classes
// In Swift, all copies of a class instance share the same data, meaning that any changes you make to one copy will automatically change the other copies. This happens because classes are reference types in Swift, which means all copies of a class all refer back to the same underlying pot of data. To see this in action, try this simple class:

class UserWithNoCopyMethod {
    var username = "Anonymous"
}

// That has just one property, but because it’s stored inside a class it will get shared across all copies of the class. So, we could create an instance of that class:

var user1UserWithNoCopyMethod = UserWithNoCopyMethod()

//We could then take a copy of user1 and change the username value:

var user2UserWithNoCopyMethod = user1UserWithNoCopyMethod
user2UserWithNoCopyMethod.username = "Taylor"
//I hope you see where this is going! Now we’ve changed the copy’s username property we can then print out the same properties from each different copy:

print(user1UserWithNoCopyMethod.username)
print(user2UserWithNoCopyMethod.username)
//…and that’s going to print “Taylor” for both – even though we only changed one of the instances, the other also changed. This might seem like a bug, but it’s actually a feature – and a really important feature too, because it’s what allows us to share common data across all parts of our app. As you’ll see, SwiftUI relies very heavily on classes for its data, specifically because they can be shared so easily. In comparison, structs do not share their data amongst copies, meaning that if we change class User to struct User in our code we get a different result: it will print “Anonymous” then “Taylor”, because changing the copy didn’t also adjust the original. If you want to create a unique copy of a class instance – sometimes called a deep copy – you need to handle creating a new instance and copy across all your data safely. In our case that’s straightforward:

class User {
    var username = "Anonymous"
    
    func copy() -> User {
        let user = User()
        user.username = username
        return user
    }
}

let user1 = User()
user1.username = "Lee"
let user2 = User()
user2.username = "Lee Copy"
user2.copy()
print(user1.username)
print(user2.username)

// Now we can safely call copy() to get an object with the same starting data, but any future changes won’t impact the original.

// 4.1) Why do copies of a class share their data?
/*
 One feature of Swift that is truly confusing at first is how the behaviors of its classes and structs differ when they are copied: copies of the same class share their underlying data, meaning that changing one changes them all, whereas structs always have their own unique data, and changing a copy does not affect the others.
 
 The technical term for this distinction is “value types vs reference types.” Structs are value types, which means they hold simple values such as the number 5 or the string “hello”. It doesn’t matter how many properties or methods your struct has, it’s still considered one simple value like a number. On the other hand, classes are reference types, which means they refer to a value somewhere else.
 
 For value types, this is easy enough to understand that it’s self-evident. For example, look at this code:
 
 var message = "Welcome"
 var greeting = message
 greeting = "Hello"
 When that code runs, message will still be set to “Welcome”, but greeting will be set to “Hello”. As Chris Eidhof says, “this is so natural it seems like stating the obvious.” (https://chris.eidhof.nl/post/structs-and-mutation-in-swift/) But that’s how structs behave: their value are wholly contained inside their variable, and not somehow shared with other values. This means all their data is stored directly in each variable, so when you copy it you get a deep copy of all the data.
 
 In contrast, the best way to think about a reference type is that it’s like a signpost pointing to some data. If we create an instance of a class, it will take up some memory on your iPhone, and the variable that stores the instance is really just a signpost to the actual memory where the object lives. If you take a copy of the object, you get a new signpost but it still points to the memory where the original object lives. This is why changing one instance of a class changes them all: all copies of the object are signposts pointing to the same piece of memory.
 
 It’s hard to overestimate how important this difference is in Swift development. Previously I mentioned that Swift developers prefer to use structs for their custom types, and this copy behavior is a big reason. Imagine if you had a big app and wanted to share a User object in various places – what would happen if one of those places changed your user? If you were using a class, all the other places that used your user would have their data changed without realizing it, and you might end up with problems. But if you were using a struct, every part of your app has its own copy of the data and it can’t be changed by surprise.
 
 As with many things in programming, the choices you make should help convey a little of your reasoning. In this case, using a class rather than a struct sends a strong message that you want the data to be shared somehow, rather than having lots of distinct copies.
 */
/*-------------------------------------------------------*/
// 5) How to create a deinitializer for a class
// Swift’s classes can optionally be given a deinitializer, which is a bit like the opposite of an initializer in that it gets called when the object is destroyed rather than when it’s created. This comes with a few small provisos: Just like initializers, you don’t use func with deinitializers – they are special. Deinitializers can never take parameters or return data, and as a result aren’t even written with parentheses. Your deinitializer will automatically be called when the final copy of a class instance is destroyed. That might mean it was created inside a function that is now finishing, for example. We never call deinitializers directly; they are handled automatically by the system. Structs don’t have deinitializers, because you can’t copy them. Exactly when your deinitializers are called depends on what you’re doing, but really it comes down to a concept called scope. Scope more or less means “the context where information is available”, and you’ve seen lots of examples already:
/*
 - If you create a variable inside a function, you can’t access it from outside the function.
 - If you create a variable inside an if condition, that variable is not available outside the condition.
 - If you create a variable inside a for loop, including the loop variable itself, you can’t use it outside the loop.
 - If you look at the big picture, you’ll see each of those use braces to create their scope: conditions, loops, and functions all create local scopes.
 */

// When a value exits scope we mean the context it was created in is going away. In the case of structs that means the data is being destroyed, but in the case of classes it means only one copy of the underlying data is going away – there might still be other copies elsewhere. But when the final copy goes away – when the last constant or variable pointing at a class instance is destroyed – then the underlying data is also destroyed, and the memory it was using is returned back to the system. To demonstrate this, we could create a class that prints a message when it’s created and destroyed, using an initializer and deinitializer:

class UserDeinit {
    let id: Int
    
    init(id: Int) {
        self.id = id
        print("User \(id): I'm alive!")
    }
    
    deinit {
        print("User \(id): I'm dead!")
    }
}

// Now we can create and destroy instances of that quickly using a loop – if we create a User instance inside the loop, it will be destroyed when the loop iteration finishes:

for i in 1...3 {
    let user = UserDeinit(id: i)
    print("User \(user.id): I'm in control!")
}

// When that code runs you’ll see it creates and destroys each user individually, with one being destroyed fully before another is even created. Remember, the deinitializer is only called when the last remaining reference to a class instance is destroyed. This might be a variable or constant you have stashed away, or perhaps you stored something in an array. For example, if we were adding our User instances as they were created, they would only be destroyed when the array is cleared:

var users = [UserDeinit]()

for i in 1...3 {
    let user = UserDeinit(id: i)
    print("User \(user.id): I'm in control!")
    users.append(user)
}

print("Loop is finished!")
users.removeAll()
print("Array is clear!")

// 5.1) Why do classes have deinitializers and structs don’t?
/*
 One small but important feature of classes is that they can have a deinitializer function – a counterpart to init() that gets run when the class instance gets destroyed. Structs don’t have deinitializers, which means we can’t tell when they are destroyed.
 
 The job of deinitializers is to tell us when a class instance was destroyed. For structs this is fairly simple: the struct is destroyed when whatever owns it no longer exists. So, if we create a struct inside a method and the methods ends, the struct is destroyed.
 
 However, classes have complex copying behavior that means several copies of the class can exist in various parts of your program. All the copies point to the same underlying data, and so it’s now much harder to tell when the actual class instance is destroyed – when the final variable pointing to it has gone away.
 
 Behind the scenes Swift performs something called automatic reference counting, or ARC. ARC tracks how many copies of each class instance exists: every time you take a copy of a class instance Swift adds 1 to its reference count, and every time a copy is destroyed Swift subtracts 1 from its reference count. When the count reaches 0 it means no one refers to the class any more, and Swift will call its deinitializer and destroy the object.
 
 So, the simple reason for why structs don’t have deinitializers is because they don’t need them: each struct has its own copy of its data, so nothing special needs to happen when it is destroyed.
 
 You can put your deinitializer anywhere you want in your code, but I love this quote from Anne Cahalan: “Code should read like sentences, which makes me think my classes should read like chapters. So the deinitializer goes at the end, it's the ~fin~ of the class!”
 */
/*-------------------------------------------------------*/
// 6) How to work with variables inside classes
// Swift’s classes work a bit like signposts: every copy of a class instance we have is actually a signpost pointing to the same underlying piece of data. Mostly this matters because of the way changing one copy changes all the others, but it also matters because of how classes treat variable properties. This one small code sample demonstrates how things work:

class UserWithVariable {
    var name = "Paul"
}

let user = UserWithVariable()
user.name = "Taylor"
print(user.name)

// That creates a constant User instance, but then changes it – it changes the constant value. That’s bad, right? Except it doesn’t change the constant value at all. Yes, the data inside the class has changed, but the class instance itself – the object we created – has not changed, and in fact can’t be changed because we made it constant. Think of it like this: we created a constant signpoint pointing towards a user, but we erased that user’s name tag and wrote in a different name. The user in question hasn’t changed – the person still exists – but a part of their internal data has changed. Now, if we had made the name property a constant using let, then it could not be changed – we have a constant signpost pointing to a user, but we’ve written their name in permanent ink so that it can’t be erased. In contrast, what happens if we made both the user instance and the name property variables? Now we’d be able to change the property, but we’d also be able to change to a wholly new User instance if we wanted. To continue the signpost analogy, it would be like turning the signpost to point at wholly different person.Try it with this code:

class UserWithVariableAgain {
    var name = "Paul"
}

var userUserWithVariableAgain = UserWithVariableAgain()
userUserWithVariableAgain.name = "Taylor"
userUserWithVariableAgain = UserWithVariableAgain()
print(user.name)
// That would end up printing “Paul”, because even though we changed name to “Taylor” we then overwrote the whole user object with a new one, resetting it back to “Paul”. The final variation is having a variable instance and constant properties, which would mean we can create a new User if we want, but once it’s done we can’t change its properties. So, we end up with four options:

/*
 - Constant instance, constant property – a signpost that always points to the same user, who always has the same name.
 - Constant instance, variable property – a signpost that always points to the same user, but their name can change.
 - Variable instance, constant property – a signpost that can point to different users, but their names never change.
 - Variable instance, variable property – a signpost that can point to different users, and those users can also change their names.
 */

// This might seem awfully confusing, and perhaps even pedantic. However, it serves an important purpose because of the way class instances get shared. Let’s say you’ve been given a User instance. Your instance is constant, but the property inside was declared as a variable. This tells you not only that you can change that property if you want to, but more importantly tells you there’s the possibility of the property being changed elsewhere – that class you have could be a copy from somewhere else, and because the property is variable it means some other part of code could change it by surprise. When you see constant properties it means you can be sure neither your current code nor any other part of your program can change it, but as soon as you’re dealing with variable properties – regardless of whether the class instance itself is constant or not – it opens up the possibility that the data could change under your feet. This is different from structs, because constant structs cannot have their properties changed even if the properties were made variable. Hopefully you can now see why this happens: structs don’t have the whole signpost thing going on, they hold their data directly. This means if you try to change a value inside the struct you’re also implicitly changing the struct itself, which isn’t possible because it’s constant. One upside to all this is that classes don’t need to use the mutating keyword with methods that change their data. This keyword is really important for structs because constant structs cannot have their properties changed no matter how they were created, so when Swift sees us calling a mutating method on a constant struct instance it knows that shouldn’t be allowed. With classes, how the instance itself was created no longer matters – the only thing that determines whether a property can be modified or not is whether the property itself was created as a constant. Swift can see that for itself just by looking at how you made the property, so there’s no more need to mark the method specially.

// 6.1)  Why can variable properties in constant classes be changed?
// One of the small but important differences between structs and classes is the way they handle mutability of properties:
/*
 - Variable classes can have variable properties changed
 - Constant classes can have variable properties changed
 - Variable structs can have variable properties changed
 - Constant structs cannot have variable properties changed
 */

// The reason for this lies in the fundamental difference between a class and a struct: one points to some data in memory, whereas the other is one value such as the number 5. Consider code such as this:

var number = 5
number = 6

// We can’t simply define the number 5 to be 6, because that wouldn’t make sense – it would break everything we know about mathematics. Instead, that code removes the existing value assigned to number and gives it the number 6 instead. That’s how structs work in Swift: when we change one of its properties, we are in fact changing the entire struct. Sure, behind the scenes Swift can do some optimization so that it isn’t really throwing away the whole value every time we change just one part of it, but that’s how it’s treated from our perspective. So, if changing one part of a struct effectively means destroying and recreating the entire struct, hopefully you can see why constant structs don’t allow their variable properties to be changed – it would mean destroying and recreating something that is supposed to be constant, which isn’t possible. Classes don’t work this way: you can change any part of their properties without having to destroy and recreate the value. As a result, constant classes can have their variable properties changed freely.
/*-------------------------------------------------------*/
// 7) Summary: Classes
/*
 Classes aren’t quite as commonly used as structs, but they serve an invaluable purpose for sharing data, and if you ever choose to learn Apple’s older UIKit framework you’ll find yourself using them extensively.
 
 Let’s recap what we learned:
 
 - Classes have lots of things in common with structs, including the ability to have properties and methods, but there are five key differences between classes and structs.
 - First, classes can inherit from other classes, which means they get access to the properties and methods of their parent class. You can optionally override methods in child classes if you want, or mark a class as being final to stop others subclassing it.
 - Second, Swift doesn’t generate a memberwise initializer for classes, so you need to do it yourself. If a subclass has its own initializer, it must always call the parent class’s initializer at some point.
 - Third, if you create a class instance then take copies of it, all those copies point back to the same instance. This means changing some data in one of the copies changes them all.
 - Fourth, classes can have deinitializers that run when the last copy of one instance is destroyed.
 - Finally, variable properties inside class instances can be changed regardless of whether the instance itself was created as variable.
 */
/*-------------------------------------------------------*/
// 8) Checkpoint 7
/* Now that you understand how classes work, and, just as importantly, how they are different from structs, it’s time to tackle a small challenge to check your progress.
 
 Your challenge is this: make a class hierarchy for animals, starting with Animal at the top, then Dog and Cat as subclasses, then Corgi and Poodle as subclasses of Dog, and Persian and Lion as subclasses of Cat.
 
 But there’s more:
 
 - The Animal class should have a legs integer property that tracks how many legs the animal has.
 - The Dog class should have a speak() method that prints a generic dog barking string, but each of the subclasses should print something slightly different.
 - The Cat class should have a matching speak() method, again with each subclass printing something different.
 - The Cat class should have an isTame Boolean property, provided using an initializer.
 - I’ll provide some hints in a moment, but first I recommend you go ahead and try it yourself.
 
 *** Still here? Okay, here are some hints:
 
 - You’ll need seven independent classes here, of which only one has no parent class.
 - To make one class inherit from another, write it like this: class SomeClass: OtherClass.
 - You can make subclasses have a different speak() method to their parent by using the override keyword.
 - All our subclasses have four legs, but you still need to make sure you pass that data up to the Animal class inside the Cat initializer.
 */

class Animal {
    let legs: Int
    
    init(legs: Int) {
        self.legs = legs
    }
    
    func speak(_ sound: String) {
        print("Animal Speaking with the sould : \(sound)")
    }
    
    deinit {
        print("Animal was deinit. - Dead in Code -")
    }
}

class Dog : Animal {
    
    func printDog() {
        print("I am a dog.")
    }
    
    override func speak(_ sound: String) {
        print("Woof Woof!")
    }
}

final class Cargi : Dog {
    override func printDog() {
        super.printDog()
        print("I am a Cargi, not just a dog.")
    }
}

final class Poodle : Dog {
    override func printDog() {
        print("I am a Poodle, not just a dog.")
    }
}

class Cat : Animal {
    let isTame: Bool
    
    init(isTame: Bool, legs: Int) {
        self.isTame = isTame
        super.init(legs: legs)
    }
    
    func printCat() {
        print("I am a cat.")
    }
    
    override func speak(_ sound: String) {
        super.speak(sound)
        print("Meows Meows!")
    }
}

final class Persian : Cat {
    override func printCat() {
        print("I am a Persian Cat.")
    }
}

final class Lion : Cat {
    override func printCat() {
        super.printCat()
        print("I am a Lion Cat.")
    }
    
    override func speak(_ sound: String) {
        super.speak(sound)
        print("I don't want to sound like \(sound), but I am a cat.")
    }
}

let animal = Animal(legs: 2)
let dog = Dog(legs: 4)
let cat = Cat(isTame: true, legs: 4)
let dog1 = Cargi(legs: 4)
let dog2 = Poodle(legs: 4)
let cat1 = Persian(isTame: true, legs: 4)
let cat2 = Lion(isTame: false, legs: 4)

animal.speak("Not Sure ! how I sound..... ????")
dog.speak("Woof")
dog1.speak("Dog 1")
dog2.speak("Dog 2")
dog2.printDog()
dog1.printDog()
cat.speak("Meow")
cat1.speak("Cat 1")
cat2.speak("Cat 2")

/*-------------------------------------------------------*/

