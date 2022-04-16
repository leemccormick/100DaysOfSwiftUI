//
//  SwiftUIViewStructs.swift
//  Day42_MoonShotWrapUp
//
//  Created by Lee McCormick on 4/13/22.
//

import SwiftUI

/* Challenge 2 : Extract one or two pieces of view code into their own new SwiftUI views – the horizontal scroll view in MissionView is a great candidate, but if you followed my styling then you could also move the Rectangle dividers out too. */
struct Underline: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundColor(.lightBackground)
            .padding(.vertical)
    }
}

struct TextTitle: View {
    let titleString: String
    var body: some View {
        Text(titleString)
            .font(.title.bold())
            .padding(.bottom, 5)
    }
}

struct TextBody: View {
    let bodyString: String
    var body: some View {
        Text(bodyString)
            .font(.body)
    }
}
