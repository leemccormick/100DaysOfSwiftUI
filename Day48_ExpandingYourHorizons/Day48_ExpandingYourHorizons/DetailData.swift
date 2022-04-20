//
//  DetailData.swift
//  Day48_ExpandingYourHorizons
//
//  Created by Lee McCormick on 4/19/22.
//

import Foundation

struct DetailData {
    
    let valueType =  """
    Value and Reference Types
    
    Types in Swift fall into one of two categories: first, “value types”, where each instance keeps a unique copy of its data, usually defined as a struct, enum, or tuple. The second, “reference types”, where instances share a single copy of the data, and the type is usually defined as a class. In this post we explore the merits of value and reference types, and how to choose between them.
    
    What’s the Difference?
    The most basic distinguishing feature of a value type is that copying — the effect of assignment, initialization, and argument passing — creates an independent instance with its own unique copy of its data:
    
    // Value type example
    struct S { var data: Int = -1 }
    var a = S()
    var b = a                        // a is copied to b
    a.data = 42                      // Changes a, not b
                                     // output "42, -1"
    Copying a reference, on the other hand, implicitly creates a shared instance. After a copy, two variables then refer to a single instance of the data, so modifying data in the second variable also affects the original, e.g.:
    
    // Reference type example
    class C { var data: Int = -1 }
    var x = C()
    var y = x                        // x is copied to y
    x.data = 42                      // changes the instance referred to by x (and y)
                                    // prints "42, 42"
    
    The Role of Mutation in Safety
    One of the primary reasons to choose value types over reference types is the ability to more easily reason about your code. If you always get a unique, copied instance, you can trust that no other part of your app is changing the data under the covers. This is especially helpful in multi-threaded environments where a different thread could alter your data out from under you. This can create nasty bugs that are extremely hard to debug.
    Because the difference is defined in terms of what happens when you change data, there’s one case where value and reference types overlap: when instances have no writable data. In the absence of mutation, values and references act exactly the same way.
    You may be thinking that it could be valuable, then, to have a case where a class is completely immutable. This would make it easier to use Cocoa NSObject objects, while maintaining the benefits of value semantics. Today, you can write an immutable class in Swift by using only immutable stored properties and avoiding exposing any APIs that can modify state. In fact, many common Cocoa classes, such as NSURL, are designed as immutable classes. However, Swift does not currently provide any language mechanism to enforce class immutability (e.g. on subclasses) the way it enforces immutability for struct and enum.
    
    How to Choose?
    So if you want to build a new type, how do you decide which kind to make? When you’re working with Cocoa, many APIs expect subclasses of NSObject, so you have to use a class. For the other cases, here are some guidelines:
    Use a value type when:
    - Comparing instance data with == makes sense
    - You want copies to have independent state
    - The data will be used in code across multiple threads
    - Use a reference type (e.g. use a class) when:
    - Comparing instance identity with === makes sense
    - You want to create shared, mutable state
    
    In Swift, Array, String, and Dictionary are all value types. They behave much like a simple int value in C, acting as a unique instance of that data. You don’t need to do anything special — such as making an explicit copy — to prevent other code from modifying that data behind your back. Importantly, you can safely pass copies of values across threads without synchronization. In the spirit of improving safety, this model will help you write more predictable code in Swift.
    """
    
