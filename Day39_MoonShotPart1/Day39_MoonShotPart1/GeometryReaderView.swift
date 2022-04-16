//
//  GeometryReaderView.swift
//  Day39_MoonShotPart1
//
//  Created by Lee McCormick on 4/8/22.
//

import SwiftUI

struct GeometryReaderView: View {
    var body: some View {
        VStack {
            Text("Resizing images to fit the screen using GeometryReader")
                .font(.headline)
                .bold()
            Image("ExampleImage")
                .resizable() //If you want the image contents to be resized too, we need to use the resizable() modifier like this:
            // .scaledToFit()
                .scaledToFill()
                .frame(width: 300, height: 300, alignment: .center)
            // .clipped() // our image view is indeed 300x300, but that’s not really what we wanted.
            
            // In principle that seems simple enough, but in practice you need to use GeometryReader carefully because it automatically expands to take up available space in your layout, then positions its own content aligned to the top-left corner.
            GeometryReader { geo in
                Image("ExampleImage")
                    .resizable()
                    .scaledToFit()
                //.frame(width: geo.size.width * 0.8, height: geo.size.width * 0.8)
                    .frame(width: geo.size.width * 0.8)
                    .frame(width: geo.size.width, height: geo.size.height) // Tip: If you ever want to center a view inside a GeometryReader, rather than aligning to the top-left corner, add a second frame that makes it fill the full space of the container, like this:
            }
        }
    }
}

struct GeometryReaderView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReaderView()
    }
}
