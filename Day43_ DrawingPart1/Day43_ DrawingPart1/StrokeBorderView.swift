//
//  StrokeBorderView.swift
//  Day43_ DrawingPart1
//
//  Created by Lee McCormick on 4/13/22.
//

import SwiftUI

struct ArcShape: Shape, InsettableShape {
    var insetAmount = 0.0
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        var path = Path()
        // path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}

struct StrokeBorderView: View {
    var body: some View {
        VStack {
            Circle()
            // .stroke(.blue, lineWidth: 40)
                .strokeBorder(.blue, lineWidth: 40)
            // There is a small but important difference between SwiftUI’s Circle and our Arc: both conform to the Shape protocol, but Circle also conforms to a second protocol called InsettableShape. This is a shape that can be inset – reduced inwards – by a certain amount to produce another shape. The inset shape it produces can be any other kind of insettable shape, but realistically it should be the same shape just in a smaller rectangle.
            Arc(startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: true)
            //   .strokeBorder(.blue, lineWidth: 40)
        }
    }
}

struct StrokeBorderView_Previews: PreviewProvider {
    static var previews: some View {
        StrokeBorderView()
    }
}