    let optionals = """
    Optional
    A type that represents either a wrapped value or nil, the absence of a value.
    
    Overview
    You use the Optional type whenever you use optional values, even if you never type the word Optional. Swift’s type system usually shows the wrapped type’s name with a trailing question mark (?) instead of showing the full type name. For example, if a variable has the type Int?, that’s just another way of writing Optional<Int>. The shortened form is preferred for ease of reading and writing code.
    
    Overview
    You use the Optional type whenever you use optional values, even if you never type the word Optional. Swift’s type system usually shows the wrapped type’s name with a trailing question mark (?) instead of showing the full type name. For example, if a variable has the type Int?, that’s just another way of writing Optional<Int>. The shortened form is preferred for ease of reading and writing code.
    
    The types of shortForm and longForm in the following code sample are the same:
    let shortForm: Int? = Int("42")
    let longForm: Optional<Int> = Int("42")
    
    The Optional type is an enumeration with two cases. Optional.none is equivalent to the nil literal. Optional.some(Wrapped) stores a wrapped value. For example:
    let number: Int? = Optional.some(42)
    let noNumber: Int? = Optional.none
    print(noNumber == nil)
    // Prints "true"
    
    You must unwrap the value of an Optional instance before you can use it in many contexts. Because Swift provides several ways to safely unwrap optional values, you can choose the one that helps you write clear, concise code.
    
    The following examples use this dictionary of image names and file paths:
    let imagePaths = ["star": "/glyphs/star.png",
                      "portrait": "/images/content/portrait.jpg",
                      "spacer": "/images/shared/spacer.gif"]
    
    Getting a dictionary’s value using a key returns an optional value, so imagePaths["star"] has type Optional<String> or, written in the preferred manner, String?.
    
    1) Optional Binding
    To conditionally bind the wrapped value of an Optional instance to a new variable, use one of the optional binding control structures, including if let, guard let, and switch.
    if let starPath = imagePaths["star"] {
        print(The star image is at starPath)
    } else {
        print("Couldn't find the star image")
    }
    // Prints "The star image is at '/glyphs/star.png'"
    
    2) Optional Chaining
    To safely access the properties and methods of a wrapped instance, use the postfix optional chaining operator (postfix ?). The following example uses optional chaining to access the hasSuffix(_:) method on a String? instance.
    if imagePaths["star"]?.hasSuffix(".png") == true {
        print("The star image is in PNG format")
    }
    // Prints "The star image is in PNG format"
    
    3) Using the Nil-Coalescing Operator
    Use the nil-coalescing operator (??) to supply a default value in case the Optional instance is nil. Here a default path is supplied for an image that is missing from imagePaths.
    let defaultImagePath = "/images/default.png"
    let heartPath = imagePaths["heart"] ?? defaultImagePath
    print(heartPath)
    // Prints "/images/default.png"
    The ?? operator also works with another Optional instance on the right-hand side. As a result, you can chain multiple ?? operators together.
    let shapePath = imagePaths["cir"] ?? imagePaths["squ"] ?? defaultImagePath
    print(shapePath)
    // Prints "/images/default.png"
    
    4) Unconditional Unwrapping
    When you’re certain that an instance of Optional contains a value, you can unconditionally unwrap the value by using the forced unwrap operator (postfix !). For example, the result of the failable Int initializer is unconditionally unwrapped in the example below.
    let number = Int("42")!
    print(number)
    // Prints "42"
    You can also perform unconditional optional chaining by using the postfix ! operator.
    let isPNG = imagePaths["star"]!.hasSuffix(".png")
    print(isPNG)
    // Prints "true"
    Unconditionally unwrapping a nil instance with ! triggers a runtime error.
    """
    
    let protocols = """
    Swift Protocols
    
    In this tutorial, we will learn about Swift protocols with the help of examples.
    
    In Swift, a protocol defines a blueprint of methods or properties that can then be adopted by classes (or any other types).
    
    We use the protocol keyword to define a protocol. For example,
    
    protocol Greet {
    
      // blueprint of a property
      var name: String { get }
    
    
      // blueprint of a method
      func message()
    }
    Here,
    
    Greet - name of the protocol
    name - a gettable property
    message() - method definition without any implementation
    Notes:
    
    The protocol just holds the method or properties definition, not their actual body.
    The protocol must specify whether the property will be gettable or gettable and settable.
    Conform Class To Swift Protocol
    
    In Swift, to use a protocol, other classes must conform to it. After we conform a class to the protocol, we must provide an actual implementation of the method.
    
    Here's how to conform a class to the protocol,
    
    // conform class to Greet protocol
    class Employee: Greet {
    
      // implementation of property
      var name = "Perry"
    
      // implementation of method
      func message() {
        print("Good Morning!")
      }
    }
    Here, we have conformed the Employee class to the Greet protocol. So, we must provide an implementation of the name property and the message() method.
    
    Example 1: Swift Protocol
    
    protocol Greet {
      
      // blueprint of property
      var name: String { get }
    
      // blueprint of a method
      func message()
    }
    
    // conform class to Greet protocol
    class Employee: Greet {
    
      // implementation of property
      var name = "Perry"
    
      // implementation of method
      func message() {
        print("Good Morning", name)
      }
    }
    
    var employee1 = Employee()
    employee1.message()
    Output
    
    Good Morning Perry
    In the above example, we have created a protocol named Greet. The protocol contains a blueprint of the name property and the message() method.
    
    Here, the Employee class conforms to Greet and provides the actual implementation of name and message().
    
    Example 2: Swift Protocol To Calculate Area
    
    protocol Polygon {
    
      func getArea(length: Int, breadth: Int)
    }
    
    // conform the Polygon protocol
    class Rectangle: Polygon {
    
      // implementation of method
      func getArea(length: Int, breadth: Int) {
        print("Area of the rectangle:", length * breadth)
      }
    }
    
    // create an object
    var r1 = Rectangle()
    
    r1.getArea(length:5, breadth: 6)
    Output
    
    Area of the rectangle: 30
    In the above example, we have created a protocol named Polygon. The protocol contains a blueprint of the getArea() method with two parameters: length and breadth.
    
    Here, the Rectangle class conforms to Polygon and provides the actual implementation of the getArea() method.
    
    func getArea(length: Int, breadth: Int) {
      print("Area of the rectangle:", length * breadth)
    }
    Conforming Multiple Protocols
    
    In Swift, a class can also conform to multiple protocols. For example,
    
    protocol Sum {
      ...
    }
    
    protocol Multiplication {
      ...
    }
    
    class Calculate: Sum, Multiplication {
      ...
    }
    Here, the class named Calculate conforms to the Sum and Multiplication protocols.
    
    Example 3: Conforming Multiple Protocols
    
    // create Sum protocol
    protocol Sum {
    
      func addition()
    }
    
    // create Multiplication protocol
    protocol Multiplication {
    
      func product()
    }
    
    // conform class to two protocols
    class Calculate: Sum, Multiplication {
    
      var num1 = 0
      var num2 = 0
    
      func addition () {
        let result1 = num1 + num2
        print("Sum:", result1)
      }
    
      func product () {
        let result2 = num1 * num2
        print("Product:", result2)
      }
                       
    }
    
    // create an object
    var calc1 = Calculate()
    
    // assign values to properties
    calc1.num1 = 5
    calc1.num2 = 10
    
    // access methods
    calc1.addition()
    calc1.product()
    Output
    
    Sum: 15
    Product: 50
    """
    
