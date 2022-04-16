//
//  PathsVsShapesView.swift
//  Day43_ DrawingPart1
//
//  Created by Lee McCormick on 4/13/22.
//

import SwiftUI

struct Triangle: Shape { // SwiftUI implements Shape as a protocol with a single required method: given the following rectangle, what path do you want to draw? This will still create and return a path just like using a raw path directly, but because we’re handed the size the shape will be used at we know exactly how big to draw our path – we no longer need to rely on fixed coordinates.
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}

// To demonstrate this, we could create an Arc shape that accepts three parameters: start angle, end angle, and whether to draw the arc clockwise or not. This might seem simple enough, particularly because Path has an addArc() method, but as you’ll see it has a couple of interesting quirks.
struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool

   /* func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)

        return path
    }*/
    // We can fix both of those problems with a new path(in:) method that subtracts 90 degrees from the start and end angles, and also flips the direction so SwiftUI behaves the way nature intended:
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment

        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)

        return path
    }
}

// The key to understanding the difference between Path and Shape is reusability: paths are designed to do one specific thing, whereas shapes have the flexibility of drawing space and can also accept parameters to let us customize them further.
struct PathsVsShapesView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
        Triangle()
            // .fill(.red)
            .stroke(.red, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
            .frame(width: 150, height: 150)
            Spacer()
        Arc(startAngle: .degrees(0), endAngle: .degrees(110), clockwise: true)
            .stroke(.blue, lineWidth: 10)
            .frame(width: 150, height: 150)
        }

    }
}

struct PathsVsShapesView_Previews: PreviewProvider {
    static var previews: some View {
        PathsVsShapesView()
    }
}
