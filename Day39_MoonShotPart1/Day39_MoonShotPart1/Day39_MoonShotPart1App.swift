//
//  Day39_MoonShotPart1App.swift
//  Day39_MoonShotPart1
//
//  Created by Lee McCormick on 4/8/22.
//

import SwiftUI

@main
struct Day39_MoonShotPart1App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 8, part 1
 When I first wrote this course back in 2019, Apple TV+ had just launched. Back then, the show everyone was talking about was “For All Mankind”, which dramatized an alternative history of the 1969 moon landing. So, I built today’s new project around that theme, detailing some of the history behind NASA’s Apollo space program.

 I also think it would be fitting if today’s quote came from Neil Armstrong, the first person to walk on the moon. Back in 2000 he said, “science is about what is; engineering is about what can be.” I don’t know about you, but I find that hugely inspiring: every time we create a new Xcode project we have a blank slate to work with, and that can be whatever we want.

 Today we’re learning about the techniques to build Moonshot, but as with all the techniques we’re learning they form part of your larger knowledge for you to mix and remix as you please for years to come.

 Today you have five topics to work through, in which you’ll learn about GeometryReader, ScrollView, NavigationLink, and more.

 - Moonshot: Introduction
 - Resizing images to fit the screen using GeometryReader
 - How ScrollView lets us work with scrolling data
 - Pushing new views onto the stack using NavigationLink
 - Working with hierarchical Codable data
 - How to lay out views in a scrolling grid
 
 Don’t forget to post your progress somewhere – stay accountable! (And when you’re done, sit down and watch some For All Mankind.)
 */

/* Moonshot: Introduction
 In this project we’re going to build an app that lets users learn about the missions and astronauts that formed NASA’s Apollo space program. You’ll get more experience with Codable, but more importantly you’ll also work with scroll views, navigation, and much more interesting layouts.

 Yes, you’ll get some practice time with List, Text, and more, but you’ll also start to solve important SwiftUI problems – how can you make an image fit its space correctly? How can we clean up code using computed properties? How can we compose smaller views into larger ones to help keep our project organized?

 As always there’s lots to do, so let’s get started: create a new iOS app using the App template, naming it “Moonshot”. We’ll be using that for the project, but first lets take a closer look at the new techniques you’ll need to become familiar with…
 */

