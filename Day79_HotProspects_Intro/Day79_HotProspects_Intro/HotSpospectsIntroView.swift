//
//  HotSpospectsIntroView.swift
//  Day79_HotProspects_Intro
//
//  Created by Lee McCormick on 6/28/22.
//

import SwiftUI

struct HotSpospectsIntroView: View {
    let info =
    """
     In this project we’re going to build Hot Prospects, which is an app to track who you meet at conferences. You’ve probably seen apps like it before: it will show a QR code that stores your attendee information, then others can scan that code to add you to their list of possible leads for later follow up.
    
     That might sound easy enough, but along the way we’re going to cover stacks of really important new techniques: creating tab bars and context menus, sharing custom data using the environment, sending custom change notifications, and more. The resulting app is awesome, but what you learn along the way will be particularly useful!
    
     As always we have lots of techniques to cover before we get into the implementation of our project, so please start by creating a new iOS project using the App template, naming it HotProspects.
    
     Let’s get to it!
    """
    
    var body: some View {
        ScrollView {
            Text(info)
                .font(.body)
                .padding()
        }
        .navigationTitle("Hot Prospects: Introduction")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HotSpospectsIntroView_Previews: PreviewProvider {
    static var previews: some View {
        HotSpospectsIntroView()
    }
}
