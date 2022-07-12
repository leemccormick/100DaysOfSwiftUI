//
//  IntroView.swift
//  Day92_Geometry_Part1
//
//  Created by Lee McCormick on 7/12/22.
//

import SwiftUI

struct IntroView: View {
    let topic = "Layout and geometry: Introduction"
    let info =
    """
    In this technique project we’re going to explore how SwiftUI handles layout. Some of these things have been explained a little already, some of them you might have figured out yourself, but many more are things you might just have taken for granted to this point, so I hope a detailed exploration will really shed some light on how SwiftUI works.
    
    Along the way you’ll also learn about creating more advanced layout alignments, building special effects using GeometryReader, and more – some real power features that I know you’ll be keen to deploy in your own apps.
    
    Go ahead and create a new iOS project using the App template, naming it LayoutAndGeometry. You’ll need an image in your asset catalog in order to follow the chapter on custom alignment guides, but it can be anything you want – it’s just a placeholder really.
    """
    
    var body: some View {
        VStack {
            Text(topic)
                .font(.largeTitle)
                .padding()
            Text(info)
                .font(.body)
                .padding()
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