/* Resizing images to fit the screen using GeometryReader
 When we create an Image view in SwiftUI, it will automatically size itself according to the dimensions of its contents. So, if the picture is 1000x500, the Image view will also be 1000x500. This is sometimes what you want, but mostly you’ll want to show the image at a lower size, and I want to show you how that can be done, but also how we can make an image fit some amount of the user’s screen width using a new view type called GeometryReader.

 First, add some sort of image to your project. It doesn’t matter what it is, as long as it’s wider than the screen. I called mine “Example”, but obviously you should substitute your image name in the code below.

 Now let’s draw that image on the screen:

 struct ContentView: View {
     var body: some View {
         Image("Example")
     }
 }
 Even in the preview you can see that’s way too big for the available space. Images have the same frame() modifier as other views, so you might try to scale it down like this:

 Image("Example")
     .frame(width: 300, height: 300)
 However, that won’t work – your image will still appear to be its full size. If you want to know why, take a close look at the preview window: you’ll see your image is full size, but there’s now a box that’s 300x300, sat in the middle. The image view’s frame has been set correctly, but the content of the image is still shown as its original size.

 Try changing the image to this:

 Image("Example")
     .frame(width: 300, height: 300)
     .clipped()
 Now you’ll see things more clearly: our image view is indeed 300x300, but that’s not really what we wanted.

 If you want the image contents to be resized too, we need to use the resizable() modifier like this:

 Image("Example")
     .resizable()
     .frame(width: 300, height: 300)
 That’s better, but only just. Yes, the image is now being resized correctly, but it’s probably looking squashed. My image was not square, so it looks distorted now that it’s been resized into a square shape.

 To fix this we need to ask the image to resize itself proportionally, which can be done using the scaledToFit() and scaledToFill() modifiers. The first of these means the entire image will fit inside the container even if that means leaving some parts of the view empty, and the second means the view will have no empty parts even if that means some of our image lies outside the container.

 Try them both to see the difference for yourself. Here is .fit mode applied:

 Image("Example")
     .resizable()
     .scaledToFit()
     .frame(width: 300, height: 300)
 And here is scaledToFill():

 Image("Example")
     .resizable()
     .scaledToFill()
     .frame(width: 300, height: 300)
 All this works great if we want fixed-sized images, but very often you want images that automatically scale up to fill more of the screen in one or both dimensions. That is, rather than hard-coding a width of 300, what you really want to say is “make this image fill 80% of the width of the screen.”

 SwiftUI gives us a dedicated type for this called GeometryReader, and it’s remarkably powerful. Yes, I know lots of SwiftUI is powerful, but honestly: what you can do with GeometryReader will blow you away.

 We’ll go into much more detail on GeometryReader in project 15, but for now we’re going to use it for one job: to make sure our image fills the full width of its container view.

 GeometryReader is a view just like the others we’ve used, except when we create it we’ll be handed a GeometryProxy object to use. This lets us query the environment: how big is the container? What position is our view? Are there any safe area insets? And so on.

 In principle that seems simple enough, but in practice you need to use GeometryReader carefully because it automatically expands to take up available space in your layout, then positions its own content aligned to the top-left corner.

 For example, we could make an image that’s 80% the width of the screen, with a fixed height of 300:

 GeometryReader { geo in
     Image("Example")
         .resizable()
         .scaledToFit()
         .frame(width: geo.size.width * 0.8, height: 300)
 }
 You can even remove the height from the image, like this:

 GeometryReader { geo in
     Image("Example")
         .resizable()
         .scaledToFit()
         .frame(width: geo.size.width * 0.8)
 }
 We’ve given SwiftUI enough information that it can automatically figure out the height: it knows the original width, it knows our target width, and it knows our content mode, so it understands how the target height of the image will be proportional to the target width.

 Tip: If you ever want to center a view inside a GeometryReader, rather than aligning to the top-left corner, add a second frame that makes it fill the full space of the container, like this:

 GeometryReader { geo in
     Image("Example")
         .resizable()
         .scaledToFit()
         .frame(width: geo.size.width * 0.8)
         .frame(width: geo.size.width, height: geo.size.height)
 }
 */

/* How ScrollView lets us work with scrolling data
 You’ve seen how List and Form let us create scrolling tables of data, but for times when we want to scroll arbitrary data – i.e., just some views we’ve created by hand – we need to turn to SwiftUI’s ScrollView.

 Scroll views can scroll horizontally, vertically, or in both directions, and you can also control whether the system should show scroll indicators next to them – those are the little scroll bars that appear to give users a sense of how big the content is. When we place views inside scroll views, they automatically figure out the size of that content so users can scroll from one edge to the other.

 As an example, we could create a scrolling list of 100 text views like this:

 ScrollView {
     VStack(spacing: 10) {
         ForEach(0..<100) {
             Text("Item \($0)")
                 .font(.title)
         }
     }
 }
 If you run that back in the simulator you’ll see that you can drag the scroll view around freely, and if you scroll to the bottom you’ll also see that ScrollView treats the safe area just like List and Form – their content goes under the home indicator, but they add some extra padding so the final views are fully visible.

 You might also notice that it’s a bit annoying having to tap directly in the center – it’s more common to have the whole area scrollable. To get that behavior, we should make the VStack take up more space while leaving the default centre alignment intact, like this:

 ScrollView {
     VStack(spacing: 10) {
         ForEach(0..<100) {
             Text("Item \($0)")
                 .font(.title)
         }
     }
     .frame(maxWidth: .infinity)
 }
 Now you can tap and drag anywhere on the screen, which is much more user-friendly.

 This all seems really straightforward, however there’s an important catch that you need to be aware of: when we add views to a scroll view they get created immediately. To demonstrate this, we can create a simple wrapper around a regular text view, like this:

 struct CustomText: View {
     let text: String

     var body: some View {
         Text(text)
     }

     init(_ text: String) {
         print("Creating a new CustomText")
         self.text = text
     }
 }
 Now we can use that inside our ForEach:

 ForEach(0..<100) {
     CustomText("Item \($0)")
         .font(.title)
 }
 The result will look identical, but now when you run the app you’ll see “Creating a new CustomText” printed a hundred times in Xcode’s log – SwiftUI won’t wait until you scroll down to see them, it will just create them immediately.

 If you want to avoid this happening, there’s an alternative for both VStack and HStack called LazyVStack and LazyHStack respectively. These can be used in exactly the same way as regular stacks but will load their content on-demand – they won’t create views until they are actually shown, and so minimize the amount of system resources being used.

 So, in this situation we could swap our VStack for a LazyVStack like this:

 LazyVStack(spacing: 10) {
     ForEach(0..<100) {
         CustomText("Item \($0)")
             .font(.title)
     }
 }
 .frame(maxWidth: .infinity)
 Literally all it takes is to add “Lazy” before “VStack” to have our code run more efficiently – it will now only create the CustomText structs when they are actually needed.

 Although the code to use regular and lazy stacks is the same, there is one important layout difference: lazy stacks always take up as much as room as is available in our layouts, whereas regular stacks take up only as much space as is needed. This is intentional, because it stops lazy stacks having to adjust their size if a new view is loaded that wants more space.

 One last thing: you can make horizontal scrollviews by passing .horizontal as a parameter when you make your ScrollView. Once that’s done, make sure you create a horizontal stack or lazy stack, so your content is laid out as you expect:

 ScrollView(.horizontal) {
     LazyHStack(spacing: 10) {
         ForEach(0..<100) {
             CustomText("Item \($0)")
                 .font(.title)
         }
     }
 }
 */

