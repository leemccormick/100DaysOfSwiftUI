//
//  FontView.swift
//  Day92_Geometry_Part1
//
//  Created by Lee McCormick on 7/12/22.
//

import SwiftUI

struct FontView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Example Fonts in Swift UI")
                .font(.largeTitle)
                .padding(20)
            
            Text("LargeTitle | LargeTitle")
                .font(.largeTitle)
                .padding()
            Text("Headline | Headline")
                .font(.headline)
                .padding()
            Text("Subheadline | Subheadline")
                .font(.subheadline)
                .padding()
            VStack {
                Text("Title | Title")
                    .font(.title)
                    .padding()
                Text("Title2 | Title2")
                    .font(.title2)
                    .padding()
                Text("Title3 | Title3")
                    .font(.title3)
                    .padding()
            }
            Text("Body | Body")
                .font(.body)
                .padding()
            Text("Callout | Callout")
                .font(.callout)
                .padding()
            Text("Footnote | Footnote")
                .font(.footnote)
                .padding()
            VStack {
                Text("Caption | Caption")
                    .font(.caption)
                    .padding()
                Text("Caption2 | Caption2")
                    .font(.caption2)
                    .padding()
            }
        }
    }
}

struct FontView_Previews: PreviewProvider {
    static var previews: some View {
        FontView()
    }
}
