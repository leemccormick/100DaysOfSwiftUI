//
//  LoadImageView.swift
//  Day49_CupCakeCornerPart1
//
//  Created by Lee McCormick on 4/19/22.
//

import SwiftUI

struct LoadImageView: View {
    var body: some View {
        ScrollView {
            Text("Loading an image from \na remote server")
                .font(.title.bold())
            Text("AsyncImage")
            AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"))
            
            Spacer()
            Text("AsyncImage ==> scale: 3")
            AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"), scale: 3) // If I were to include that 1200px image in my project, I’d actually name it logo@3x.png, then also add an 800px image that was logo@2x.png. SwiftUI would then take care of loading the correct image for us, and making sure it appeared nice and sharp, and at the correct size too. As it is, SwiftUI loads that image as if it were designed to be shown at 1200 pixels high – it will be much bigger than our screen, and will look a bit blurry too. To fix this, we can tell SwiftUI ahead of time that we’re trying to load a 3x scale image, like this:
            Spacer()
            HStack {
                VStack {
                    Text("AsyncImage with {image in }")
                    AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.red // The placeholder view can be whatever you want. For example, if you replace Color.red with ProgressView() – just that – then you’ll get a little spinner activity indicator instead of a solid color.
                    }
                    .frame(width: 150, height: 150, alignment:  .center)
                }
                VStack {
                    // If you want complete control over your remote image, there’s a third way of creating AsyncImage that tells us whether the image was loaded, hit an error, or hasn’t finished yet. This is particularly useful for times when you want to show a dedicated view when the download fails – if the URL doesn’t exist, or the user was offline, etc.
                    Text("AsyncImage with {phase in }")
                    AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                        } else if phase.error != nil {
                            Text("There was an error loading the image.")
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(width: 150, height: 150, alignment: .center)
                }
            }
            /* NOT WORK ==> That won’t work, but perhaps that won’t even surprise you because it wouldn’t work with a regular Image either. So you might try to make it resizable, like this:
             AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"))
             .resizable()
             .frame(width: 200, height: 200)
             */
        }
    }
}

struct LoadImageView_Previews: PreviewProvider {
    static var previews: some View {
        LoadImageView()
    }
}
