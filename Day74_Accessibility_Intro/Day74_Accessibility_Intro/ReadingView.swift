//
//  ReadingView.swift
//  Day74_Accessibility_Intro
//
//  Created by Lee McCormick on 6/1/22.
//

import SwiftUI

struct ReadingView: View {
    @State private var value = 10
    var body: some View {
        VStack {
            Text("Value : \(value)")
            /*
             That might work just the way you want with tap interactions, but it’s not a great experience with VoiceOver because all users will hear is “Increment” or “Decrement” every time they tap one of the buttons.
             To fix this we can give iOS specific instructions for how to handle adjustment, by grouping our VStack together using accessibilityElement() and accessibilityLabel(), then by adding the accessibilityValue() and accessibilityAdjustableAction() modifiers to respond to swipes with custom code.
             
             Adjustable actions hand us the direction the user swiped, and we can respond however we want. There is one proviso: yes, we can choose between increment and decrement swipes, but we also need a special default case to handle unknown future values – Apple has reserved the right to add other kinds of adjustments in the future.
             */
            Button("Increment") {
                value += 1
            }
            
            Button("Decrement") {
                value -= 1
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Value")
        .accessibilityValue(String(value)) // By default SwiftUI provides VoiceOver readouts for its user interface controls, and although these are often good sometimes they just don’t fit with what you need. In these situations we can use the accessibilityValue() modifier to separate a control’s value from its label, but we can also specify custom swipe actions using accessibilityAdjustableAction().
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                value += 1
            case .decrement:
                value -= 1
            default:
                print("Not handled")
            }
        }
        .navigationTitle("Reading the value of controls")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ReadingView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingView()
    }
}
