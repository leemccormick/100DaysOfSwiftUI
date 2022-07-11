//
//  CardView.swift
//  Day88_Flashzilla_Part3
//
//  Created by Lee McCormick on 7/10/22.
//

import SwiftUI

struct CardView: View {
    let card: Card
    var removal: (() -> Void)? = nil // As you can see, that’s a closure that accepts no parameters and sends nothing back, defaulting to nil so we don’t need to provide it unless it’s explicitly needed.
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.white)
                .shadow(radius: 10) // There’s a simple fix for this: we can add a shadow to the RoundedRectangle so we get a gentle depth effect. This will help us right now by making our white card stand out from the white background, but when we start adding more cards it will look even better because the shadows will add up.
            VStack {
                Text(card.prompt)
                    .font(.largeTitle)
                    .foregroundColor(.black)
                if isShowingAnswer {
                    Text(card.answer)
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250) // Tip: A width of 450 is no accident: the smallest iPhones have a landscape width of 480 points, so this means our card will be fully visible on all devices.
        // Remember: the order in which you apply modifiers matters, and nowhere is this more true than when working with offsets and rotations.
        .rotationEffect(.degrees(Double(offset.width / 5))) // Rotate --> If we rotate then offset, then the offset is applied based on the rotated axis of our view. For example, if we move something 100 pixels to its left then rotate 90 degrees, we’d end up with it being 100 pixels to the left and rotated 90 degrees. But if we rotated 90 degrees then moved it 100 pixels to its left, we’d end up with something rotated 90 degrees and moved 100 pixels directly down, because its concept of “left” got rotated.
        .offset(x: offset.width * 5, y: 0) // Move --> Next we’re going to apply our movement, so the card slides relative to the horizontal drag amount. Again, we’re not going to use the original value of offset.width because it would require the user to drag a long way to get any meaningful results, so instead we’re going to multiply it by 5 so the cards can be swiped away with small gestures.
        
        .opacity(2 - Double(abs(offset.width / 50))) // Fade away --> Now, the calculation for this view takes a little thinking, and I wouldn’t blame you if you wanted to spin this off into a method rather than putting it inline. Here’s how it works: 1) We’re going to take 1/50th of the drag amount, so the card doesn’t fade out too quickly. 2) We don’t care whether they have moved to the left (negative numbers) or to the right (positive numbers), so we’ll put our value through the abs() function. If this is given a positive number it returns the same number, but if it’s given a negative number it removes the negative sign and returns the same value as a positive number. 3) We then use this result to subtract from 2.
        
        .gesture(
            DragGesture() // Both of these functions are handed the current gesture state to evaluate. In our case we’ll be reading the translation property to see where the user has dragged to, and we’ll be using that to set our offset property, but you can also read the start location, predicted end location, and more. When it comes to the ended function, we’ll be checking whether the user moved it more than 100 points in either direction so we can prepare to remove the card, but if they haven’t we’ll set offset back to 0.
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        // remove the card
                        removal?() // Tip: That question mark in there means the closure will only be called if it has been set.
                    } else {
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}
