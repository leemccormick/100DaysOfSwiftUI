//
//  IntroView.swift
//  Day86_Flashzilla_Intro
//
//  Created by Lee McCormick on 7/8/22.
//

import SwiftUI

struct IntroView: View {
    let info = """
    In this project we’re going to build an app that helps users learn things using flashcards – cards with one thing written on such as “to buy”, and another thing written on the other side, such as “comprar”. Of course, this is a digital app so we don’t need to worry about “the other side”, and can instead just make the detail for the flash card appear when it’s tapped.
    
    The name for this project is actually the name of my first ever app for iOS – an app I shipped so long ago it was written for iPhoneOS because the iPad hadn’t been announced yet. Apple actually rejected the app during app review because it had “Flash” in its product name, and at the time Apple were really keen to have Flash nowhere near their App Store! How times have changed…
    
    Anyway, we have lots of interesting things to learn in this project, including gestures, haptics, timers, and more, so please create a new iOS project using the App template, naming it Flashzilla. As always we have some techniques to cover before we get into building the real thing, so let’s get started…
    """
    
    var body: some View {
        NavigationView {
            Form {
                Text(info)
                    .font(.body)
            }
            .navigationTitle("Flashzilla: Introduction")
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
