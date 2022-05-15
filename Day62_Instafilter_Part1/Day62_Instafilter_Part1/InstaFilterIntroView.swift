//
//  InstaFilterIntroView.swift
//  Day62_Instafilter_Part1
//
//  Created by Lee McCormick on 5/14/22.
//

import SwiftUI

struct InstaFilterIntroView: View {
    let info =
    """
In this project we’re going to build an app that lets the user import photos from their library, then modify them using various image effects. We’ll cover a number of new techniques, but at the center of it all are one useful app development skill – using Apple’s Core Image framework – and one important SwiftUI skill – integrating with UIKit. There are other things too, but those two are the big takeaways.

Core Image is Apple’s high-performance framework for manipulating images, and it’s extraordinarily powerful. Apple has designed dozens of example image filters for us, providing things like blurs, color shifts, pixellation, and more, and all are optimized to take full advantage of the graphics processing unit (GPU) on iOS devices.

Tip: Although you can run your Core Image app in the simulator, don’t be surprised if most things are really slow – you’ll only get great performance when you run on a physical device.

As for integrating with UIKit, you might wonder why this is needed – after all, SwiftUI is designed to replace UIKit, right? Well, sort of. Before SwiftUI launched, almost every iOS app was built with UIKit, which means that there are probably several billion lines of UIKit code out there. So, if you want to integrate SwiftUI into an existing project you’ll need to learn how to make the two work well together.

But there’s another reason, and I’m hoping it won’t always be a reason: many parts of Apple’s frameworks don’t have SwiftUI wrappers yet, which means if you want to integrate MapKit, Safari, or other important APIs, you need to know how to wrap their code for use with SwiftUI. I’ll be honest, the code required to make this work isn’t pretty, but at this point in your SwiftUI career you’re more than ready for it.

As always we have some techniques to cover before we get into the project, so please create a new iOS app using the App template, naming it “Instafilter”.
"""
    var body: some View {
        ScrollView {
            Text(info)
        }
        .navigationBarTitle("Instafilter: Introduction")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InstaFilterIntroView_Previews: PreviewProvider {
    static var previews: some View {
        InstaFilterIntroView()
    }
}
