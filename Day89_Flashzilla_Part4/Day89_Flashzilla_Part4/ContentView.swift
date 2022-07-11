//
//  ContentView.swift
//  Day89_Flashzilla_Part4
//
//  Created by Lee McCormick on 7/10/22.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @State private var cards = Array<Card>(repeating: Card.example, count: 10)
    
    // For our first pass of the timer, we’re going to create two new properties: the timer itself, which will fire once a second, and a timeRemaining property, from which we’ll subtract 1 every time the timer fires. This will allow us to show how many seconds remain in the current app run, which should give the user a gentle incentive to speed up.
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    /*
     You should be able to run the app now and give it a try – it works well enough, right? Well, there’s a small problem:
     1) Take a look at the current value in the timer.
     2) Press Cmd + Shift + H to go back to the home screen.
     3) Wait about ten seconds.
     4) Now tap your app’s icon to go back to the app.
     5) What time is shown in the timer?
     We can do better than this: we can detect when our app moves to the background or foreground, then pause and restart our timer appropriately.
     */
    
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            VStack {
                // That code starts our timer at 100 and makes it count down to 0, but we need to actually display it. This is as simple as adding another text view to our layout, this time with a dark background color to make sure it’s clearly visible.
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: cards[index]) {
                            withAnimation {
                                removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: cards.count)
                    }
                }
                .allowsHitTesting(timeRemaining > 0) // SwiftUI lets us disable interactivity for a view by setting allowsHitTesting() to false, so in our project we can use it to disable swiping on any card when the time runs out by checking the value of timeRemaining. That enables hit testing when timeRemaining is 1 or greater, but sets it to false otherwise because the user is out of time.
                
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                } // Second, we need a button to trigger that, shown only when all cards have been removed. Put this after the innermost ZStack, just below the allowsHitTesting() modifier:
            }
            // Earlier we made a very particular structure of stacks in ContentView: we had a ZStack, then a VStack, then another ZStack. That first ZStack, the outermost one, allows us to have our background and card stack overlapping, and we’re also going to put some buttons in that stack so users can see which side is “good”.
            if differentiateWithoutColor {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "xmark.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                        Spacer()
                        Image(systemName: "checkmark.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        // Whenever that timer fires, we want to subtract 1 from timeRemaining so that it counts down. We could try and do some date mathematics here by storing a start date and showing the difference between that and the current date, but there really is no need as you’ll see!
        .onReceive(timer) { time in
            if timeRemaining > 0 { // Tip: That adds a trivial condition to make sure we never stray into negative numbers.
                guard isActive else { return } // Finally, modify the onReceive(timer) function so it exits immediately is isActive is false, like this.
                timeRemaining -= 1
            }
        }
        // We have two because the environment value tells us whether the app is active or inactive in terms of its visibility, but we’ll also consider the app inactive is the player has gone through their deck of flashcards – it will be active from a scene phase point of view, but we don’t keep the timer ticking. Now add this onChange() modifier below the existing onReceive() modifier:
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if cards.isEmpty == false { // As for the second problem – making sure isActive stays false when returning from the background – we should just update our scene phase code so it explicitly checks for cards:
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
    }
    
    func removeCard(at index: Int) {
        cards.remove(at: index)
        // Now we have code to restart the timer when resetting the cards, but now we need to stop the timer when the final card is removed – and make sure it stays stopped when coming back to the foreground. We can solve the first problem by adding this to the end of the removeCard(at:) method:
        if cards.isEmpty {
            isActive = false
        }
    }
    
    // The other outcome is that the user flies through all the cards correctly, and ends with none left. When the final card goes away, right now our timer slides down to the center of the screen, and carries on ticking. What we want to happen is for the timer to stop so users can see how fast they were, and also to show a button allowing them to reset their cards and try again.
    func resetCards() {
        cards = Array(repeating: Card.example, count: 10)
        timeRemaining = 100
        isActive = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
