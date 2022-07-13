//
//  Day94_Geometry_WrapUpApp.swift
//  Day94_Geometry_WrapUp
//
//  Created by Lee McCormick on 7/12/22.
//

import SwiftUI

@main
struct Day94_Geometry_WrapUpApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 18, part 3 --> https://www.hackingwithswift.com/100/swiftui/94
 Are you ready to wrap up our final technique project? I hope so, because you’ve got another review to complete, plus three fresh challenges to take on. I’ll warn you now: the challenges all involve GeometryReader, because it will force you to think clearly about the way frames for each view are calculated, and how they can be used to create interesting effects.

 I realize GeometryReader can really make your head spin, but the only way you’re going to learn to be comfortable with – to use it effectively is to practice, practice, and practice some more.

 I’ve quoted Amy Morin before, but I want to do it one last time today. She said, “the greatest things in life tend to happen outside our comfort zones, and doubting your ability to step outside of your comfort zone will keep you stuck.” So, make today the day you step out of your comfort zone and make GeometryReader dance to your tune!

 Today you should work through the wrap up chapter for project 18, complete its review, then work through all three of its challenges.

 - Layout and geometry: Wrap up
 - Review for Project 18: Layout and geometry
 */


/* Layout and geometry: Wrap up
 I hope this smaller technique project proved a welcome break after our long app projects, but I hope even more that you’re really starting to have a good mental model of how SwiftUI’s layout system works. That three step layout system might sound simple, but it takes time to fully understand the ramifications it has.

 As for GeometryReader, it’s one of those things you can get by perfectly fine without even thinking about, and that’s fine. But when you want to add a little pizazz to your designs – when you want to really bring something to life as the user interacts with it – GeometryReader is a fast and flexible fix that offers a huge amount of power in only a handful of lines of code.

 *** Review what you learned  ***
 Anyone can sit through a tutorial, but it takes actual work to remember what was taught. It’s my job to make sure you take as much from these tutorials as possible, so I’ve prepared a short review to help you check your learning.

 *** Challenge  ***
 One of the best ways to learn is to write your own code as often as possible, so here are three challenges for you to complete to experiment with your knowledge of GeometryReader.

 First, put your ContentView back to the spinning color rows example we had:

 struct ContentView: View {
     let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]

     var body: some View {
         GeometryReader { fullView in
             ScrollView(.vertical) {
                 ForEach(0..<50) { index in
                     GeometryReader { geo in
                         Text("Row #\(index)")
                             .font(.title)
                             .frame(maxWidth: .infinity)
                             .background(colors[index % 7])
                             .rotation3DEffect(.degrees(geo.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x: 0, y: 1, z: 0))
                     }
                     .frame(height: 40)
                 }
             }
         }
     }
 }
 
 With that done:

 1) Make views near the top of the scroll view fade out to 0 opacity – I would suggest starting at about 200 points from the top.
 2) Make views adjust their scale depending on their vertical position, with views near the bottom being large and views near the top being small. I would suggest going no smaller than 50% of the regular size.
 3) For a real challenge make the views change color as you scroll. For the best effect, you should create colors using the Color(hue:saturation:brightness:) initializer, feeding in varying values for the hue.
 
 Each of those will require a little trial and error from you to find values that work well. Regardless, you should use max() to handle the scaling so that views don’t go smaller than half their size, and use min() with the hue so that hue values don’t go beyond 1.0.
 */
