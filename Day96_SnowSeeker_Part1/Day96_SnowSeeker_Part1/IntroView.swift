//
//  IntroView.swift
//  Day96_SnowSeeker_Part1
//
//  Created by Lee McCormick on 7/15/22.
//

import SwiftUI

struct IntroView: View {
    let topic = "SnowSeeker: Introduction"
    let info =
    """
    In this project we’re going to create SnowSeeker: an app to let users browse ski resorts around the world, to help them find one suitable for their next holiday.

    This will be the first app where we specifically aim to make something that works great on iPad by showing two views side by side, but you’ll also get deep into solving problematic layouts, learn a new way to show sheets and alerts, and more.

    As always we have some techniques to cover before getting into the main project, so please create a new iOS project using the App template, calling it SnowSeeker.

    Let’s go!
    """
    
    // MARK: - Body
    var body: some View {
        VStack {
            Text(topic).font(.largeTitle).padding()
            Text(info).font(.body).padding()
        }
    }
}

// MARK: - PreviewProvider
struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
