//
//  RatingView.swift
//  Day54_Bookworm_Part2
//
//  Created by Lee McCormick on 4/24/22.
//

import SwiftUI
/* To demonstrate this, we’re going to build a star rating view that lets the user enter scores between 1 and 5 by tapping images. Although we could just make this view simple enough to work for our exact use case, it’s often better to add some flexibility where appropriate so it can be used elsewhere too. Here, that means we’re going to make six customizable properties:
 
 - What label should be placed before the rating (default: an empty string)
 - The maximum integer rating (default: 5)
 - The off and on images, which dictate the images to use when the star is highlighted or not (default: nil for the off image, and a filled star for the on image; if we find nil in the off image we’ll use the on image there too)
 - The off and on colors, which dictate the colors to use when the star is highlighted or not (default: gray for off, yellow for on)
 */

struct RatingView: View {
    @Binding var rating: Int
    var label = ""
    var maximumRating = 5
    var offImage : Image?
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
