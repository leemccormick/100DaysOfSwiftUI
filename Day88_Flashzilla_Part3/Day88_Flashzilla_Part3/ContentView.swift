//
//  ContentView.swift
//  Day88_Flashzilla_Part3
//
//  Created by Lee McCormick on 7/10/22.
//

import SwiftUI

/*
 In this case we’re going to create a new stacked() modifier that takes a position in an array along with the total size of the array, and offsets a view by some amount based on those values. This will allow us to create an attractive card stack where each card is a little further down the screen than the ones before it.
 */
extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView: View {
    @State private var cards = Array<Card>(repeating: Card.example, count: 10) // Right now we don’t have any way of adding cards, so we’re going to add a stack of 10 using our example card. Swift’s arrays have a helpful initializer, init(repeating:count:), which takes one value and repeats it a number of times to create the array. In our case we can use that with our example Card to create a simple test array.
    
    var body: some View {
        // CardView(card: Card.example)
        /*
         Our main ContentView is going to contain a number of overlapping elements inside stacks, but for now we’re just going to put in a rough skeleton:
         1) Our stack of cards will be placed inside a ZStack so we can make them partially overlap with a neat 3D effect.
         2) Around that ZStack will be a VStack. Right now that VStack won’t do much, but later on it will allow us to place a timer above our cards.
         3) Around that VStack will be another ZStack, so we can place our cards and timer on top of a background.
         
         */
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            VStack {
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        //  // Finally, we can update the way we create CardView so that we use trailing closure syntax to remove the card when it’s dragged more than 100 points. This is just a matter of calling the removeCard(at:) method we just wrote, but if we wrap that inside a withAnimation() call then the other cards will automatically slide up.
                        CardView(card: cards[index]) {
                            withAnimation {
                                removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: cards.count)
                    }
                }
            }
        }
    }
    
    // First, add this method that takes an index in our cards array and removes that item:
    func removeCard(at index: Int) {
        cards.remove(at: index)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

