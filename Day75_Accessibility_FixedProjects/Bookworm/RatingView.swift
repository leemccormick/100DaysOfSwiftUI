//
//  RatingView.swift
//  Day75_Accessibility_FixedProjects
//
//  Created by Lee McCormick on 6/6/22.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    var label = ""
    var maximumRating = 5
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                image(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                    }
                /*
                 This initial approach works well enough, and it’s certainly the easiest to take because it builds on all the skills you’ve used elsewhere. However, there’s a second approach that I want to look at, because I think it yields a far more useful result – it works more efficiently for folks relying on VoiceOver and other tools.
                 */
                    .accessibilityElement()
                    .accessibilityLabel(label)
                    .accessibilityLabel(rating == 1 ? "1 star" : "\(rating) stars")
                    .accessibilityAdjustableAction { direction in
                        switch direction {
                        case .increment:
                            if rating < maximumRating { rating += 1 }
                        case .decrement:
                            if rating > 1 { rating -= 1 }
                        default:
                            break
                        }
                    }
                /*
                 .accessibilityLabel("\(number == 1 ? "1 star" : "\(number) stars")") // Our initial approach will use three modifiers, each added below the current tapGesture() modifier inside RatingView. First, we need to add one that provides a meaningful label for each star, like this:
                 .accessibilityRemoveTraits(.isImage) // Second, we can remove the .isImage trait, because it really doesn’t matter that these are images:
                 .accessibilityAddTraits(number > rating ? .isButton: [.isButton, .isSelected]) // And finally, we should tell the system that each star is actually a button, so users know it can be tapped. While we’re here, we can make VoiceOver do an even better job by adding a second trait, .isSelected, if the star is already highlighted.
                 */
            }
        }
    }
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(4))
    }
}
