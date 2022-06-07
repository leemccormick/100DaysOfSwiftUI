//
//  Day75_Accessibility_FixedProjectsApp.swift
//  Day75_Accessibility_FixedProjects
//
//  Created by Lee McCormick on 6/6/22.
//

import SwiftUI

@main
struct Day75_Accessibility_FixedProjectsApp: App {
    @StateObject private var datacontroller = DatatController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, datacontroller.container.viewContext)
        }
    }
}

/* Project 15, part 2
 Today we’re going to go back through three of our earlier projects, highlighting accessibility problems and fixing them. This might seem like it might be a bit dull, but I want you to think again about what our goal is here: do we want to build software that benefits everyone?
 
 I hope the answer is yes. There’s a New York lawyer called Gregory Mansfield who fights for disability rights, and he once wrote this: “Accessibility is not charity. Accessibility is not generosity. Accessibility is not an amenity. Accessibility is not a gratuity. You don’t bestow access – you ensure it.”
 
 As you work through today’s three topics, I hope you’re pleasantly surprised by a) how easy this stuff really is, and b) how little it affects the rest of your code. And once you realize that, you’ll start to wonder why so many other app developers do such a poor job of making their apps accessible to everyone.
 
 Today you have three topics to work through, in which you’ll fix three projects we made earlier in this course.
 
 - Fixing Guess the Flag
 - Fixing Word Scramble
 - Fixing Bookworm
 */

/* Fixing Guess the Flag
 Way back in project 2 we made Guess the Flag, which showed three flag pictures and asked the users to guess which was which. Well, based on what you now know about VoiceOver, can you spot the fatal flaw in our game?
 
 That’s right: SwiftUI’s default behavior is to read out the image names as their VoiceOver label, which means anyone using VoiceOver can just move over our three flags to have the system announce which one is correct.
 
 To fix this we need to add text descriptions for each of our flags, describing them in enough detail that they can be guessed correctly by someone who has learned them, but of course without actually giving away the name of the country.
 
 If you open your copy of this project, you’ll see it was written to use an array of country names, like this:
 
 @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
 So, the easiest way to attach labels there – the way that doesn’t require us to change any of our code – is to create a dictionary with country names as keys and accessibility labels as values, like this. Please add this to ContentView:
 
 let labels = [
 "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
 "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
 "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
 "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
 "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
 "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
 "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
 "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
 "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
 "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
 "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
 ]
 And now all we need to do is add the accessibilityLabel() modifier to the flag images. I realize that sounds simple, but the code has to do three things:
 
 Use countries[number] to get the name of the country for the current flag.
 Use that name as the key for labels.
 Provide a string to use as a default if somehow the country name doesn’t exist in the dictionary. (This should never happen, but there’s no harm being safe!)
 Putting all that together, put this modifier directly below the rest of the modifiers for the flag images:
 
 .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
 And now if you run the game again you’ll see it actually is a game, regardless of whether you use VoiceOver or not. This gets right to the core of accessibility: everyone can have fun playing this game now, regardless of their access needs.
 */

/* Fixing Word Scramble
 In project 5 we built Word Scramble, a game where users were given a random eight-letter word and had to produce new words using its letters. This mostly works great with VoiceOver: no parts of the app are inaccessible, although that doesn’t mean we can’t do better.
 
 To see an obvious pain point, try adding a word. You’ll see it slide into the table underneath the prompt, but if you tap into it with VoiceOver you’ll realize it isn’t read well: the letter count is read as “five circle”, and the text is a separate element.
 
 There are a few ways of improving this, but probably the best is to make both those items a single group where the children are ignored by VoiceOver, then add a label for the whole group that contains a much more natural description.
 
 Our current code looks like this:
 
 List(usedWords, id: \.self) { word in
 HStack {
 Image(systemName: "\(word.count).circle")
 Text(word)
 }
 }
 To fix this we need to group the elements inside the HStack together so we can apply our VoiceOver customization:
 
 List(usedWords, id: \.self) { word in
 HStack {
 Image(systemName: "\(word.count).circle")
 Text(word)
 }
 .accessibilityElement(children: .ignore)
 .accessibilityLabel("\(word), \(word.count) letters")
 }
 Alternatively, you could break that text up to have a hint as well as a label, like this:
 
 HStack {
 Image(systemName: "\(word.count).circle")
 Text(word)
 }
 .accessibilityElement(children: .ignore)
 .accessibilityLabel(word)
 .accessibilityHint("\(word.count) letters")
 Regardless of which you choose, if you try the game again you’ll hear it now reads “spill, five letters”, which is much better.
 */

/* Fixing Bookworm
 In project 11 we built Bookworm, an app that lets users store ratings and descriptions for books they had read, and we also introduced a custom RatingView UI component that showed star ratings from 1 to 5.
 
 Again, most of the app does well with VoiceOver, but that rating control is a hard fail – it uses tap gestures to add functionality, so users won’t realize they are buttons, and it doesn’t even convey the fact that they are supposed to represent ratings. For example, if I tap one of the gray stars, VoiceOver reads out to me, “star, fill, image, possibly airplane, star” – it’s really not useful at all.
 
 That in itself is a problem, but it’s extra problematic because our RatingView is designed to be reusable – it’s the kind of thing you can take from this project and use in a dozen other projects, and that just means you end up polluting many apps with poor accessibility.
 
 We’re going to tackle this one in an unusual way: first with a simpler set of modifiers that do an okay job, but then by seeing how we can use accessibilityAdjustableAction() to get a more optimal result.
 
 Our initial approach will use three modifiers, each added below the current tapGesture() modifier inside RatingView. First, we need to add one that provides a meaningful label for each star, like this:
 
 .accessibilityLabel("\(number == 1 ? "1 star" : "\(number) stars")")
 Second, we can remove the .isImage trait, because it really doesn’t matter that these are images:
 
 .accessibilityRemoveTraits(.isImage)
 And finally, we should tell the system that each star is actually a button, so users know it can be tapped. While we’re here, we can make VoiceOver do an even better job by adding a second trait, .isSelected, if the star is already highlighted.
 
 So, add this final modifier beneath the previous two:
 
 .accessibilityAddTraits(number > rating ? .isButton : [.isButton, .isSelected])
 It only took three small changes, but this improved component is much better than what we had before.
 
 This initial approach works well enough, and it’s certainly the easiest to take because it builds on all the skills you’ve used elsewhere. However, there’s a second approach that I want to look at, because I think it yields a far more useful result – it works more efficiently for folks relying on VoiceOver and other tools.
 
 First, remove the three modifiers we just added, and instead add these four to the HStack:
 
 .accessibilityElement()
 .accessibilityLabel(label)
 .accessibilityValue(rating == 1 ? "1 star" : "\(rating) stars")
 .accessibilityAdjustableAction { direction in
 switch direction {
 case .increment:
 if rating < maximumRating { rating += 1 }
 case .decrement:
 if rating > 1 { rating -= 1 }
 default:
 break
 }
 }
 That groups all its children together, applies the label “Rating”, but then adds a value based on the current stars. It also allows that rating value to be adjusted up or down using swipes, which is much better than trying to work through lots of individual images.
 */
