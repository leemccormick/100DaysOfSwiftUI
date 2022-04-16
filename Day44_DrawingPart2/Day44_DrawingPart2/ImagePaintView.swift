//
//  ImagePaintView.swift
//  Day44_DrawingPart2
//
//  Created by Lee McCormick on 4/14/22.
//

import SwiftUI

struct ImagePaintView: View {
    var body: some View {
        ScrollView {
            Text("Creative borders and fills using ImagePaint")
                .font(.title.bold())
                .padding()
            Text("Hello Example Image background")
                .background(Image("ExampleImage"))
                .frame(width: 300, height: 100)
            HStack {
            Text("Hello background")
                .frame(width: 100, height: 100)
                .background(.red)
            Text("Hello Border")
                .frame(width: 100, height: 100)
                .border(.red, width: 10)
            }
            /* Text("Hello Example Image border")
             .frame(width: 300, height: 100)
             .border(Image("ExampleImage"), width: 30) */
            Text("Hello ImagePaint Border")
                .frame(width: 300, height: 100)
                .border(ImagePaint(image: Image("ExampleImage"), sourceRect: CGRect(x: 0, y: 0.25, width: 1, height: 0.5), scale: 0.1), width: 30)
            
            Capsule()
                .strokeBorder(ImagePaint(image: Image("ExampleImage"), scale: 0.1), lineWidth: 20)
                .frame(width: 300, height: 200)
        }
    }
}

struct ImagePaintView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePaintView()
    }
}
