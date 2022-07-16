//
//  WelcomeView.swift
//  Day99_SnowSeeker_WrapUp
//
//  Created by Lee McCormick on 7/15/22.
//

import SwiftUI

// MARK: - WelcomeView
struct WelcomeView: View {
    var body: some View {
        Text("Welcome To SnowSeeker!")
            .font(.largeTitle)
        Text("Please select a resort from the left-hand menu; swipe from the left edge to show it.")
            .foregroundColor(.secondary)
    }
}

// MARK: - PreviewProvider
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