    let forceUnwrap = """
    Force Unwrap
    Optionals represent data that may or may not be there, but sometimes you know for sure that a value isn’t nil. In these cases, Swift lets you force unwrap the optional: convert it from an optional type to a non-optional type.
    
    For example, if you have a string that contains a number, you can convert it to an Int like this:
    
    let str = "5"
    let num = Int(str)
    That makes num an optional Int because you might have tried to convert a string like “Fish” rather than “5”.
    
    Even though Swift isn’t sure the conversion will work, you can see the code is safe so you can force unwrap the result by writing ! after Int(str), like this:
    
    let num = Int(str)!
    Swift will immediately unwrap the optional and make num a regular Int rather than an Int?. But if you’re wrong – if str was something that couldn’t be converted to an integer – your code will crash.
    
    As a result, you should force unwrap only when you’re sure it’s safe – there’s a reason it’s often called the crash operator.
    """
    
    let architecture = """
    iOS Architecture Patterns
    Feeling weird while doing MVC in iOS? Have doubts about switching to MVVM? Heard about VIPER, but not sure if it worth it?
    Keep reading, and you will find answers to questions above, if you don’t — feel free to complain in comments.
    You are about to structure your knowledge about architectural patterns in iOS environment. We’ll briefly review some popular ones and compare them in theory and practice going over a few tiny examples. Follow links if you need more details about any particular one.
    Mastering design patterns might be addictive, so beware: you might end up asking yourself more questions now than before reading this article, like these:
    Who supposed to own networking request: a Model or a Controller?
    How do I pass a Model into a View Model of a new View?
    Who creates a new VIPER module: Router or Presenter?
    
    Why care about choosing the architecture?
    Because if you don’t, one day, debugging a huge class with dozens different things, you’ll find yourself being unable to find and fix any bugs in your class.”. Naturally, it is hard to keep this class in mind as whole entity, thus, you’ll always be missing some important details. If you are already in this situation with your application, it is very likely that:
    This class is the UIViewController subclass.
    Your data stored directly in the UIViewController
    Your UIViews do almost nothing
    The Model is a dumb data structure
    Your Unit Tests cover nothing
    And this can happen, even despite the fact that you are following Apple’s guidelines and implementing Apple’s MVC pattern, so don’t feel bad. There is something wrong with the Apple’s MVC, but we’ll get back to it later.
    Let’s define features of a good architecture:
    Balanced distribution of responsibilities among entities with strict roles.
    Testability usually comes from the first feature (and don’t worry: it is easy with appropriate architecture).
    Ease of use and a low maintenance cost.
    Why Distribution?
    Distribution keeps a fair load on our brain while we trying to figure out how things work. If you think the more you develop the better your brain will adapt to understanding complexity, then you are right. But this ability doesn’t scale linearly and reaches the cap very quickly. So the easiest way to defeat complexity is to divide responsibilities among multiple entities following the single responsibility principle.
    Why Testability?
    This is usually not a question for those who already felt gratitude to unit tests, which failed after adding new features or due to refactoring some intricacies of the class. This means the tests saved those developers from finding issues in runtime, which might happen when an app is on a user’s device and the fix takes a week to reach the user.
    Why Ease of use?
    This does not require an answer but it is worth mentioning that the best code is the code that has never been written. Therefore the less code you have, the less bugs you have. This means that desire to write less code should never be explained solely by laziness of a developer, and you should not favour a smarter solution closing your eyes to its maintenance cost.
    MV(X) essentials
    Nowadays we have many options when it comes to architecture design patterns:
    MVC
    MVP
    MVVM
    VIPER
    First three of them assume putting the entities of the app into one of 3 categories:
    Models — responsible for the domain data or a data access layer which manipulates the data, think of ‘Person’ or ‘PersonDataProvider’ classes.
    Views — responsible for the presentation layer (GUI), for iOS environment think of everything starting with ‘UI’ prefix.
    Controller/Presenter/ViewModel — the glue or the mediator between the Model and the View, in general responsible for altering the Model by reacting to the user’s actions performed on the View and updating the View with changes from the Model.
    Having entities divided allows us to:
    understand them better (as we already know)
    reuse them (mostly applicable to the View and the Model)
    test them independently
    Let’s start with MV(X) patterns and get back to VIPER later.
    MVC
    How it used to be
    Before discussing Apple’s vision of MVC let’s have a look on the traditional one.
    
    Traditional MVC
    In this case, the View is stateless. It is simply rendered by the Controller once the Model is changed. Think of the web page completely reloaded once you press on the link to navigate somewhere else. Although it is possible to implement the traditional MVC in iOS application, it doesn’t make much sense due to the architectural problem — all three entities are tightly coupled, each entity knows about the other two. This dramatically reduces reusability of each of them — that is not what you want to have in your application. For this reason, we skip even trying to write a canonical MVC example.
    Traditional MVC doesn't seems to be applicable to modern iOS development.
    Apple’s MVC
    Expectation
    
    Cocoa MVC
    The Controller is a mediator between the View and the Model so that they don’t know about each other. The least reusable is the Controller and this is usually fine for us, since we must have a place for all that tricky business logic that doesn’t fit into the Model.
    In theory, it looks very straightforward, but you feel that something is wrong, right? You even heard people unabbreviating MVC as the Massive View Controller. Moreover, view controller offloading became an important topic for the iOS developers. Why does this happen if Apple just took the traditional MVC and improved it a bit?
    Apple’s MVC
    Reality
    
    Realistic Cocoa MVC
    Cocoa MVC encourages you to write Massive View Controllers, because they are so involved in View’s life cycle that it’s hard to say they are separate. Although you still have ability to offload some of the business logic and data transformation to the Model, you don’t have much choice when it comes to offloading work to the View, at most of times all the responsibility of the View is to send actions to the Controller. The view controller ends up being a delegate and a data source of everything, and is usually responsible for dispatching and cancelling the network requests and… you name it.
    How many times have you seen code like this:
    The cell, which is the View configured directly with the Model, so MVC guidelines are violated, but this happens all the time, and usually people don’t feel it is wrong. If you strictly follow the MVC, then you supposed to configure the cell from the controller, and don’t pass the Model into the View, and this will increase the size of your Controller even more.
    Cocoa MVC is reasonably unabbreviated as the Massive View Controller.
    The problem might not be evident until it comes to the Unit Testing (hopefully, it does in your project). Since your view controller is tightly coupled with the view, it becomes difficult to test because you have to be very creative in mocking views and their life cycle, while writing the view controller’s code in such a way, that your business logic is separated as much as possible from the view layout code.
    Let’s have a look on the simple playground example:
    UPD: See updated code examples by Wasin Thonkaew
    MVC example
    MVC assembling can be performed in the presenting view controller
    This doesn’t seem very testable, right? We can move generation of greeting into the new GreetingModel class and test it separately, but we can’t test any presentation logic (although there is not much of such logic in the example above) inside the GreetingViewController without calling the UIView related methods directly (viewDidLoad, didTapButton) which might cause loading all views, and this is bad for the unit testing.
    In fact, loading and testing UIViews on one simulator (e.g. iPhone 4S) doesn’t guarantee that it would work fine on the other devices (e.g. iPad), so I’d recommend to remove “Host Application” from your Unit Test target configuration and run your tests without your application running on simulator.
    The interactions between the View and the Controller aren’t really testable with Unit Tests
    With all that said, it might seems that Cocoa MVC is a pretty bad pattern to choose. But let’s assess it in terms of features defined in the beginning of the article:
    Distribution — the View and the Model in fact separated, but the View and the Controller are tightly coupled.
    Testability — due to the bad distribution you’ll probably only test your Model.
    Ease of use — the least amount of code among others patterns. In addition everyone is familiar with it, thus, it’s easily maintained even by the unexperienced developers.
    Cocoa MVC is the pattern of your choice if you are not ready to invest more time in your architecture, and you feel that something with higher maintenance cost is an overkill for your tiny pet project.
    Cocoa MVC is the best architectural pattern in terms of the speed of the development.
    MVP
    Cocoa MVC’s promises delivered
    
    Passive View variant of MVP
    Doesn’t it look exactly like the Apple’s MVC? Yes, it does, and it’s name is MVP (Passive View variant). But wait a minute… Does this mean that Apple’s MVC is in fact a MVP? No, its not, because if you recall, there, the View is tightly coupled with the Controller, while the MVP’s mediator, Presenter, has nothing to do with the life cycle of the view controller, and the View can be mocked easily, so there is no layout code in the Presenter at all, but it is responsible for updating the View with data and state.
    
    What if I told you, the UIViewController is the View.
    In terms of the MVP, the UIViewController subclasses are in fact the Views and not the Presenters. This distinction provides superb testability, which comes at cost of the development speed, because you have to make manual data and event binding, as you can see from the example:
    MVP example
    Important note regarding assembly
    The MVP is the first pattern that reveals the assembly problem which happens due to having three actually separate layers. Since we don’t want the View to know about the Model, it is not right to perform assembly in presenting view controller (which is the View), thus we have to do it somewhere else. For example, we can make the app-wide Router service which will be responsible for performing assembly and the View-to-View presentation. This issue arises and has to be addressed not only in the MVP but also in all the following patterns.
    Let’s look on the features of the MVP:
    Distribution — we have the most of responsibilities divided between the Presenter and the Model, with the pretty dumb View (in the example above the Model is dumb as well).
    Testability — is excellent, we can test most of the business logic due to the dumb View.
    Easy of use — in our unrealistically simple example, the amount of code is doubled compared to the MVC, but at the same time, idea of the MVP is very clear.
    MVP in iOS means superb testability and a lot of code.
    MVP
    With Bindings and Hooters
    There is the other flavour of the MVP — the Supervising Controller MVP. This variant includes direct binding of the View and the Model while the Presenter (The Supervising Controller) still handles actions from the View and is capable of changing the View.
    
    Supervising Presenter variant of the MVP
    But as we have already learned before, vague responsibility separation is bad, as well as tight coupling of the View and the Model. That is similar to how things work in Cocoa desktop development.
    Same as with the traditional MVC, I don’t see a point in writing an example for the flawed architecture.
    MVVM
    The latest and the greatest of the MV(X) kind
    The MVVM is the newest of MV(X) kind thus, let’s hope it emerged taking into account problems MV(X) was facing previously.
    In theory the Model-View-ViewModel looks very good. The View and the Model are already familiar to us, but also the Mediator, represented as the View Model.
    
    MVVM
    It is pretty similar to the MVP:
    the MVVM treats the view controller as the View
    There is no tight coupling between the View and the Model
    In addition, it does binding like the Supervising version of the MVP; however, this time not between the View and the Model, but between the View and the View Model.
    So what is the View Model in the iOS reality? It is basically UIKit independent representation of your View and its state. The View Model invokes changes in the Model and updates itself with the updated Model, and since we have a binding between the View and the View Model, the first is updated accordingly.
    Bindings
    I briefly mentioned them in the MVP part, but let’s discuss them a bit here. Bindings come out of box for the OS X development, but we don’t have them in the iOS toolbox. Of course we have the KVO and notifications, but they aren’t as convenient as bindings.
    So, provided we don’t want to write them ourselves, we have two options:
    One of the KVO based binding libraries like the RZDataBinding or the SwiftBond
    The full scale functional reactive programming beasts like ReactiveCocoa, RxSwift or PromiseKit.
    In fact, nowadays, if you hear “MVVM” — you think ReactiveCocoa, and vice versa. Although it is possible to build the MVVM with the simple bindings, ReactiveCocoa (or siblings) will allow you to get most of the MVVM.
    There is one bitter truth about reactive frameworks: the great power comes with the great responsibility. It’s really easy to mess up things when you go reactive. In other words, if you do something wrong, you might spend a lot of time debugging the app, so just take a look at this call stack.
    
    Reactive Debugging
    In our simple example, the FRF framework or even the KVO is an overkill, instead we’ll explicitly ask the View Model to update using showGreeting method and use the simple property for greetingDidChange callback function.
    MVVM example
    And again back to our feature assessment:
    Distribution — it is not clear in our tiny example, but, in fact, the MVVM’s View has more responsibilities than the MVP’s View. Because the first one updates it’s state from the View Model by setting up bindings, when the second one just forwards all events to the Presenter and doesn’t update itself.
    Testability — the View Model knows nothing about the View, this allows us to test it easily. The View might be also tested, but since it is UIKit dependant you might want to skip it.
    Easy of use — its has the same amount of code as the MVP in our example, but in the real app where you’d have to forward all events from the View to the Presenter and to update the View manually, MVVM would be much skinnier if you used bindings.
    The MVVM is very attractive, since it combines benefits of the aforementioned approaches, and, in addition, it doesn’t require extra code for the View updates due to the bindings on the View side. Nevertheless, testability is still on a good level.
    VIPER
    LEGO building experience transferred into the iOS app design
    VIPER is our last candidate, which is particularly interesting because it doesn’t come from the MV(X) category.
    By now, you must agree that the granularity in responsibilities is very good. VIPER makes another iteration on the idea of separating responsibilities, and this time we have five layers.
    
    VIPER
    Interactor — contains business logic related to the data (Entities) or networking, like creating new instances of entities or fetching them from the server. For those purposes you’ll use some Services and Managers which are not considered as a part of VIPER module but rather an external dependency.
    Presenter — contains the UI related (but UIKit independent) business logic, invokes methods on the Interactor.
    Entities — your plain data objects, not the data access layer, because that is a responsibility of the Interactor.
    Router — responsible for the segues between the VIPER modules.
    Basically, VIPER module can be a one screen or the whole user story of your application — think of authentication, which can be one screen or several related ones. How small are your “LEGO” blocks supposed to be? — It’s up to you.
    If we compare it with the MV(X) kind, we’ll see a few differences of the distribution of responsibilities:
    Model (data interaction) logic shifted into the Interactor with the Entities as dumb data structures.
    Only the UI representation duties of the Controller/Presenter/ViewModel moved into the Presenter, but not the data altering capabilities.
    VIPER is the first pattern which explicitly addresses navigation responsibility, which is supposed to be resolved by the Router.
    Proper way of doing routing is a challenge for the iOS applications, the MV(X) patterns simply don’t address this issue.
    The example doesn’t cover routing or interaction between modules, as those topics are not covered by the MV(X) patterns at all.
    Yet again, back to the features:
    Distribution — undoubtedly, VIPER is a champion in distribution of responsibilities.
    Testability —no surprises here, better distribution — better testability.
    Easy of use — finally, two above come in cost of maintainability as you already guessed. You have to write huge amount of interface for classes with very small responsibilities.
    So what about LEGO?
    While using VIPER, you might feel like building The Empire State Building from LEGO blocks, and that is a signal that you have a problem. Maybe, it’s too early to adopt VIPER for your application and you should consider something simpler. Some people ignore this and continue shooting out of cannon into sparrows. I assume they believe that their apps will benefit from VIPER at least in the future, even if now the maintenance cost is unreasonably high. If you believe the same, then I’d recommend you to try Generamba — a tool for generating VIPER skeletons. Although for me personally it feels like using an automated targeting system for cannon instead of simply taking a sling shot.
    
    Conclusion
    We went though several architectural patterns, and I hope you have found some answers to what bothered you, but I have no doubt that you realised that there is no silver bullet so choosing architecture pattern is a matter of weighting tradeoffs in your particular situation.
    Therefore, it is natural to have a mix of architectures in same app. For example: you’ve started with MVC, then you realised that one particular screen became too hard to maintain efficiently with the MVC and switched to the MVVM, but only for this particular screen. There is no need to refactor other screens for which the MVC actually does work fine, because both of architectures are easily compatible.
    Make everything as simple as possible, but not simpler — Albert Einstein
    """
}
