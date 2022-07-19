//
//  SwiftUIQuestionViewModel.swift
//  Day100_FinalExam
//
//  Created by Lee McCormick on 7/18/22.
//

import Foundation

// MARK: - SwiftUIQuestionViewModel
class SwiftUIQuestionViewModel : ObservableObject {
    // MARK: - Properties
    @Published var day100Questions: [Question] = []
    @Published var  isShowingNextButton = true
    var correctScore: Int = 0
    var totalScore: Int = 0
    
    // MARK: - Init
    init() {
        restartExam()
    }
    
    // MARK: - Functions
    func restartExam() {
        day100Questions = []
        createQuestions()
        correctScore = 0
        totalScore = day100Questions.count
        isShowingNextButton = true
    }
    
    func removeQuestion(at index: Int) {
        day100Questions.remove(at: index)
    }
    
    func reStackQuestion(at index: Int) {
        let lastQuestion = day100Questions[index]
        day100Questions.remove(at: index)
        day100Questions.insert(lastQuestion, at: 0)
    }
    
    // MARK: - Private Function
    private func createQuestions() {
        // Question 1
        let q1 = Question(propmt: "Which of these statements are true?",
                          chioces: [MutipleChoice(choice: "As it's a container, VStack can't have accessibility data", explianationChoice: "VStack is a view, so it can have accessibility data of its own like any other view."),
                                    MutipleChoice(choice: "Three text fields in the same VStack are considered to be separate elements if they aren't specifically combined.", explianationChoice: "This means users can select them individually.")],
                          correctChoice: 1)
        day100Questions.append(q1)
        // Question 2
        let q2 = Question(propmt: "Which of these statements are true?",
                          chioces: [MutipleChoice(choice: "The alignmentGuide() modifier lets us write custom code to calculate a view's alignment guide.", explianationChoice: "This should be used together with whatever alignment its container is using."),
                                    MutipleChoice(choice: "Views come with a built-in dismiss() method that lets us hide the view.", explianationChoice: "If you want to dismiss a view, you need to use the environment to read the correct dismiss action for however the view is being shown.")],
                          correctChoice: 0)
        day100Questions.append(q2)
        // Question 3
        let q3 = Question(propmt: "Which of these statements are true?",
                          chioces: [MutipleChoice(choice: "We can create a rounded rectangle shape using SwiftUI's Capsule shape.", explianationChoice: "Rounded rectangles and capsules are different shapes."),
                                    MutipleChoice(choice: "We can place optional views directly into a SwiftUI view hierarchy.", explianationChoice: "SwiftUI will only render them if they have a value.")],
                          correctChoice: 0)
        day100Questions.append(q3)
        // Question 4
        let q4 = Question(propmt: "Which of these statements are true?",
                          chioces: [MutipleChoice(choice: "SwiftUI lets us animate changes that occur as a result of modifying a Boolean's value.", explianationChoice: "It evaluates your view state before the change and after, and animates the differences."),
                                    MutipleChoice(choice: "Alert messages cannot include string interpolation.", explianationChoice: "Alert messages are just text; you can create them however you want.")],
                          correctChoice: 0)
        day100Questions.append(q4)
        // Question 5
        let q5 =  Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Properties wrapped in @EnvironmentObject must have a value before the view is shown.", explianationChoice: "If their view is shown without the value right, your app crashes."),
                                     MutipleChoice(choice: "MVVM stands for Multiple Views, Varying Models.", explianationChoice: "MVVM stands for Model View ViewModel.")],
                           correctChoice: 0)
        day100Questions.append(q5)
        // Question 6
        let q6 = Question(propmt: "Which of these statements are true?",
                          chioces: [MutipleChoice(choice: "Shapes must be able to create a path.", explianationChoice: "This is the only requirement of the Shape protocol: to be able to create a path in a rectangle."),
                                    MutipleChoice(choice: "SwiftUI coordinator classes must always be nested inside a struct.", explianationChoice: "They don't need to be nested, it's just nice to have.")],
                          correctChoice: 0)
        day100Questions.append(q6)
        // Question 7
        let q7 = Question(propmt: "Which of these statements are true?",
                          chioces: [MutipleChoice(choice: "SwiftUI's Color.red is not a pure red color.", explianationChoice: "It's actually a custom color blend that looks better in light and dark mode."),
                                    MutipleChoice(choice: "A VStack can have an alignment or spacing, but not both.", explianationChoice: "You can use either, both, or none depending on your needs.")],
                          correctChoice: 0)
        day100Questions.append(q7)
        // Question 8
        let q8 = Question(propmt: "Which of these statements are true?",
                          chioces: [MutipleChoice(choice: "We can attach onChanged() and onEnded() modifiers to a DragGesture.", explianationChoice: "This lets us update our view state every time the user's finger moves, or when they end the gesture."),
                                    MutipleChoice(choice: "@EnvironmentObject only works with structs.", explianationChoice: "@EnvironmentObject only works with classes.")],
                          correctChoice: 0)
        day100Questions.append(q8)
        // Question 9
        let q9 = Question(propmt: "Which of these statements are true?",
                          chioces: [MutipleChoice(choice: "We can create a List directly from an array.", explianationChoice: "We can also create one directly from a range."),
                                    MutipleChoice(choice: "@NSManaged is a property wrapper.", explianationChoice: "@NSManaged pre-dates property wrappers in Swift.")],
                          correctChoice: 0)
        day100Questions.append(q9)
        // Question 10
        let q10 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Apple recommends @State properties should use public access control.", explianationChoice: "It's the opposite: Apple recommends they should use private access control."),
                                     MutipleChoice(choice: "To make a SwiftUI view wrap a UIKit view controller, we must make it conform to UIViewControllerRepresentable.", explianationChoice: "UIViewControllerRepresentable already conforms to View.")],
                           correctChoice: 1)
        day100Questions.append(q10)
        // Question 11
        let q11 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Once a Timer has started, it can't be stopped.", explianationChoice: "You can stop a timer whenever you want."),
                                     MutipleChoice(choice: "We can use the dynamicTypeSize() modifier to declare which Dynamic Type sizes a view supportsd.", explianationChoice: "It's a good idea to support all of them, but it's also okay to add limits if you don't have a better option.")],
                           correctChoice: 1)
        day100Questions.append(q11)
        // Question 12
        let q12 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "JSON stands for JavaScript Object Networking.", explianationChoice: "JSON stands for JavaScript Object Notation."),
                                     MutipleChoice(choice: "EditButton will automatically switch between Edit and Done when tapped.", explianationChoice: "It will also toggle editing mode on any lists that are loaded.")],
                           correctChoice: 1)
        day100Questions.append(q12)
        // Question 13
        let q13 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "If we create an NSManagedObject subclass, make changes to it, then ask Xcode to create the subclass again, it will add our changes back to the class.", explianationChoice: "Xcode will simply overwrite our modifications."),
                                     MutipleChoice(choice: "The Codable protocol is actually a combination of Encodable and Decodable.", explianationChoice: "You can use these two protocols individually if you prefer.")],
                           correctChoice: 1)
        day100Questions.append(q13)
        // Question 14
        let q14 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "If a VStack has a foreground color and some text inside also has a foreground color, the VStack's foreground color is used.", explianationChoice: "Local modifiers always override environment modifiers from the parent."),
                                     MutipleChoice(choice: "Decorative images are images that are merely there to make the UI look nicer.", explianationChoice: "These can mostly be ignored with VoiceOver.")],
                           correctChoice: 1)
        day100Questions.append(q14)
        // Question 15
        let q15 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "When creating a custom alignment guide we must provide a default value.", explianationChoice: "This will be used if we don't attach the alignmentGuide() modifier to a view."),
                                     MutipleChoice(choice: " Arrays cannot be used with @State.", explianationChoice: "Arrays work perfectly fine with @State.")],
                           correctChoice: 0)
        day100Questions.append(q15)
        // Question 16
        let q16 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Ease in animations start slow and end fast.", explianationChoice: "Ease out animations start fast and end slow."),
                                     MutipleChoice(choice: "SwiftUI's views cannot be created as @State properties.", explianationChoice: "SwiftUI's views work great as @State properties.")],
                           correctChoice: 0)
        day100Questions.append(q16)
        // Question 17
        let q17 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Images from SF Symbols can be shown larger or small by using the font() modifier.", explianationChoice: "SF Symbols automatically adapts to the text around it, so you can render them as large or small as you need."),
                                     MutipleChoice(choice: "Each modifier can be applied only once to a given view.", explianationChoice: "You can apply one modifier multiple times to the same view if you want to.")],
                           correctChoice: 0)
        day100Questions.append(q17)
        // Question 18
        let q18 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "We always need to bind text fields to strings.", explianationChoice: "Although text fields use strings by default, we can also bind them to numbers."),
                                     MutipleChoice(choice: "SwiftUI can animate several properties changing at the same time.", explianationChoice: "It will animate them all simultaneously.")],
                           correctChoice: 1)
        day100Questions.append(q18)
        // Question 19
        let q19 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "The Identifiable protocol has no requirements.", explianationChoice: "This protocol has only one requirement: a property called id that should be unique."),
                                     MutipleChoice(choice: "Creating a property using @Environment(\'.horizontalSizeClass) will keep the value updated when the size class changes.", explianationChoice: "This allows us to create a UI that updates itself as the size class changes.")],
                           correctChoice: 1)
        day100Questions.append(q19)
        // Question 20
        let q20 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "The NavigationBar view lets us show new views and also place text at the top of the screen.", explianationChoice: "This functionality is provided by NavigationView, not NavigationBar."),
                                     MutipleChoice(choice: "We can send nil to the animation() modifier.", explianationChoice: "This disables animation.")],
                           correctChoice: 1)
        day100Questions.append(q20)
        // Question 21
        let q21 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "QR codes are just barcodes with more colors.", explianationChoice: "QR codes are quite different, but they also use two colors just like barcodes."),
                                     MutipleChoice(choice: "Using scaledToFill() with an image might mean parts of an image lie outside its container's frame.", explianationChoice: "It does however mean that no part of the image view is empty.")],
                           correctChoice: 1)
        day100Questions.append(q21)
        // Question 22
        let q22 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "The sequenced(before:) modifier lets us create chains of gestures.", explianationChoice: "The first gesture must succeed in order for the second to be recognized."),
                                     MutipleChoice(choice: "@Binding cannot be used with a private property.", explianationChoice: "@Binding works great with private properties.")],
                           correctChoice: 0)
        day100Questions.append(q22)
        // Question 23
        let q23 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "SwiftUI allows us to group views into a single accessibility element.", explianationChoice: "This lets us control the way those groups are read."),
                                     MutipleChoice(choice: "We can use @Environment only once per view.", explianationChoice: "It's a regular property wrapper, so you can use it as many times as you need.")],
                           correctChoice: 0)
        day100Questions.append(q23)
        // Question 24
        let q24 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "We can bind an alert() modifier to an optional value.", explianationChoice: "We also need to provide a Boolean to determine when the alert is shown, but the optional does get unwrapped for us."),
                                     MutipleChoice(choice: "SF Symbols don't have any default accessibility labels.", explianationChoice: "SF Symbols have their string name read by default.")],
                           correctChoice: 0)
        day100Questions.append(q24)
        // Question 25
        let q25 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Swift's arrays use generics.", explianationChoice: "This means we make arrays of strings or integers – we can't make an untyped array."),
                                     MutipleChoice(choice: "\"Conic gradient\" is another name for a radial gradient.", explianationChoice: "Conic gradients are angular gradients, not radial gradients.")],
                           correctChoice: 0)
        day100Questions.append(q25)
        // Question 26
        let q26 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "ImagePaint lets us tile an image as a fill or border.", explianationChoice: "It has parameters that let us customize how much of the image is used and at what size."),
                                     MutipleChoice(choice: "The createCoordinate() modifier lets us create a custom coordinate space.", explianationChoice: "You should use the coordinateSpace() modifier for this.")],
                           correctChoice: 0)
        day100Questions.append(q26)
        // Question 27
        let q27 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "A view is always and exactly the same size as its body.", explianationChoice: "When we apply size rules to a view, we are just applying those rules to whatever is in its body."),
                                     MutipleChoice(choice: "Child views must always use less than or equal to the amount of space the parent offers them.", explianationChoice: "Child views are welcome to request more space than was proposed, and the parent must respect that.")],
                           correctChoice: 0)
        day100Questions.append(q27)
        // Question 28
        let q28 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Changing any @State property of a view causes SwiftUI to reinvoke the body property.", explianationChoice: "This allows us to change what our views show over time."),
                                     MutipleChoice(choice: "Arrays cannot use the @Published property wrapper.", explianationChoice: "Arrays certainly can use the @Published property wrapper.")],
                           correctChoice: 0)
        day100Questions.append(q28)
        // Question 29
        let q29 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "contentShape() allows us to control the tap area for a view.", explianationChoice: "This is particularly useful for stacks that have layout \"holes\"."),
                                     MutipleChoice(choice: "We can show an alert by calling its show() method.", explianationChoice: "We show alerts by making their isPresented condition true.")],
                           correctChoice: 0)
        day100Questions.append(q29)
        // Question 30
        let q30 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Custom view modifiers must conform to the ViewModifier protocol.", explianationChoice: "This has one requirement: a body() method that returns some View."),
                                     MutipleChoice(choice: "ForEach views can't loop over more than 10 items, because SwiftUI doesn't allow it.", explianationChoice: "SwiftUI doesn't allow more than 10 hard-coded items inside a parent, but views created using ForEach don't count towards that limit.")],
                           correctChoice: 0)
        day100Questions.append(q30)
        // Question 31
        let q31 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "If we place views inside a Group the parent view decides how those views should be laid out.", explianationChoice: "This happens because Group is layout neutral."),
                                     MutipleChoice(choice: "We can have only one @Published property in a class.", explianationChoice: "You can have as many @Published properties in a class as you need.")],
                           correctChoice: 0)
        day100Questions.append(q31)
        // Question 32
        let q32 =
        Question(propmt: "Which of these statements are true?",
                 chioces: [MutipleChoice(choice: "SwiftUI stores view positions and sizes as integers.", explianationChoice: "Although SwiftUI rounds off its numbers when rendering, those numbers are stored as floating-point values for accuracy."),
                           MutipleChoice(choice: "SwiftUI allows no more than 10 child views inside each parent.", explianationChoice: "If you want to add more you should place your views inside groups.")],
                 correctChoice: 1)
        day100Questions.append(q32)
        // Question 33
        let q33 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "View modifiers must return the same view struct they were given.", explianationChoice: "View modifiers always return a new instance of a struct, and may create lots of new views if needed."),
                                     MutipleChoice(choice: "Context menus are triggered when users long press on a view.", explianationChoice: "This used to be done using a hard press, but long press is the standard now.")],
                           correctChoice: 1)
        day100Questions.append(q33)
        // Question 34
        let q34 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "A GeometryReader always takes up all available space in its parent.", explianationChoice: "We can change the size just like any other view."),
                                     MutipleChoice(choice: "Coordinator classes help us respond to actions in a UIViewController.", explianationChoice: "We can use them as delegates for those objects.")],
                           correctChoice: 1)
        day100Questions.append(q34)
        // Question 35
        let q35 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Before trying to stretch the contents of an image view, we should use aspectRatio(contentMode: .resize).", explianationChoice: "The correct modifier is resizable()."),
                                     MutipleChoice(choice: "We can align text in a HStack using the baseline of the first or last text views.", explianationChoice: "This is important for creating visual alignment when working with different font sizes.")],
                           correctChoice: 1)
        day100Questions.append(q35)
        // Question 36
        let q36 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "One environment object can be shared in up to two views.", explianationChoice: "There is no limit to the number of views that can share a single environment object."),
                                     MutipleChoice(choice: "When a URLSession download completes, it will send back the downloaded data plus any additional metadata.", explianationChoice: "These values are passed back in a tuple, and you can use _ to ignore either of them.")],
                           correctChoice: 1)
        day100Questions.append(q36)
        // Question 37
        let q37 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "We can use a ForEach view inside a List.", explianationChoice: "This lets us mix dynamic rows alongside static rows."),
                                     MutipleChoice(choice: "We can use a ForEach view inside a List.", explianationChoice: "SwiftUI uses the slider's values by default.")],
                           correctChoice: 0)
        day100Questions.append(q37)
        // Question 38
        let q38 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Calling data(from:) on a URLSession must be done with await.", explianationChoice: "Networking takes some time to complete, so you should never let it block your UI work."),
                                     MutipleChoice(choice: "Parent views can force a size on one of their chidren.", explianationChoice: "Parents must always respect the size requested by their children.")],
                           correctChoice: 0)
        day100Questions.append(q38)
        // Question 39
        let q39 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Unless we ask for a custom alignment, most parents always place their child views in the top-left corner of their available space.", explianationChoice: "Without further information, most parents place their child views in the center."),
                                     MutipleChoice(choice: "Text views automatically fit the size required to display all their lines.", explianationChoice: "If you want them to be larger you should use padding or a custom frame.")],
                           correctChoice: 1)
        day100Questions.append(q39)
        // Question 40
        let q40 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "You can't use a switch statement inside a SwiftUI view.", explianationChoice: "They work fine, just always make sure they are exhaustive!"),
                                     MutipleChoice(choice: "We can force a navigation view to show only one view using the .stack navigation view style.", explianationChoice: "This makes our UI simpler, but might look odd on iPad.")],
                           correctChoice: 1)
        day100Questions.append(q40)
        // Question 41
        let q41 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "We can ask the user to enter multiple lines of text using TextEditor.", explianationChoice: "If you only want a single line of text, use TextField instead."),
                                     MutipleChoice(choice: "If we want to modify a property, we need to use a SwiftUI property wrapper such as @Property.", explianationChoice: "@Property is not a SwiftUI property wrapper; we should use @State instead.")],
                           correctChoice: 0)
        day100Questions.append(q41)
        // Question 42
        let q42 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "We must always return some View from a SwiftUI view body.", explianationChoice: "You can return an explicit type if you want, but it's not recommended."),
                                     MutipleChoice(choice: "We can call objectWillChange.send() to notify SwiftUI that an observable object is about to change.", explianationChoice: "This allows us to add custom functionality to changes before triggering the notification.")],
                           correctChoice: 1)
        day100Questions.append(q42)
        // Question 43
        let q43 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "We can't use onDelete(perform:) with views backed by Core Data objects.", explianationChoice: "onDelete(perform:) doesn't care what data it works with, so it works fine with Core Data."),
                                     MutipleChoice(choice: "We can attach swipe actions to one or both sides of a list row.", explianationChoice: "These are buttons, so we need to provide a label and an action.")],
                           correctChoice: 1)
        day100Questions.append(q43)
        // Question 44
        let q44 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "The [C] modifier for NSPredicate marks the predicate as being case-sensitive.", explianationChoice: "[C] makes an NSPredicate case-insensitive."),
                                     MutipleChoice(choice: "All SwiftUI views must have a body property.", explianationChoice: "This body must always return precisely one view. That view might contain more views inside it, but you still need to return precisely one from the computed property.")],
                           correctChoice: 1)
        day100Questions.append(q44)
        // Question 45
        let q45 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Accessibility labels must always be a single hard-coded string.", explianationChoice: "You can create them however you want, such as from JSON downloaded from the internet."),
                                     MutipleChoice(choice: "The InsettableShape protocol builds on the Shape protocol.", explianationChoice: "This means we don't need to make our custom shapes conform to both.")],
                           correctChoice: 1)
        day100Questions.append(q45)
        // Question 46
        let q46 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "iOS can take care of file encryption for using the .completeFileProtection option.", explianationChoice: "This stops anyone from reading the file unless the device has been unlocked."),
                                     MutipleChoice(choice: "To read when return is pressed for a text view we should add an onReturnPressed() modifier.", explianationChoice: "We should handle this using the onSubmit() modifier.")],
                           correctChoice: 0)
        day100Questions.append(q46)
        // Question 47
        let q47 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "We can create a new task at any time using Task { … }.", explianationChoice: "This is the best way to run an asynchronous function from a synchronous one, such as a button action"),
                                     MutipleChoice(choice: "SwiftUI has five built-in coordinate spaces.", explianationChoice: "SwiftUI only has two built-in coordinate spaces: global and local.")],
                           correctChoice: 0)
        day100Questions.append(q47)
        // Question 48
        let q48 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "NavigationView lets us push a new custom view, or a basic type such as Text.", explianationChoice: "Pushing basic views is an easy way to prototype a layout."),
                                     MutipleChoice(choice: "SwiftUI's lists cannot work with computed properties.", explianationChoice: "SwiftUI's lists work great with computed properties.")],
                           correctChoice: 0)
        day100Questions.append(q48)
        // Question 49
        let q49 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Buttons must be given a function or closure to be run when they are tapped.", explianationChoice: "Without some sort of action to run, the button would be pointless. The only small exception here is the action for alert buttons, but even though it's empty you still need to provide it."),
                                     MutipleChoice(choice: "Fetch requests must be created using the @FetchRequest property wrapper.", explianationChoice: "We can create fetch requests without the property wrapper using the FetchRequest struct.")],
                           correctChoice: 0)
        day100Questions.append(q49)
        // Question 50
        let q50 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Alerts are created with a title, but you can also add an extra message if you want one.", explianationChoice: "The message part is provided using a second trailing closure."),
                                     MutipleChoice(choice: "Swift's Result type is designed for use with throwing functions.", explianationChoice: "It can be used with throwing functions, but it doesn't need to be.")],
                           correctChoice: 0)
        day100Questions.append(q50)
        // Question 51
        let q51 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "onDelete(perform:) cannot be attached directly to a List view.", explianationChoice: "We must attach onDelete(perform:) to a ForEach view instead."),
                                     MutipleChoice(choice: "Timers automatically pause as soon as our app moves to the background.", explianationChoice: "Timers will pause at some point, but it won't be immediately.")],
                           correctChoice: 0)
        day100Questions.append(q51)
        // Question 52
        let q52 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "We can receive values from a Combine publisher using onReceive().", explianationChoice: "This can be a Timer, a notification from Notification Center, or something else."),
                                     MutipleChoice(choice: "We can animate views, but we can't animate view overlays.", explianationChoice: "You can animate view overlays just like views.")],
                           correctChoice: 0)
        day100Questions.append(q52)
        // Question 53
        let q53 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Stacks can have unlimited numbers of views inside them.", explianationChoice: "Stacks are subject to the same 10-child limit as other SwiftUI views."),
                                     MutipleChoice(choice: "A GeometryReader is given one value inside its layout closure, which is a GeometryProxy containing layout information.", explianationChoice: "We can use this to read our proposed size, our frame, and more.")],
                           correctChoice: 1)
        day100Questions.append(q53)
        // Question 54
        let q54 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Rotating then translating a transform gives the same result as translating then rotating.", explianationChoice: "They give different results. Imagine walking forward 10 paces then turning right, compared to turning right then walking forward 10 paces."),
                                     MutipleChoice(choice: "If we want to animate a shape changing, we should add an animatableData property.", explianationChoice: "What this does is down to us; SwiftUI just cares that it exists and is something that can be interpolated smoothly.")],
                           correctChoice: 1)
        day100Questions.append(q54)
        // Question 55
        let q55 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "The clipped() modifier lets us specify a shape for a view should to be drawn inside.", explianationChoice: "You should use the clipShape() modifier for this purpose."),
                                     MutipleChoice(choice: "Swift's Result type can contain either success or failure, but not both.v", explianationChoice: "This lets us reduce complexity in our code by eliminating impossible program states.")],
                           correctChoice: 1)
        day100Questions.append(q55)
        // Question 56
        let q56 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Asymmetric transitions let us combine transitions with explicit animations.", explianationChoice: "Asymmetric transitions let us specify one transition for insertion and another for removal."),
                                     MutipleChoice(choice: "If we want to programmatically set the active tab for a TabView, we must set a tag on the views inside it.", explianationChoice: "The tag can be anything that conforms to the Hashable protocol, such as an integer or a string.")],
                           correctChoice: 1)
        day100Questions.append(q56)
        // Question 57
        let q57 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "To enable swipe to delete for list rows, we should add an onSwipeToDelete() modifier.", explianationChoice: "This modifier does not exist."),
                                     MutipleChoice(choice: "To remove the label from a date picker, we should use labelsHidden().", explianationChoice: "This is much better than using an empty label, which causes problems for screen readers.")],
                           correctChoice: 1)
        day100Questions.append(q57)
        // Question 58
        let q58 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Using withAnimation() always uses a spring animation.", explianationChoice: "You can specify exactly which animation to use."),
                                     MutipleChoice(choice: "We can pass data to views inside their initializer.", explianationChoice: "This means we can be sure all data exists by the time the view's body is loaded.")],
                           correctChoice: 1)
        day100Questions.append(q58)
        // Question 59
        let q59 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "One instance of a class can be used in many SwiftUI views.", explianationChoice: "This allows us to share data between views."),
                                     MutipleChoice(choice: "We can't absolutely position views in SwiftUI.", explianationChoice: "This is what the position() modifier is for.")],
                           correctChoice: 0)
        day100Questions.append(q59)
        // Question 60
        let q60 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "We can use multiple animation() modifiers on a single view.", explianationChoice: "Using several animation modifiers lets us animate a view's state in different ways."),
                                     MutipleChoice(choice: "We can apply no more than three modifiers to a single view.", explianationChoice: "You can apply as many modifiers as you want.")],
                           correctChoice: 0)
        day100Questions.append(q60)
        // Question 61
        let q61 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Classes that are used with @ObservableObject must conform to the ObservedObject protocol.", explianationChoice: "@ObservedObject is the property wrapper, and ObservableObject is the protocol."),
                                     MutipleChoice(choice: "Asynchronous functions are able to sleep while their work completes.", explianationChoice: "This allows our app to perform other work at the same time.")],
                           correctChoice: 1)
        day100Questions.append(q61)
        // Question 62
        let q62 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "If we specify the width of an image, we must also specify its height.", explianationChoice: "We can specify the width, the height, both, or neither – all will work."),
                                     MutipleChoice(choice: "One NavigationView can show two or three views inside it.", explianationChoice: "This allows us to create a split view layout.")],
                           correctChoice: 1)
        day100Questions.append(q62)
        // Question 63
        let q63 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Materials let us apply a frosted glass-style blur effect for our view backgrounds.", explianationChoice: "When combined with foregroundStyle(.secondary) this helps ensure UI elements stand out well from the background."),
                                     MutipleChoice(choice: "We can make a view take up all available screen width by using frame(maxWidth: .fill).", explianationChoice: "We should use frame(maxWidth: .infinity) for this purpose.")],
                           correctChoice: 0)
        day100Questions.append(q63)
        // Question 64
        let q64 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Swift has a built-in type for handling dates.", explianationChoice: "It's called Date and stores year, month, day, hour, minute, second, and more."),
                                     MutipleChoice(choice: "It's a good idea to use drawingGroup() for all your drawing.", explianationChoice: "You should only use drawingGroup() when you really need it.")],
                           correctChoice: 0)
        day100Questions.append(q64)
        // Question 65
        let q65 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "SwiftUI's buttons require a function that accepts the button that got tapped as its only parameter.", explianationChoice: "Buttons require a function that accepts no parameters and returns nothing."),
                                     MutipleChoice(choice: "@Binding lets us share one value in two places.", explianationChoice: "It's mainly used for creating custom UI components.")],
                           correctChoice: 1)
        day100Questions.append(q65)
        // Question 66
        let q66 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "We can check whether one or both of a Boolean is true using OR, for example booleanA OR booleanB", explianationChoice: "We need to use the || operator for this purpose."),
                                     MutipleChoice(choice: "Writing data atomically means that iOS writes to a temporary file then performs a rename.", explianationChoice: "This stops another piece of code from reading the file part-way through a write.")],
                           correctChoice: 1)
        day100Questions.append(q66)
        // Question 67
        let q67 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "We should mark all our properties as @ViewBuilder.", explianationChoice: "This attribute is useful in a handful of places, but you shouldn't use it a lot and certainly not for all properties."),
                                     MutipleChoice(choice: "We can add a search bar to any view using searchable().", explianationChoice: "Bind its text to a property and you can automatically reload your view as the user's search changes.")],
                           correctChoice: 1)
        day100Questions.append(q67)
        // Question 68
        let q68 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "In Core Data, Integer 16 is designed to hold 16 different numbers.", explianationChoice: "Integer 16 holds one 16-bit number."),
                                     MutipleChoice(choice: "When creating a text field we need to provide some placeholder text.", explianationChoice: "This helps users see what should be entered, and is also useful to screen readers.")],
                           correctChoice: 1)
        day100Questions.append(q68)
        // Question 69
        let q69 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "The order in which we apply modifiers affects the result we get.", explianationChoice: "For example, setting the frame then applying a background color is different from applying a background color then setting the frame."),
                                     MutipleChoice(choice: "sheet() requires a NavigationView to work.", explianationChoice: "Sheets are presented above the current screen, and so don't require a navigation view.")],
                           correctChoice: 0)
        day100Questions.append(q69)
        // Question 70
        let q70 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Gradients must never be used outside the safe area.", explianationChoice: "You can place them anywhere you like, including outside the safe area."),
                                     MutipleChoice(choice: "We can ask the user to select a photo from their library using PHPickerViewController.", explianationChoice: "They can browse for whatever picture they want, or press Cancel.")],
                           correctChoice: 1)
        day100Questions.append(q70)
        // Question 71
        let q71 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "The @Binding property wrapper creates a Binding struct.", explianationChoice: "This is all that property wrappers do behind the scenes."),
                                     MutipleChoice(choice: "SwiftUI coordinators cannot act as delegates for another class.", explianationChoice: "SwiftUI coordinators are specifically designed to act as delegates for another class.")],
                           correctChoice: 0)
        day100Questions.append(q71)
        // Question 72
        let q72 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Alerts and confirmation dialogs look the same on iPhone.", explianationChoice: "Alerts appear in the center of the screen, whereas confirmation dialogs slide up from the bottom."),
                                     MutipleChoice(choice: "Breaking SwiftUI views into smaller views has little to no performance impact.", explianationChoice: "SwiftUI does an excellent job of optimizing this behavior.")],
                           correctChoice: 1)
        day100Questions.append(q72)
        // Question 73
        let q73 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "When creating views in a loop, SwiftUI needs to know how to identify each view uniquely.", explianationChoice: "This lets it understand which views were added or removed."),
                                     MutipleChoice(choice: "Decoding data from JSON will always succeed.", explianationChoice: "Decoding data from JSON might fail, for example if the JSON was invalid or contained the wrong type of data.")],
                           correctChoice: 0)
        day100Questions.append(q73)
        // Question 74
        let q74 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "The @Published property wrapper places our properties inside a Published struct.", explianationChoice: "Behind the scenes, this is actually similar to how optionals work."),
                                     MutipleChoice(choice: "An @ObservedObject struct will notify all views that use it when one of its @Published properties change.", explianationChoice: "Structs cannot be used with @ObservedObject.")],
                           correctChoice: 0)
        day100Questions.append(q74)
        // Question 75
        let q75 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "We can detect when a sheet is closed by setting its onClose parameter.", explianationChoice: "We should use onDismiss for this purpose."),
                                     MutipleChoice(choice: "We can embed a HStack inside a VStack.", explianationChoice: "This lets us make grid structures fairly easily.")],
                           correctChoice: 1)
        day100Questions.append(q75)
        // Question 76
        let q76 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "%@ in an NSPredicate is dynamically replaced with a sort order.", explianationChoice: "%@ is dynamically replaced with some sort of value in quote marks; sorting is controlled through SortDescriptor."),
                                     MutipleChoice(choice: "The offset() modifier changes where a view is rendered without actually changing its original dimensions.", explianationChoice: "This subsequent modifiers will use the view's original dimensions.")],
                           correctChoice: 1)
        day100Questions.append(q76)
        // Question 77
        let q77 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "We can let users delete items from a List by adding the onDelete() modifier to it.", explianationChoice: "The onDelete() modifier exists only on ForEach."),
                                     MutipleChoice(choice: "If we write Text(\"Hello, World!\").background(.red), the text view is a child of the background.", explianationChoice: "The background view becomes the outermost view, with our text inside.")],
                           correctChoice: 1)
        day100Questions.append(q77)
        // Question 78
        let q78 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "@EnvironmentObject properties must conform to ObservableObject.", explianationChoice: "They use exactly the same protocol, which means @Published and more works."),
                                     MutipleChoice(choice: "The disabled() modifier can read any kind of property, but must not be used with methods.", explianationChoice: "You can use a method if you want, as long as it returns a Boolean.")],
                           correctChoice: 0)
        day100Questions.append(q78)
        // Question 79
        let q79 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "By default, a NavigationView doesn't work in landscape.", explianationChoice: "NavigationView works fine in landscape, but you should remember to provide a second view to use as the default detail view."),
                                     MutipleChoice(choice: "Classes that are used with @StateObject must conform to the ObservableObject protocol.", explianationChoice: "@ObservedObject is a property wrapper, and ObservableObject is the protocol.")],
                           correctChoice: 1)
        day100Questions.append(q79)
        // Question 80
        let q80 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Views with an onTapGesture() modifier automatically have the isButton trait.", explianationChoice: "You need to add this trait by hand."),
                                     MutipleChoice(choice: "It's possible to mix static and dynamic rows in a List.", explianationChoice: "You can have static rows then dynamic, then more static, then more dynamic, and so on.")],
                           correctChoice: 1)
        day100Questions.append(q80)
        // Question 81
        let q81 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "All paths are also shapes.", explianationChoice: "Paths are not shapes; they are different things."),
                                     MutipleChoice(choice: "GeometryReader lets us read the size of a view's container.", explianationChoice: "This is helpful for making sure images are created at the right size.")],
                           correctChoice: 1)
        day100Questions.append(q81)
        // Question 82
        let q82 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "We can detect when an @State property changes using a property observer.", explianationChoice: "This doesn't always work; we need to use the onChange() modifier instead."),
                                     MutipleChoice(choice: "GeometryReader tells us the size that was proposed by our parent.", explianationChoice: "This lets us create relative layouts easily.")],
                           correctChoice: 1)
        day100Questions.append(q82)
        // Question 83
        let q83 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Semantic colors are colors that are named according to their use rather than according to their hue.", explianationChoice: "For example, Color.primary might be light or dark depending on the device theme."),
                                     MutipleChoice(choice: "SwiftUI view previews shouldn't have properties of their own.", explianationChoice: "SwiftUI view previews can have as many properties as they need to work.")],
                           correctChoice: 0)
        day100Questions.append(q83)
        // Question 84
        let q84 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "AnimatablePair lets us animate any two kinds of data.", explianationChoice: "AnimatablePair can only animate values that are animatable, which excludes integers."),
                                     MutipleChoice(choice: "ForEach views let us loop over ranges and arrays.", explianationChoice: "They are used to create many instances of something very quickly.")],
                           correctChoice: 1)
        day100Questions.append(q84)
        // Question 85
        let q85 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "If we use .accessibilityElement(children: .ignore) the entire view becomes invisible to VoiceOver.", explianationChoice: "The things inside the view aren't accessible individually, but the parent view is."),
                                     MutipleChoice(choice: "When we import a Core ML model into Xcode, it will automatically generate a Swift class for us to use.", explianationChoice: "This lets us create an instance of the model and request a prediction in only two lines of code.")],
                           correctChoice: 1)
        day100Questions.append(q85)
        // Question 86
        let q86 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "We can draw borders with a custom shape by using the overlay() modifier.", explianationChoice: "We can apply separate modifiers to that overlay, such as a border."),
                                     MutipleChoice(choice: "We can control the visual appearance of a list using the listViewStyle() modifier.", explianationChoice: "The modifier is listStyle().")],
                           correctChoice: 0)
        day100Questions.append(q86)
        // Question 87
        let q87 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "When the disabled() modifier is given a false condition, the view it's attached to stops responding to user interactivity.", explianationChoice: "It's the other way around: the condition must be true to disable the view."),
                                     MutipleChoice(choice: "Colors are views in SwiftUI.", explianationChoice: "This allows us to use them directly inside stacks.")],
                           correctChoice: 1)
        day100Questions.append(q87)
        // Question 88
        let q88 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "The @Published property wrapper watches an observed object for changes.", explianationChoice: "@Published announces changes from a property; @ObservedObject watches an observed object for changes."),
                                     MutipleChoice(choice: "A coordinator class lets us handle communication back from a UIKit view controller.", explianationChoice: "Coordinators act as bridges between SwiftUI's views and UIKit's view controllers.")],
                           correctChoice: 1)
        day100Questions.append(q88)
        // Question 89
        let q89 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Pickers are always shown as spinning wheels in iOS.", explianationChoice: "Pickers might be wheels, segmented controls, or even new views that slide on and off the screen."),
                                     MutipleChoice(choice: "We can dynamically replace an NSPredicate string with an attribute name using %K.", explianationChoice: "This must always be used rather than %@, otherwise Core Data will insert quote marks too.")],
                           correctChoice: 1)
        day100Questions.append(q89)
        // Question 90
        let q90 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "When allowsHitTesting() is false, a view cannot be tapped.", explianationChoice: "Any taps simply pass through to whatever is stacked below."),
                                     MutipleChoice(choice: "SwiftUI disables image interpolation by default.", explianationChoice: "SwiftUI enables high-quality interpolation by default.")],
                           correctChoice: 0)
        day100Questions.append(q90)
        // Question 91
        let q91 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Using a value of 100 with the scaleEffect() modifier makes a view its natural size.", explianationChoice: "That will make the view 100x its natural size."),
                                     MutipleChoice(choice: "We can attach an animation() modifier to a binding.", explianationChoice: "This causes changes in the binding to trigger an animation. Remember to add the value parameter so SwiftUI knows which value to watch for changes!")],
                           correctChoice: 1)
        day100Questions.append(q91)
        // Question 92
        let q92 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "If all the properties of a type conform to the Hashable protocol, the type itself can also conform just by adding Hashable to its list of conformances.", explianationChoice: "This works just the same as Codable."),
                                     MutipleChoice(choice: "When creating a custom alignment guide, it's recommended to use structs rather than enums.", explianationChoice: "The opposite is true: it's a good idea to use enums.")],
                           correctChoice: 0)
        day100Questions.append(q92)
        // Question 93
        let q93 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "The @MainActor attribute should be used on all classes.", explianationChoice: "Classes that conform to the ObservableObject protocol should have this attribute, but it's not required on all classes."),
                                     MutipleChoice(choice: "Segmented controls are created using picker views in SwiftUI.", explianationChoice: "Pickers adopt segmented styling when we apply the .pickerStyle(.segmented) modifier on them.")],
                           correctChoice: 1)
        day100Questions.append(q93)
        // Question 94
        let q94 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Asynchronous function calls will always sleep for some amount of time.", explianationChoice: "An asynchronous function might sleep, but doesn't need to."),
                                     MutipleChoice(choice: "Images built from SF Symbols icons have a customizable foreground color.", explianationChoice: "This lets us display the icons in whatever color we want.")],
                           correctChoice: 1)
        day100Questions.append(q94)
        // Question 95
        let q95 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "rotation3DEffect() can rotate around more than one axis.", explianationChoice: "Try using (x: 1, y: 1, z: 0), for example."),
                                     MutipleChoice(choice: "A view's body can return View rather than some View in exceptional circumstances.", explianationChoice: "It is not possible to return View from a view's body.")],
                           correctChoice: 0)
        day100Questions.append(q95)
        // Question 96
        let q96 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "Every VStack must include one Spacer view.", explianationChoice: "Spacers aren't required, and are often not needed at all."),
                                     MutipleChoice(choice: "Trailing toolbar buttons appear on the right in left-to-right languages.", explianationChoice: "This is automatically flipped for right-to-left languages.")],
                           correctChoice: 1)
        day100Questions.append(q96)
        // Question 97
        let q97 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "We can pop a view from a NavigationView using the same dismiss action we use for sheets.", explianationChoice: "Popping a view is the equivalent of tapping Back or swiping from the left edge."),
                                     MutipleChoice(choice: "Using the multiply blend mode usually results in a lighter image.", explianationChoice: "Using multiply nearly always results in a darker image, and at its brightest it still cannot produce images that are lighter than the original.")],
                           correctChoice: 0)
        day100Questions.append(q97)
        // Question 98
        let q98 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "The destination of a NavigationLink is always shown in the current view.", explianationChoice: "If we have two views in a navigation view, NavigationLink presents destinations in the secondary view."),
                                     MutipleChoice(choice: "SwiftUI's previews aren't included in our app if we send it to the App Store.", explianationChoice: "Swift automatically strips out the previews; they are just there to help us design our UI.")],
                           correctChoice: 1)
        day100Questions.append(q98)
        // Question 29
        let q99 = Question(propmt: "Which of these statements are true?",
                           chioces: [MutipleChoice(choice: "NavigationLink requires a NavigationView to work.", explianationChoice: "Without a navigation view around it, navigation links have no way of pushing new views onto the screen."),
                                     MutipleChoice(choice: "Color is both a view and a shape.", explianationChoice: "Color is a view, but not a shape.")],
                           correctChoice: 0)
        day100Questions.append(q99)
        // Question 100
        let q100 = Question(propmt: "Which of these statements are true?",
                            chioces: [MutipleChoice(choice: "The blur() modifier applies a Gaussian blur to a view, using a radius we specify.", explianationChoice: "This is all done on the GPU, so it's really fast."),
                                      MutipleChoice(choice: "We can use implicit animation or explicit animation, but not both.", explianationChoice: "You can mix and match however much you want.")],
                            correctChoice: 0)
        day100Questions.append(q100)
    }
}


