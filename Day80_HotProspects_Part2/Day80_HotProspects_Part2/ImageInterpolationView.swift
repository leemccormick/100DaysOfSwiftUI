//
//  ImageInterpolationView.swift
//  Day80_HotProspects_Part2
//
//  Created by Lee McCormick on 6/28/22.
//

import SwiftUI

struct ImageInterpolationView: View {
    let info =
    """
     What happens if you make a SwiftUI Image view that stretches its content to be larger than its original size? By default, we get image interpolation, which is where iOS blends the pixels so smoothly you might not even realize they have been stretched at all. There’s a performance cost to this of course, but most of the time it’s not worth worrying about.
    
     However, there is one place where image interpolation causes a problem, and that’s when you’re dealing with precise pixels. As an example, the files for this project on GitHub contain a little cartoon alien image called example@3x.png – it’s taken from the Kenney Platform Art Deluxe bundle at https://kenney.nl/assets/platformer-art-deluxe and is available under the public domain.
    
     Go ahead and add that graphic to your asset catalog, then change your ContentView struct to this:
    
     Image("example")
         .resizable()
         .scaledToFit()
         .frame(maxHeight: .infinity)
         .background(.black)
         .ignoresSafeArea()
     That renders the alien character against a black background to make it easier to see, and because it’s resizable SwiftUI will stretch it up to fill all available space.
    
     Take a close look at the edges of the colors: they look jagged, but also blurry. The jagged part comes from the original image because it’s only 66x92 pixels in size, but the blurry part is where SwiftUI is trying to blend the pixels as they are stretched to make the stretching less obvious.
    
     Often this blending works great, but it struggles here because the source picture is small (and therefore needs a lot of blending to be shown at the size we want), and also because the image has lots of solid colors so the blended pixels stand out quite obviously.
    
     For situations just like this one, SwiftUI gives us the interpolation() modifier that lets us control how pixel blending is applied. There are multiple levels to this, but realistically we only care about one: .none. This turns off image interpolation entirely, so rather than blending pixels they just get scaled up with sharp edges.
    
     So, modify your image to this:
    
     Image("example")
         .interpolation(.none)
         .resizable()
         .scaledToFit()
         .frame(maxHeight: .infinity)
         .background(.black)
         .ignoresSafeArea()
     Now you’ll see the alien character retains its pixellated look, which not only is particularly popular in retro games but is also important for line art that would look wrong when blurred.
    """
    var body: some View {
        ScrollView {
            Image("example")
                .interpolation(.none) // For situations just like this one, SwiftUI gives us the interpolation() modifier that lets us control how pixel blending is applied. There are multiple levels to this, but realistically we only care about one: .none. This turns off image interpolation entirely, so rather than blending pixels they just get scaled up with sharp edges.
                .resizable()
                .scaledToFit()
                .frame(maxHeight: .infinity)
                .background(.black)
                .ignoresSafeArea()
            Text(info)
                .padding()
        }
        .navigationTitle("Controlling image interpolation in SwiftUI")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ImageInterpolationView_Previews: PreviewProvider {
    static var previews: some View {
        ImageInterpolationView()
    }
}
