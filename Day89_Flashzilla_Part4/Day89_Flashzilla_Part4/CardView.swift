//
//  CardView.swift
//  Day89_Flashzilla_Part4
//
//  Created by Lee McCormick on 7/10/22.
//

import SwiftUI

struct CardView: View {
    let card: Card
    var removal: (() -> Void)? = nil
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var  differentiateWithoutColor // However, as nice as our code is it won’t work well for folks with red/green color blindness – they will see the brightness of the cards change, but it won’t be clear which side is which. To fix this we’re going to add an environment property to track whether we should be using color for this purpose or not, then disable the red/green effect when that property is true.
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    // So, when in a default configuration our cards will fade to green or red, but when Differentiate Without Color is enabled that won’t be used. Instead we need to provide some extra UI in ContentView to make it clear which side is positive and which is negative.
                    differentiateWithoutColor
                    ? .white
                    : .white.opacity(1 - Double(abs(offset.width / 50)))) // As for the white fill opacity, this is going to be similar to the opacity() modifier we added previously except we’ll use 1 minus 1/50th of the gesture width rather than 2 minus the gesture width. This creates a really nice effect: we used 2 minus earlier because it meant the card would have to move at least 50 points before fading away, but for the card fill we’re going to use 1 minus so that it starts becoming colored straight away.
                .background(
                    differentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(offset.width > 0 ? .green : .red)
                )
                .shadow(radius: 10)
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
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .gesture(
            DragGesture()
                .onChanged{ gesture in
                    offset = gesture.translation
                }
                .onEnded{ _ in
                    if abs(offset.width) > 100 {
                        removal?()
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
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
