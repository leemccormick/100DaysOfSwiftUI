//
//  SwitfUIViewStructs.swift
//  Day76_Accessibility_WrapUp
//
//  Created by Lee McCormick on 6/9/22.
//

import SwiftUI

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
