//
//  IntroView.swift
//  Day74_Accessibility_Intro
//
//  Created by Lee McCormick on 6/1/22.
//

import SwiftUI

struct IntroView: View {
    let info = """
 Making your app accessible means taking steps to ensure that everyone can use it fully regardless of their individual needs. For example, if they are blind then your app should work well with the system’s VoiceOver system to ensure your UI can be read smoothly.

 SwiftUI gives us a huge amount of functionality for free, because its layout system of VStack and HStack naturally forms a flow of views. However, it isn’t perfect, and any time you can add some extra information to help out the iOS accessibility system it’s likely to help.

 Usually the best way to test out your app is to enable VoiceOver support and run the app on a real device – if your app works great with VoiceOver, there’s a good chance you’re already far ahead of the average for iOS apps.

 Anyway, in this technique project we’re going to look at a handful of accessibility techniques, then look at some of the previous projects we made to see how they might get upgraded.

 For now, please create a new iOS app using the App template. You should run this project on a real device, so you can enable VoiceOver for real.

 Acknowledgements: I’m grateful for the help of Robin Kipp in preparing this chapter – he wrote in with some detailed suggestions for things he’d like to see with regards to accessibility, giving me some great examples of how it would affect his own personal use.
"""
    var body: some View {
        ScrollView {
            Text(info)
                .padding()
        }
        .navigationTitle("Accessibility Introduction")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
