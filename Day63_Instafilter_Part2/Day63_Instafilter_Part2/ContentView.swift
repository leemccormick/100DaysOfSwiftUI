//
//  ContentView.swift
//  Day63_Instafilter_Part2
//
//  Created by Lee McCormick on 5/14/22.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            Form {
                NavigationLink {
                    CoreImageView()
                } label: {
                     Text("Integrating Core Image with SwiftUI")
                }
                NavigationLink {
                    WrapUIViewControllerView()
                } label: {
                     Text("Wrapping a UIViewController in a SwiftUI view")
                }
            }
            .navigationTitle("Day63 : InstarFilter Part2")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*
 Apart from SwiftUI’s Image view, the three other image types are:
 
 1) UIImage, which comes from UIKit. This is an extremely powerful image type capable of working with a variety of image types, including bitmaps (like PNG), vectors (like SVG), and even sequences that form an animation. UIImage is the standard image type for UIKit, and of the three it’s closest to SwiftUI’s Image type.
 2) CGImage, which comes from Core Graphics. This is a simpler image type that is really just a two-dimensional array of pixels.
 3) CIImage, which comes from Core Image. This stores all the information required to produce an image but doesn’t actually turn that into pixels unless it’s asked to. Apple calls CIImage “an image recipe” rather than an actual image.
 There is some interoperability between the various image types:
 
 - We can create a UIImage from a CGImage, and create a CGImage from a UIImage.
 - We can create a CIImage from a UIImage and from a CGImage, and can create a CGImage from a CIImage.
 - We can create a SwiftUI Image from both a UIImage and a CGImage.
 
 */
