//
//  Day21_GuessTheFlagPart2App.swift
//  Day21_GuessTheFlagPart2
//
//  Created by Lee McCormick on 3/21/22.
//

import SwiftUI

@main
struct Day21_GuessTheFlagPart2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Stacking up buttons
 We’re going to start our app by building the basic UI structure, which will be two labels telling the user what to do, then three image buttons showing three world flags.
 
 First, find the assets for this project and drag them into your asset catalog. That means opening Assets.xcassets in Xcode, then dragging in the flag images from the project2-files folder. You’ll notice that the images are named after their country, along with either @2x or @3x – these are images at double resolution and triple resolution to handle different types of iPhone screen.
 
 Next, we need two properties to store our game data: an array of all the country images we want to show in the game, plus an integer storing which country image is correct.
 
 var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
 var correctAnswer = Int.random(in: 0...2)
 The Int.random(in:) method automatically picks a random number, which is perfect here – we’ll be using that to decide which country flag should be tapped.
 
 Inside our body, we need to lay out our game prompt in a vertical stack, so let’s start with that:
 
 var body: some View {
 VStack {
 Text("Tap the flag of")
 Text(countries[correctAnswer])
 }
 }
 Below there we want to have our tappable flag buttons, and while we could just add them to the same VStack we can actually create a second VStack so that we have more control over the spacing.
 
 The VStack we just created above holds two text views and has no spacing, but the flags are going to have 30 points of spacing between them so it looks better.
 
 So, start by adding this ForEach loop directly below the end of the VStack we just created:
 
 ForEach(0..<3) { number in
 Button {
 // flag was tapped
 } label: {
 Image(countries[number])
 .renderingMode(.original)
 }
 }
 The renderingMode(.original) modifier tells SwiftUI to render the original image pixels rather than trying to recolor them as a button.
 
 And now we have a problem: our body property is trying to send back two views, a VStack and a ForEach, but that won’t work correctly. This is where our second VStack will come in: I’d like you to wrap the original VStack and the ForEach below in a new VStack, this time with a spacing of 30 points.
 
 So your code should look like this:
 
 var body: some View {
 VStack(spacing: 30) {
 VStack {
 Text("Tap the flag of")
 // etc
 }
 
 ForEach(0..<3) { number in
 // etc
 }
 }
 }
 Having two vertical stacks like this allows us to position things more precisely: the outer stack will space its views out by 30 points each, whereas the inner stack has no spacing.
 
 That’s enough to give you a basic idea of our user interface, and already you’ll see it doesn’t look great – some flags have white in them, which blends into the background, and all the flags are centered vertically on the screen.
 
 We’ll come back to polish the UI later, but for now let’s put in a blue background color to make the flags easier to see. Because this means putting something behind our outer VStack, we need to use a ZStack as well. Yes, we’ll have a VStack inside another VStack inside a ZStack, and that is perfectly normal.
 
 Start by putting a ZStack around your outer VStack, like this:
 
 var body: some View {
 ZStack {
 // previous VStack code
 }
 }
 Now put this just inside the ZStack, so it goes behind the outer VStack:
 
 Color.blue
 .ignoresSafeArea()
 That .ignoresSafeArea() modifier ensures the color goes right to the edge of the screen.
 
 Now that we have a darker background color, we should give the text something brighter so that it stands out better:
 
 Text("Tap the flag of")
 .foregroundColor(.white)
 
 Text(countries[correctAnswer])
 .foregroundColor(.white)
 This design is not going to set the world alight, but it’s a solid start!
 */

