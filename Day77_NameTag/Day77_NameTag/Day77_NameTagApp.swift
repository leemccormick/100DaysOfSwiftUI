//
//  Day77_NameTagApp.swift
//  Day77_NameTag
//
//  Created by Lee McCormick on 6/18/22.
//

import SwiftUI

@main
struct Day77_NameTagApp: App {
    @StateObject private var coreDataController = CoreDataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataController.container.viewContext)
        }
    }
}


/* Milestone: Projects 13-15
 You’ve completed two tough projects and another technique project, but your knowledge of SwiftUI is really starting to round out now – I certainly hope you’re starting to appreciate how much easier it is compared to Apple’s older frameworks!

 Today it’s time to pause and reflect on what was covered. We’ll also be diving into two topics – operator overloading and property wrappers – in more detail, because in doing so you’ll gain a much deeper understanding of what we’ve been using. And there’s today’s challenge, where you’ll need to apply the skills you’ve learned to build a wholly new app.

 Challenges offer you the chance to test your learning in a practical way, give you a sandbox where you can really express yourself and stretch yourself if you want, and I hope also show you just what you’re capable of when you put your mind to it. As Cicely Tyson said, “challenges make you discover things about yourself you never really knew,” and I hope you’re able to discover today just how far you’ve come!

 Today you have three topics to work through, one of which of is your challenge.

 - What you learned
 - Key points
 - Challenge
 
 Note: Don’t worry if you don’t complete challenges in the day they were assigned – in future days you’ll find you have some time to spare here and there, so challenges are something you can return back to in the future.
 */

/* What you learned
 These projects began introducing you to the more difficult parts of SwiftUI, although none of it was really SwiftUI’s fault – it’s the places where SwiftUI meets Apple’s older frameworks that things get a little rough. Over time these rough edges will get smoothed off a little, but it might be a few years and regardless these will still be important for any times you want to integrate code from outside of Apple.

 While completing the three projects, you also learned:

 - How property wrappers become structs
 - Presenting confirmation dialogs with lots of buttons
 - Using Core Image to manipulate images
 - Integrating PHPickerViewController into SwiftUI
 - Writing coordinator classes that can act as delegates for image pickers
 - Integrating maps into SwiftUI
 - Dropping pins on maps
 - Saving images to the user’s photo library
 - Adding Comparable conformance to custom types
 - Finding and writing to the user’s documents directory
 - Enabling file encryption when writing
 - Authenticating users with Touch ID and Face ID
 - Each of those topics were covered as a standalone technique and then applied in a real project, so hopefully it’s really sinking in!
 */


