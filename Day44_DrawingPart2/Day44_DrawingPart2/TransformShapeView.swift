//
//  TransformShapeView.swift
//  Day44_DrawingPart2
//
//  Created by Lee McCormick on 4/14/22.
//

import SwiftUI

struct Flower: Shape {
    // How much to move this petal away from the center
    var petalOffset: Double = -20
    
    // How wide to make each petal
    var petalWidth: Double = 100
    
    func path(in rect: CGRect) -> Path {
        // The path that will hold all petals
        var path = Path()
        
        // Count from 0 up to pi * 2, moving up pi / 8 each time
        for number in stride(from: 0, to: Double.pi * 2, by: Double.pi / 8) {
            // rotate the petal by the current value of our loop
            let rotation = CGAffineTransform(rotationAngle: number)
            
            // move the petal to be at the center of our view
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
            
            // create a path for this petal using our properties plus a fixed Y and height
            let originalPetal = Path(ellipseIn: CGRect(x: petalOffset, y: 0, width: petalWidth, height: rect.width / 2))
            
            // apply our rotation/position transformation to the petal
            let rotatedPetal = originalPetal.applying(position)
            
            // add it to our main path
            path.addPath(rotatedPetal)
        }
        
        // now send the main path back
        return path
    }
}

struct TransformShapeView: View {
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0
    
    var body: some View {
        VStack {
            Text("Transforming shapes using CGAffineTransform and even-odd fills")
                .font(.title.bold())
                .padding()
            Flower(petalOffset: petalOffset, petalWidth: petalWidth)
            // .stroke(.red, lineWidth: 1)
            // .fill(.red)// If we fill our path using a solid color, we get a fairly unimpressive result. Try it like this:
                .fill(.red, style: FillStyle(eoFill: true)) //Only the parts that actually overlap are affected by this rule, and it creates some remarkably beautiful results. Even better, Swift UI makes it trivial to use, because whenever we call fill() on a shape we can pass a FillStyle struct that asks for the even-odd rule to be enabled.
            Text("Offset")
            Slider(value: $petalOffset, in: -40...40)
                .padding([.horizontal, .bottom])
            
            Text("Width")
            Slider(value: $petalWidth, in: 0...100)
                .padding(.horizontal)
        }
    }
}

struct TransformShapeView_Previews: PreviewProvider {
    static var previews: some View {
        TransformShapeView()
    }
}