/* Showing the player’s score with an alert
 In order for this game to be fun, we need to randomize the order in which flags are shown, trigger an alert telling them whether they were right or wrong whenever they tap a flag, then reshuffle the flags.
 
 We already set correctAnswer to a random integer, but the flags always start in the same order. To fix that we need to shuffle the countries array when the game starts, so modify the property to this:
 
 var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
 As you can see, the shuffled() method automatically takes care of randomizing the array order for us.
 
 Now for the more interesting part: when a flag has been tapped, what should we do? We need to replace the // flag was tapped comment with some code that determines whether they tapped the correct flag or not, and the best way of doing that is with a new method that accepts the integer of the button and checks whether that matches our correctAnswer property.
 
 Regardless of whether they were correct, we want to show the user an alert saying what happened so they can track their progress. So, add this property to store whether the alert is showing or not:
 
 @State private var showingScore = false
 And add this property to store the title that will be shown inside the alert:
 
 @State private var scoreTitle = ""
 So, whatever method we write will accept the number of the button that was tapped, compare that against the correct answer, then set those two new properties so we can show a meaningful alert.
 
 Add this directly after the body property:
 
 func flagTapped(_ number: Int) {
 if number == correctAnswer {
 scoreTitle = "Correct"
 } else {
 scoreTitle = "Wrong"
 }
 
 showingScore = true
 }
 We can now call that by replacing the // flag was tapped comment with this:
 
 flagTapped(number)
 We already have number because it’s given to us by ForEach, so it’s just a matter of passing that on to flagTapped().
 
 Before we show the alert, we need to think about what happens when the alert is dismissed. Obviously the game shouldn’t be over, otherwise the whole thing would be over immediately.
 
 Instead we’re going to write an askQuestion() method that resets the game by shuffling up the countries and picking a new correct answer:
 
 func askQuestion() {
 countries.shuffle()
 correctAnswer = Int.random(in: 0...2)
 }
 That code won’t compile, and hopefully you’ll see why pretty quickly: we’re trying to change properties of our view that haven’t been marked with @State, which isn’t allowed. So, go to where countries and correctAnswer are declared, and put @State private before them, like this:
 
 @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
 @State private var correctAnswer = Int.random(in: 0...2)
 And now we’re ready to show the alert. This needs to:
 
 Use the alert() modifier so the alert gets presented when showingScore is true.
 Show the title we set in scoreTitle.
 Have a dismiss button that calls askQuestion() when tapped.
 So, put this at the end of the ZStack in the body property:
 
 .alert(scoreTitle, isPresented: $showingScore) {
 Button("Continue", action: askQuestion)
 } message: {
 Text("Your score is ???")
 }
 Yes, there are three question marks that should hold a score value – you’ll be completing that part soon!
 */

/* Styling our flags
 Our game now works, although it doesn’t look great. Fortunately, we can make a few small tweaks to our design to make the whole thing look better.
 
 First, let’s replace the solid blue background color with a linear gradient from blue to black, which ensures that even if a flag has a similar blue stripe it will still stand out against the background.
 
 So, find this line:
 
 Color.blue
 .ignoresSafeArea()
 And replace it with this:
 
 LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
 .ignoresSafeArea()
 It still ignores the safe area, ensuring that the background goes edge to edge.
 
 Now let’s adjust the fonts we’re using just a little, so that the country name – the part they need to guess – is the most prominent piece of text on the screen, while the “Tap the flag of” text is smaller and bold.
 
 We can control the size and style of text using the font() modifier, which lets us select from one of the built-in font sizes on iOS. As for adjusting the weight of fonts – whether we want super-thing text, slightly bold text, etc – we can get fine-grained control over that by adding a weight() modifier to whatever font we ask for.
 
 Let’s use both of these here, so you can see them in action. Add this directly after the “Tap the flag of” text:
 
 .font(.subheadline.weight(.heavy))
 And put this modifiers directly after the Text(countries[correctAnswer]) view:
 
 .font(.largeTitle.weight(.semibold))
 “Large title” is the largest built-in font size iOS offers us, and automatically scales up or down depending on what setting the user has for their fonts – a feature known as Dynamic Type. We’re overriding the weight of the font so it’s a little bolder, but it will still scale up or down as needed.
 
 Finally, let’s jazz up those flag images a little. SwiftUI gives us a number of modifiers to affect the way views are presented, and we’re going to use two here: one to change the shape of flags, and one to add a shadow.
 
 There are four built-in shapes in Swift: rectangle, rounded rectangle, circle, and capsule. We’ll be using capsule here: it ensures the corners of the shortest edges are fully rounded, while the longest edges remain straight – it looks great for buttons. Making our image capsule shaped is as easy as adding the .clipShape(Capsule()) modifier, like this:
 
 .clipShape(Capsule())
 And finally we want to apply a shadow effect around each flag, making them really stand out from the background. This is done using shadow(), which takes the color, radius, X, and Y offset of the shadow, but if you skip the color we get a translucent black, and if we skip X and Y it assumes 0 for them – all sensible defaults.
 
 So, add this last modifier below the previous two:
 
 .shadow(radius: 5)
 So, our finished flag image looks like this:
 
 Image(countries[number])
 .renderingMode(.original)
 .clipShape(Capsule())
 .shadow(radius: 5)
 SwiftUI has so many modifiers that help us adjust the way fonts and images are rendered. They all do exactly one thing, so it’s common to stack them up as you can see above.
 */

