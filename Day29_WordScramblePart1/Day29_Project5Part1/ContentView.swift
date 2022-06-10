//
//  ContentView.swift
//  Day29_Project5Part1
//
//  Created by Lee McCormick on 3/29/22.
//

import SwiftUI

struct ContentView: View {
    // List == TableView
    let people = ["Finn", "Lee", "Don", "Lyn", "New"]
    var body: some View {
        List {
            Text("Static row")
            ForEach(people, id: \.self) {
                Text($0)
            }
            Text("Static row")
        }
        /*  List(0..<5) {
         Text("Dynamic row : \($0)")
         Section("Section 1") {
         Text("Static Row 1")
         Text("Static Row 2")
         }
         Section("Section 2") {
         ForEach (0..<5) {
         Text("Dynamic row : \($0)")
         }
         }
         Section("Section 3") {
         Text("Static Row 1")
         Text("Static Row 2")
         }
         }*/
        .listStyle(.grouped)
    }
    
    // Working file contents from Bundle
    func loadFile() {
        if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
            if let fileContents = try? String(contentsOf: fileURL) {
                print(fileContents)
            }
        }
    }
    
    // Working with string
    func test() {
        let input = "a b c"
        let letters = input.components(separatedBy: " ")
        print("letters : \(letters)")
        let inputAgain = """
                    a
                    b
                    c
                    """
        let lettersAgain = inputAgain.components(separatedBy: "\n")
        print("lettersAgain : \(lettersAgain)")
        let letter = letters.randomElement()
        print("letterRandom : \(letter ?? "")")
        
        // Trimmed
        let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)
        print("trimmed : \(trimmed ?? "")")
        
        // Find Miss Spell Word
        let word = "swift"
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let missspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        let allGood = missspelledRange.location == NSNotFound
        print("allGood : \(allGood)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/* Project 5, part 1
 It’s time for another new project, and this is actually the last easy project we have on this course – after this the difficulty level ramps up a little as we tackle bigger apps, so enjoy this while it lasts!
 
 In this app you’ll work with two of the real fundamentals of app development: List for working with tables of data, and strings, for handling text. Yes, we covered strings quite a bit already, but now we’re really going to dig into them, including how to work with their Unicode representation so we can get compatibility with older Objective-C frameworks.
 
 Unicode is a standard for storing and representing text, which at first glance you might think sounds easy. But trust me on this: it really isn’t. You know how I said dates are hard? Well, dates are easy compared to storing text properly. In fact, there’s even a joke mug you can buy that says “I ? Unicode” – a painful reminder that when text representation goes bad all you see is a question mark where the symbol should be.
 
 Today you have four topics to work through, and you’ll meet List, Bundle, UITextChecker, and more.
 
 Word Scramble: Introduction
 Introducing List, your best friend
 Loading resources from your app bundle
 Working with strings
 Once you’re done, post a short message somewhere telling folks about your progress!
 */

/* Word Scramble: Introduction
 Paul Hudson     @twostraws    October 27th 2021
 
 This project will be another game, although really it’s just a sneaky way for me to introduce more Swift and SwiftUI knowledge! The game will show players a random eight-letter word, and ask them to make words out of it. For example, if the starter word is “alarming” they might spell “alarm”, “ring”, “main”, and so on.
 
 Along the way you’ll meet List, onAppear(), Bundle, fatalError(), and more – all useful skills that you’ll use for years to come. You’ll also get some practice with @State, NavigationView, and more, which you should enjoy while you can – this is our last easy project!
 
 To get started, please create a new App project called WordScramble, making sure to set iOS 15 as your deployment target. You’ll need to download the files for this project, as it contains a file called “start.txt” that you’ll be needing later on.
 
 OK, let’s get into some code…
 */

/* Introducing List, your best friend
 Of all SwiftUI’s view types, List is the one you’ll rely on the most. That doesn’t mean you’ll use it the most – I’m sure Text or VStack will claim that crown – more that it’s such a workhorse that you’ll come back to it time and time again. And this isn’t new: the equivalent of List in UIKit was UITableView, and it got used just as much.
 
 The job of List is to provide a scrolling table of data. In fact, it’s pretty much identical to Form, except it’s used for presentation of data rather than requesting user input. Don’t get me wrong: you’ll use Form quite a lot too, but really it’s just a specialized type of List.
 
 Just like Form, you can provide List a selection of static views to have them rendered in individual rows:
 
 List {
 Text("Hello World")
 Text("Hello World")
 Text("Hello World")
 }
 We can also switch to ForEach in order to create rows dynamically from an array or range:
 
 List {
 ForEach(0..<5) {
 Text("Dynamic row \($0)")
 }
 }
 Where things get more interesting is the way you can mix static and dynamic rows:
 
 List {
 Text("Static row 1")
 Text("Static row 2")
 
 ForEach(0..<5) {
 Text("Dynamic row \($0)")
 }
 
 Text("Static row 3")
 Text("Static row 4")
 }
 And of course we can combine that with sections, to make our list easier to read:
 
 List {
 Section("Section 1") {
 Text("Static row 1")
 Text("Static row 2")
 }
 
 Section("Section 2") {
 ForEach(0..<5) {
 Text("Dynamic row \($0)")
 }
 }
 
 Section("Section 3") {
 Text("Static row 3")
 Text("Static row 4")
 }
 }
 Tip: As you can see, if your section header is just some text you can pass it in directly as a string – it’s a helpful shortcut for times you don’t need anything more advanced.
 
 Being able to have both static and dynamic content side by side lets us recreate something like the Wi-Fi screen in Apple’s Settings app – a toggle to enable Wi-Fi system-wide, then a dynamic list of nearby networks, then some more static cells with options to auto-join hotspots and so on.
 
 You’ll notice that this list looks similar to the form we had previously, but we can adjust how the list looks using the listStyle() modifier, like this:
 
 .listStyle(.grouped)
 Now, everything you’ve seen so far works fine with Form as well as List – even the dynamic content. But one thing List can do that Form can’t is to generate its rows entirely from dynamic content without needing a ForEach.
 
 So, if your entire list is made up of dynamic rows, you can simply write this:
 
 List(0..<5) {
 Text("Dynamic row \($0)")
 }
 This allows us to create lists really quickly, which is helpful given how common they are.
 
 In this project we’re going to use List slightly differently, because we’ll be making it loop over an array of strings. We’ve used ForEach with ranges a lot, either hard-coded (0..<5) or relying on variable data (0..<students.count), and that works great because SwiftUI can identify each row uniquely based on its position in the range.
 
 When working with an array of data, SwiftUI still needs to know how to identify each row uniquely, so if one gets removed it can simply remove that one rather than having to redraw the whole list. This is where the id parameter comes in, and it works identically in both List and ForEach – it lets us tell SwiftUI exactly what makes each item in the array unique.
 
 When working with arrays of strings and numbers, the only thing that makes those values unique is the values themselves. That is, if we had the array [2, 4, 6, 8, 10], then those numbers themselves are themselves the unique identifiers. After all, we don’t have anything else to work with!
 
 When working with this kind of list data, we use id: \.self like this:
 
 struct ContentView: View {
 let people = ["Finn", "Leia", "Luke", "Rey"]
 
 var body: some View {
 List(people, id: \.self) {
 Text($0)
 }
 }
 }
 That works just the same with ForEach, so if we wanted to mix static and dynamic rows we could have written this instead:
 
 List {
 Text("Static Row")
 
 ForEach(people, id: \.self) {
 Text($0)
 }
 
 Text("Static Row")
 }
 */

/* Loading resources from your app bundle
 When we use Image views, SwiftUI knows to look in your app’s asset catalog to find the artwork, and it even automatically adjusts the artwork so it loads the correct picture for the current screen resolution – that’s the @2x and @3x stuff we looked at earlier.
 
 For other data, such as text files, we need to do more work. This also applies if you have specific data formats such as XML or JSON – it takes the same work regardless of what file types you’re loading.
 
 When Xcode builds your iOS app, it creates something called a “bundle”. This happens on all of Apple’s platforms, including macOS, and it allows the system to store all the files for a single app in one place – the binary code (the actual compiled Swift stuff we wrote), all the artwork, plus any extra files we need all in one place.
 
 In the future, as your skills grow, you’ll learn how you can actually include multiple bundles in a single app, allowing you to write things like Siri extensions, iMessage apps, widgets, and more, all inside a single iOS app bundle. Although these get included with our app’s download from the App Store, these other bundles are stored separately from our main app bundle – our main iOS app code and resources.
 
 All this matters because it’s common to want to look in a bundle for a file you placed there. This uses a new data type called URL, which stores pretty much exactly what you think: a URL such as https://www.hackingwithswift.com. However, URLs are a bit more powerful than just storing web addresses – they can also store the locations of files, which is why they are useful here.
 
 Let’s start writing some code. If we want to read the URL for a file in our main app bundle, we use Bundle.main.url(). If the file exists it will be sent back to us, otherwise we’ll get back nil, so this is an optional URL. That means we need to unwrap it like this:
 
 if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
 // we found the file in our bundle!
 }
 What’s inside the URL doesn’t really matter, because iOS uses paths that are impossible to guess – our app lives in its own sandbox, and we shouldn’t try to read outside of it.
 
 Once we have a URL, we can load it into a string with a special initializer: String(contentsOf:). We give this a file URL, and it will send back a string containing the contents of that file if it can be loaded. If it can’t be loaded it throws an error, so you you need to call this using try or try? like this:
 
 if let fileContents = try? String(contentsOf: fileURL) {
 // we loaded the file into a string!
 }
 Once you have the contents of the file, you can do with it whatever you want – it’s just a regular string.
 */

/* Working with strings
 iOS gives us some really powerful APIs for working with strings, including the ability to split them into an array, remove whitespace, and even check spellings. We’ve looked at some of these previously, but there’s at least one major addition I want to look at.
 
 In this app, we’re going to be loading a file from our app bundle that contains over 10,000 eight-letter words, each of which can be used to start the game. These words are stored one per line, so what we really want is to split that string up into an array of strings in order that we can pick one randomly.
 
 Swift gives us a method called components(separatedBy:) that can converts a single string into an array of strings by breaking it up wherever another string is found. For example, this will create the array ["a", "b", "c"]:
 
 let input = "a b c"
 let letters = input.components(separatedBy: " ")
 We have a string where words are separated by line breaks, so to convert that into a string array we need to split on that.
 
 In programming – almost universally, I think – we use a special character sequence to represent line breaks: \n. So, we would write code like this:
 
 let input = """
 a
 b
 c
 """
 let letters = input.components(separatedBy: "\n")
 Regardless of what string we split on, the result will be an array of strings. From there we can read individual values by indexing into the array, such as letters[0] or letters[2], but Swift gives us a useful other option: the randomElement() method returns one random item from the array.
 
 For example, this will read a random letter from our array:
 
 let letter = letters.randomElement()
 Now, although we can see that the letters array will contain three items, Swift doesn’t know that – perhaps we tried to split up an empty string, for example. As a result, the randomElement() method returns an optional string, which we must either unwrap or use with nil coalescing.
 
 Another useful string method is trimmingCharacters(in:), which asks Swift to remove certain kinds of characters from the start and end of a string. This uses a new type called CharacterSet, but most of the time we want one particular behavior: removing whitespace and new lines – this refers to spaces, tabs, and line breaks, all at once.
 
 This behavior is so common it’s built right into the CharacterSet struct, so we can ask Swift to trim all whitespace at the start and end of a string like this:
 
 let trimmed = letter?.trimmingCharacters(in: .whitespacesAndNewlines)
 There’s one last piece of string functionality I’d like to cover before we dive into the main project, and that is the ability to check for misspelled words.
 
 This functionality is provided through the class UITextChecker. You might not realize this, but the “UI” part of that name carries two additional meanings with it:
 
 This class comes from UIKit. That doesn’t mean we’re loading all the old user interface framework, though; we actually get it automatically through SwiftUI.
 It’s written using Apple’s older language, Objective-C. We don’t need to write Objective-C to use it, but there is a slightly unwieldy API for Swift users.
 Checking a string for misspelled words takes four steps in total. First, we create a word to check and an instance of UITextChecker that we can use to check that string:
 
 let word = "swift"
 let checker = UITextChecker()
 Second, we need to tell the checker how much of our string we want to check. If you imagine a spellchecker in a word processing app, you might want to check only the text the user selected rather than the entire document.
 
 However, there’s a catch: Swift uses a very clever, very advanced way of working with strings, which allows it to use complex characters such as emoji in exactly the same way that it uses the English alphabet. However, Objective-C does not use this method of storing letters, which means we need to ask Swift to create an Objective-C string range using the entire length of all our characters, like this:
 
 let range = NSRange(location: 0, length: word.utf16.count)
 UTF-16 is what’s called a character encoding – a way of storing letters in a string. We use it here so that Objective-C can understand how Swift’s strings are stored; it’s a nice bridging format for us to connect the two.
 
 Third, we can ask our text checker to report where it found any misspellings in our word, passing in the range to check, a position to start within the range (so we can do things like “Find Next”), whether it should wrap around once it reaches the end, and what language to use for the dictionary:
 
 let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
 That sends back another Objective-C string range, telling us where the misspelling was found. Even then, there’s still one complexity here: Objective-C didn’t have any concept of optionals, so instead relied on special values to represent missing data.
 
 In this instance, if the Objective-C range comes back as empty – i.e., if there was no spelling mistake because the string was spelled correctly – then we get back the special value NSNotFound.
 
 So, we could check our spelling result to see whether there was a mistake or not like this:
 
 let allGood = misspelledRange.location == NSNotFound
 OK, that’s enough API exploration – let’s get into our actual project…
 */
