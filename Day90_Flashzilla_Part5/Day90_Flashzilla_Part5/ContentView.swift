//
//  ContentView.swift
//  Day90_Flashzilla_Part5
//
//  Created by Lee McCormick on 7/11/22.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled // Finally, we can make those buttons visible when either differentiateWithoutColor is enabled or when VoiceOver is enabled. This means adding another accessibilityVoiceOverEnabled property to ContentView.
    @Environment(\.scenePhase) var scenePhase
    @State private var cards = [Card]() // Array<Card>(repeating: Card.example, count: 10)
    @State private var timeRemaining = 100
    @State private var isActive = true
    @State private var showingEditScreen = false
    
    var body: some View {
        ZStack {
            Image(decorative: "background") // To fix the background image problem we should make it use a decorative image so it won’t be read out as part of the accessibility layout. Modify the background image to this.
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text("Time : \(timeRemaining)")
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
                        .allowsHitTesting(index == cards.count - 1) // First, it’s possible to drag cards around when they aren’t at the top. This is confusing for users because they can grab a card they can’t actually see, so this should never be possible. To fix this we’re going to use allowsHitTesting() so that only the last card – the one on top – can be dragged around.
                        .accessibilityHidden(index < cards.count - 1) // To fix the cards, we need to use an accessibilityHidden() modifier with a similar condition to the allowsHitTesting() modifier we added a minute ago. In this case, every card that’s at an index less than the top card should be hidden from the accessibility system because there’s really nothing useful it can do with the card, so add this directly below the allowsHitTesting() modifier.
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            // Next we need to add a button to flip that Boolean when tapped, so find the if differentiateWithoutColor || accessibilityEnabled condition and put this before it:
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            // Third, we need to make it easier for users to mark cards as correct or wrong, because right now our images just don’t cut it. Not only do they stop users from interacting with our app using tap gestures, but they also get read out as their SF Symbols name – “checkmark, circle, image” – rather than anything useful. To fix this we need to replace the images with buttons that actually remove the cards. We don’t actually do anything different if the user was correct or wrong – I need to leave something for your challenges! – but we can at least remove the top card from the deck. At the same time, we’re going to provide an accessibility label and hint so that users get a better idea of what the buttons do.
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect")
                        Spacer()
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            if timeRemaining > 0 {
                guard isActive else { return }
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        /*
         That’s almost all of EditCards complete, but before we can use it we need to add some more code to ContentView so that it shows the sheet on demand and calls resetCards() when dismissed.
         
         We’ve used sheets previously, but there’s one extra technique I’d like you to show you: you can attach a function to your sheet, that will automatically be run when the sheet is dismissed. This isn’t helpful for times you need to pass back data from the sheet, but here we’re just going to call resetCards() so it’s perfect.
         
         That means “when you want to read the content for the sheet, call the EditCards initializer and it will send you back the view to use.”
         
         Important: This approach only works because EditCards has an initializer that accepts no parameters. If you need to pass in specific values you need to use the closure-based approach instead.
         */
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCardsView.init)
        /* { EditCardsView().init // When we write EditCards(), we’re relying on syntactic sugar – we’re treating our view struct like a function, because Swift silently treats that as a call to the view’s initializer. So, in practice we’re actually writing EditCards.init(), just in a shorter way.
         } */
        .onAppear(perform: resetCards) // Anyway, as well as calling resetCards() when the sheet is dismissed, we also want to call it when the view first appears, so add this modifier below the previous one.
    }
    
    // To finish up with ContentView we need to make it load that cards property on demand. This starts with the same code we just added in EditCard, so put this method into ContentView now:
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return } // Because those buttons remain onscreen even when the last card has been removed, we need to add a guard check to the start of removeCard(at:) to make sure we don’t try to remove a card that doesn’t exist. So, put this new line of code at the start of that method:
        cards.remove(at: index)
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        // cards = Array(repeating: Card.example, count: 10)
        timeRemaining = 100
        isActive = true
        loadData() // And now we can add a call to loadData() in resetCards(), so that we refill the cards property with all saved cards when the app launches or when the user edits their cards:
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