/* Pushing new views onto the stack using NavigationLink
 SwiftUI’s NavigationView shows a navigation bar at the top of our views, but also does something else: it lets us push views onto a view stack. In fact, this is really the most fundamental form of iOS navigation – you can see it in Settings when you tap Wi-Fi or General, or in Messages whenever you tap someone’s name.

 This view stack system is very different from the sheets we’ve used previously. Yes, both show some sort of new view, but there’s a difference in the way they are presented that affects the way users think about them.

 Let’s start by looking at some code so you can see for yourself. If we wrap the default text view with a navigation view and give it a title, we get this:

 struct ContentView: View {
     var body: some View {
         NavigationView {
             Text("Hello, world!")
                 .padding()
             .navigationTitle("SwiftUI")
         }
     }
 }
 That text view is just static text; it’s not a button with any sort of action attached to it. We’re going to make it so that when the user taps on “Hello, world!” we present them with a new view, and that’s done using NavigationLink: give this a destination and something that can be tapped, and it will take care of the rest.

 One of the many things I love about SwiftUI is that we can use NavigationLink with any kind of destination view. Yes, we can design a custom view to push to, but we can also push straight to some text.

 To try this out, change your view to this:

 NavigationView {
     NavigationLink {
         Text("Detail View")
     } label: {
         Text("Hello, world!")
             .padding()
     }
     .navigationTitle("SwiftUI")
 }
 Now run the code and see what you think. You will see that “Hello, world!” now looks like a button, and tapping it makes a new view slide in from the right saying “Detail View”. Even better, you’ll see that the “SwiftUI” title animates down to become a back button, and you can tap that or swipe from the left edge to go back.

 So, both sheet() and NavigationLink allow us to show a new view from the current one, but the way they do it is different and you should choose them carefully:

 NavigationLink is for showing details about the user’s selection, like you’re digging deeper into a topic.
 sheet() is for showing unrelated content, such as settings or a compose window.
 The most common place you see NavigationLink is with a list, and there SwiftUI does something quite marvelous.

 Try modifying your code to this:

 NavigationView {
     List(0..<100) { row in
         NavigationLink {
             Text("Detail \(row)")
         } label: {
             Text("Row \(row)")
         }
     }
     .navigationTitle("SwiftUI")
 }
 When you run the app now you’ll see 100 list rows that can be tapped to show a detail view, but you’ll also see gray disclosure indicators on the right edge. This is the standard iOS way of telling users another screen is going to slide in from the right when the row is tapped, and SwiftUI is smart enough to add it automatically here. If those rows weren’t navigation links – if you comment out the NavigationLink line and its closing brace – you’ll see the indicators disappear.
 */

