//
//  EmojiRatingView.swift
//  Day54_Bookworm_Part2
//
//  Created by Lee McCormick on 4/24/22.
//

import SwiftUI

/*
 We could just use the same star rating view here that we made earlier, but it’s much more fun to try something else. Whereas the RatingView control can be used in any kind of project, we can make a new EmojiRatingView that displays a rating specific to this project. All it will do is show one of five different emoji depending on the rating, and it’s a great example of how straightforward view composition is in SwiftUI – it’s so easy to just pull out a small part of your views in this way.
 */

struct EmojiRatingView: View {
    let rating: Int16
    var body: some View {
        switch rating {
        case 1:
            return Text("😩")
        case 2:
            return Text("😏")
        case 3:
            return Text("😔")
        case 4:
            return Text("😀")
        default:
            return Text("🤩")
        }
    }
}

struct EmojiRatingView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiRatingView(rating: 3)
    }
}