/* Upgrading our design
 At this point we’ve built the app and it works well, but with all the SwiftUI skills you’ve learned so far we can actually take what we’ve built and re-skin it – produce a different UI for the project we’ve currently built. This won’t affect the logic at all; we’re just trying out some different UI to see what you can do with your current knowledge.
 
 Experimenting with designs like this is a lot of fun, but I do want to add one word of caution: at the very least, make sure you run your code on all sizes of iOS device, from the tiny iPod touch up to an iPhone 13 Pro Max. Finding something that works well on that wide range of screen sizes takes some thinking!
 
 Let’s start off with the blue-black gradient we have behind our flags. It was okay to get us going, but now I want to try something a little fancier: a radial gradient with custom stops.
 
 Previously I showed you how we can use very precise gradient stop locations to adjust the way our gradient is drawn. Well, if we create two stops that are identical to each other then the gradient goes away entirely – the color just switches from one to the other directly. Let’s try it out with our current design:
 
 RadialGradient(stops: [
 .init(color: .blue, location: 0.3),
 .init(color: .red, location: 0.3),
 ], center: .top, startRadius: 200, endRadius: 700)
 .ignoresSafeArea()
 That’s an interesting effect, I think – like we have a blue circle overlaid on top of a red background. That said, it’s also ugly: those red and blue colors together are much too bright.
 
 So, we can send in toned-down versions of those same colors to get something looking more harmonious – shades that are much more common in flags:
 
 RadialGradient(stops: [
 .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
 .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
 ], center: .top, startRadius: 200, endRadius: 400)
 .ignoresSafeArea()
 Next, right now we have a VStack with spacing of 30 to place the question area and the flags, but I’d like to reduce that down to 15:
 
 VStack(spacing: 15) {
 Why? Well, because we’re going to make that whole area into a visual element in our UI, making it a colored rounded rectangle so that part of the game stands out on the screen.
 
 To do that, add these modifiers to the end of the same VStack:
 
 .frame(maxWidth: .infinity)
 .padding(.vertical, 20)
 .background(.regularMaterial)
 .clipShape(RoundedRectangle(cornerRadius: 20))
 That lets it resize to take up all the horizontal space it needs, adds a little vertical padding, applies a background material so that it stands out from the red-blue gradient the background, and finally clips the whole thing into the shape of a rounded rectangle.
 
 I think that’s already looking a lot better, but let’s keep pressing on!
 
 Our next step is to add a title before our main box, and a score placeholder after. This means another VStack around what we have so far, because the existing VStack(spacing: 15) we have is where we apply the material effect.
 
 So, wrap your current VStack in a new one with a title at the top, like this:
 
 VStack {
 Text("Guess the Flag")
 .font(.largeTitle.weight(.bold))
 .foregroundColor(.white)
 
 // current VStack(spacing: 15) code
 }
 Tip: Asking for bold fonts is so common there’s actually a small shortcut: .font(.largeTitle.bold()).
 
 That adds a new title at the top, but we can also slot in a score label at the bottom of that new VStack, like this:
 
 Text("Score: ???")
 .foregroundColor(.white)
 .font(.title.bold())
 Both the “Guess the Flag” title and score label look great with white text, but the text inside our box doesn’t – we made it white because it was sitting on top of a dark background originally, but now it’s really hard to read.
 
 To fix this, we can delete the foregroundColor() modifier for Text(countries[correctAnswer]) so that it defaults to using the primary color for the system – black in light mode, and white in dark mode.
 
 As for the white “Tap the flag of”, we can have that use the iOS vibrancy effect to let a little of the background color shine through. Change its foregroundColor() modifier to this:
 
 .foregroundStyle(.secondary)
 At this point our UI more or less works, but I think it’s a little too squished up – if you’re on a larger device you’ll see the content all sits in the center of the screen with lots of space above and below, and the white box in the middle runs right to the edges of the screen.
 
 To fix this we’re going to do two things: add a little padding to our outermost VStack, then add some Spacer() views to force the UI elements apart. On larger devices these spacers will split up the available space between them, but on small devices they’ll practically disappear – it’s a great way to make our UI work well on all screen sizes.
 
 There are four spacers I’d like you to add:
 
 One directly before the “Guess the Flag” title.
 Two (yes, two) directly before the “Score: ???” text.
 And one directly after the “Score: ???” text.
 Remember, when you have multiple spacers like this they will automatically divide the available space equally – having two spacers together will make them take up twice as much space as a single spacer.
 
 And now all that remains is to add a little padding around the outermost VStack, with this:
 
 .padding()
 And that’s our refreshed design complete! Having all those spacers means that on small devices such as the iPod touch, while also scaling up smoothly to look good even on Pro Max iPhones.
 
 However, this is only one possible design for our app – maybe you prefer the old design over this one, or maybe you want to try something else. The point is, you’ve seen how even with the handful of SwiftUI skills you already have it’s possible to build very different designs, and if you have the time I would encourage you to have a play around and see where you end up!
 */