/* Working with hierarchical Codable data
 The Codable protocol makes it trivial to decode flat data: if you’re decoding a single instance of a type, or an array or dictionary of those instances, then things Just Work. However, in this project we’re going to be decoding slightly more complex JSON: there will be an array inside another array, using different data types.

 If you want to decode this kind of hierarchical data, the key is to create separate types for each level you have. As long as the data matches the hierarchy you’ve asked for, Codable is capable of decoding everything with no further work from us.

 To demonstrate this, put this button in to your content view:

 Button("Decode JSON") {
     let input = """
     {
         "name": "Taylor Swift",
         "address": {
             "street": "555, Taylor Swift Avenue",
             "city": "Nashville"
         }
     }
     """

     // more code to come
 }
 That creates a string of JSON in code. In case you aren’t too familiar with JSON, it’s probably best to look at the Swift structs that match it – you can put these directly into the button action or outside of the ContentView struct, it doesn’t matter:

 struct User: Codable {
     let name: String
     let address: Address
 }

 struct Address: Codable {
     let street: String
     let city: String
 }
 Hopefully you can now see what the JSON contains: a user has a name string and an address, and addresses are a street string and a city string.

 Now for the best part: we can convert our JSON string to the Data type (which is what Codable works with), then decode that into a User instance:

 let data = Data(input.utf8)
 let decoder = JSONDecoder()
 if let user = try? decoder.decode(User.self, from: data) {
     print(user.address.street)
 }
 If you run that program and tap the button you should see the address printed out – although just for the avoidance of doubt I should say that it’s not her actual address!

 There’s no limit to the number of levels Codable will go through – all that matters is that the structs you define match your JSON string.
 */

/* How to lay out views in a scrolling grid
 SwiftUI’s List view is a great way to show scrolling rows of data, but sometimes you also want columns of data – a grid of information, that is able to adapt to show more data on larger screens.

 In SwiftUI this is accomplished with two views: LazyHGrid for showing horizontal data, and LazyVGrid for showing vertical data. Just like with lazy stacks, the “lazy” part of the name is there because SwiftUI will automatically delay loading the views it contains until the moment they are needed, meaning that we can display more data without chewing through a lot of system resources.

 Creating a grid is done in two steps. First, we need to define the rows or columns we want – we only define one of the two, depending on which kind of grid we want.

 For example, if we have a vertically scrolling grid then we might say we want our data laid out in three columns exactly 80 points wide by adding this property to our view:

 let layout = [
     GridItem(.fixed(80)),
     GridItem(.fixed(80)),
     GridItem(.fixed(80))
 ]
 Once you have your lay out defined, you should place your grid inside a ScrollView, along with as many items as you want. Each item you create inside the grid is automatically assigned a column in the same way that rows inside a list automatically get placed inside their parent.

 For example, we could render 1000 items inside our three-column grid like this:

 ScrollView {
     LazyVGrid(columns: layout) {
         ForEach(0..<1000) {
             Text("Item \($0)")
         }
     }
 }
 That works for some situations, but the best part of grids is their ability to work across a variety of screen sizes. This can be done with a different column layout using adaptive sizes, like this:

 let layout = [
     GridItem(.adaptive(minimum: 80)),
 ]
 That tells SwiftUI we’re happy to fit in as many columns as possible, as long as they are at least 80 points in width. You can also specify a maximum range for even more control:

 let layout = [
     GridItem(.adaptive(minimum: 80, maximum: 120)),
 ]
 I tend to rely on these adaptive layouts the most, because they allow grids that make maximum use of available screen space.

 Before we’re done, I want to briefly show you how to make horizontal grids. The process is almost identical, you just need to make your ScrollView work horizontally, then create a LazyHGrid using rows rather than columns:

 ScrollView(.horizontal) {
     LazyHGrid(rows: layout) {
         ForEach(0..<1000) {
             Text("Item \($0)")
         }
     }
 }
 That brings us to the end of the overview for this project, so please go ahead and reset ContentView.swift to its original state.
 */