/* Key points
 There are two topics I want to dive into more today, both of which are quite advanced but both are things that I know will really help deepen your understanding of what was covered in the previous three projects.

 Operator overloading
 When we added a custom conformance to Comparable we need to add one method called <. This in turn allows Swift to compare expressions such as a < b, which is what gave us access to a version of sorted() that took no parameters.

 This is called operator overloading, and it’s what allows us to add two integers or join two strings using the same + operator. You can define your own operators if you want, but it’s also easy to extend existing operators to do new things.

 As an example, we could add some extensions to Int that lets us multiply an Int and a Double – something that Swift doesn’t allow by default, which can be annoying:

 extension Int {
     static func *(lhs: Int, rhs: Double) -> Double {
         return Double(lhs) * rhs
     }
 }
 Pay particular attention to the parameters: it uses an Int as the left-hand operand and a Double as the right-hand operand, which means it won’t work if you swap those two around. So, if you want to be complete – if you want either order to work – you need to define the method twice.

 However, if you want to be really complete then extending Int is the wrong choice: we should go up to a protocol that wraps Int as well as other integer types such as the Int16 we used with Core Data. Swift puts all integer types into a single protocol called BinaryInteger, and if we write an extension on that then Self (with a capital S) refers to whatever specific type is being used. So, if it’s used on an Int then Self means Int, and if it’s used on an Int16 then it means that instead.

 Here’s an extension that adds * between any kind of integer and Double, regardless of whether the integer is on the left or on the right:

 extension BinaryInteger {
     static func *(lhs: Self, rhs: Double) -> Double {
         return Double(lhs) * rhs
     }

     static func *(lhs: Double, rhs: Self) -> Double {
         return lhs * Double(rhs)
     }
 }
 If you were wondering, there is a reason Swift doesn’t enable these operators for us: it’s not guaranteed to be as accurate as you might hope. As a simple example, try this:

 let exampleInt: Int64 = 50_000_000_000_000_001
 print(exampleInt)

 let result = exampleInt * 1.0
 print(String(format: "%.0f", result))
 That creates a 64-bit integer holding 50 quadrillion and one. It then multiplies it by the Double 1.0 using our custom extension, which in theory means the number that comes back should be identical to the Int. However, that String(format:_:) call asks for the number to be printed with no decimal places, and you’ll see it isn’t the same as the integer: it is 50 quadrillion without the 1. Now, you might ask “what’s 1 when you’re working with 50 quadrillion”, and that’s fine – I’m not here to tell you what’s right and wrong, only to say that if you want absolute accuracy you should avoid using these kinds of helper methods.

 More generally, I want to give you a warning about operator overloading. When I introduced it back in project 14 I said operator overloading “can be both a blessing and a curse,” and I want to touch briefly on why that is.

 Consider code like this:

 let paul = User()
 let swift = Language()

 let result = paul + swift
 What type of data is result? I can think of several possibilities:

 Maybe it’s another User object, now modified so that it has Swift in its array of known languages.
 Maybe it’s a Programmer object combining a user and a language.
 Maybe it’s a weird remake of the classic horror movie The Fly.
 The point is that we don’t know, and we can’t really tell without reading into the source code for the relevant + operator.

 Now consider this code:

 let paul = User()
 let swift = Language()
 paul.learn(swift)
 This is much clearer, I think: we’re now running a simple method on an object, and you’d probably guess that we’re mutating paul to include Swift in the array of programming languages.

 Any good developer will tell you that clarity is one of the most important features of well-written code – we need to make our meaning clear in what we write, because it will be read dozens or hundreds of times in the future.

 So, by all means add operator overloading to your arsenal of skills that you can deploy to solve problems, and indeed I go into way more detail about them in my book Pro Swift, but always use them with care.

 Custom property wrappers
 You’ve seen that property wrappers are really just some sleight of hand: they take a simple value and wrap it in another another value so that some extra functionality can be added. This might be the way SwiftUI uses @State to store values elsewhere, or how it uses @Environment to read values from a shared data source, but the principle is the same: it takes a simple value and gives it super-powers somehow.

 We can use property wrappers in our own code, and there are lots of reasons why you might want to do so. As with operator overloading you’ll understand more about how things work if you try them out, but it’s also worth using them thoughtfully: if they are the first thing you reach for you’re probably making a mistake.

 To demonstrate property wrappers, I want to start with a simple struct that wraps some kind of BinaryInteger value. We’re going to give this thing some custom code when it comes to setting its wrapped value, so that if the new value is below 0 we instead make it exactly 0 so that this struct can never be negative.

 Our code would look like this:

 struct NonNegative<Value: BinaryInteger> {
     var value: Value

     init(wrappedValue: Value) {
         if wrappedValue < 0 {
             value = 0
         } else {
             value = wrappedValue
         }
     }

     var wrappedValue: Value {
         get { value }
         set {
             if newValue < 0 {
                 value = 0
             } else {
                 value = newValue
             }
         }
     }
 }
 We can now create that with an integer, but if that integer drops below 0 then it will be clamped to 0. So, this will print 0:

 var example = NonNegative(wrappedValue: 5)
 example.wrappedValue -= 10
 print(example.wrappedValue)
 What property wrappers let us do is use that for any kind of property in a struct or class. Even better, it only takes one step: writing @propertyWrapper before the NonNegative struct, like this:

 @propertyWrapper
 struct NonNegative<Value: BinaryInteger> {
 That’s it – we now have our own property wrapper!

 In case you hadn’t guessed from their name, property wrappers can only be used on properties rather than plain variables or constants, so to try ours out we’re going to put it inside a User struct like this:

 struct User {
     @NonNegative var score = 0
 }
 And now we can create a user and add or remove points freely, knowing for sure the score will never go below 0:

 var user = User()
 user.score += 10
 print(user.score)

 user.score -= 20
 print(user.score)
 As you can see, there really is no magic here: not only are property wrappers just syntactic sugar that causes one piece of data to be wrapped around another, but we can also make them ourselves if needed.
 */

/* Challenge
 Have you ever been to a conference or a meetup, chatted to someone new, then realized seconds after you walk away that you’ve already forgotten their name? You’re not alone, and the app you’re building today will help solve that problem and others like it.

 Your goal is to build an app that asks users to import a picture from their photo library, then attach a name to whatever they imported. The full collection of pictures they name should be shown in a List, and tapping an item in the list should show a detail screen with a larger version of the picture.

 Breaking it down, you should:

 - Wrap PHPickerViewController so it can be used to select photos.
 - Detect when a new photo is imported, and immediately ask the user to name the photo.
 - Save that name and photo somewhere safe.
 - Show all names and photos in a list, sorted by name.
 - Create a detail screen that shows a picture full size.
 - Decide on a way to save all this data.

 We’ve covered how to save data to the user’s photo library using UIImageWriteToSavedPhotosAlbum(), but saving an image to disk requires a small extra step: you need to convert your UIImage to Data by calling its jpegData() method like this:

 if let jpegData = yourUIImage.jpegData(compressionQuality: 0.8) {
     try? jpegData.write(to: yourURL, options: [.atomic, .completeFileProtection])
 }
 The compressionQuality parameter can be any value between 0 (very low quality) and 1 (maximum quality); something like 0.8 gives a good trade off between size and quality.

 You can use Core Data for this project if you want to, but it isn’t required – a simple JSON file written out to the documents directory is fine, although you will need to add a custom conformance to Comparable to get array sorting to work.

 If you do choose to use Core Data, make sure you don’t save the actual image into the database because that’s not efficient. Core Data or not, the optimal thing to do is generate a new UUID for the image filename then write it to the documents directory, and store that UUID in your data model.

 Remember, you already know everything you need to make this work – good luck!
 */

