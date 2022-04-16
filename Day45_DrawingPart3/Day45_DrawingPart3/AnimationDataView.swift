//
//  AnimationDataView.swift
//  Day45_DrawingPart3
//
//  Created by Lee McCormick on 4/14/22.
//

import SwiftUI


struct Trapezoid: Shape {
    var insetAmount: Double
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        return path
    }
}

struct TrapezoidAgain: Shape {
    var insetAmount: Double
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        //path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        return path
    }
}

struct AnimationDataView: View {
    @State private var insetAmount = 50.0
    // So, as soon as insetAmount is set to a new random value, it will immediately jump to that value and pass it directly into Trapezoid – it won’t pass in lots of intermediate values as the animation happens. This is why our trapezoid jumps from inset to inset; it has no idea an animation is even happening. We can fix this in only four lines of code, one of which is just a closing brace. However, even though this code is simple, the way it works might bend your brain. First, the code – add this new computed property to the Trapezoid struct now:
    var animateableData: Double {
        get {insetAmount}
        set {insetAmount = newValue}
    }
    var body: some View {
        VStack {
            Text("Animating simple shapes with animatableData")
                .font(.title.bold())
            Trapezoid(insetAmount: insetAmount)
                .frame(width: 200, height: 100)
                .onTapGesture {
                    withAnimation {
                        insetAmount = Double.random(in: 10...90)
                    }
                }
            TrapezoidAgain(insetAmount: insetAmount)
                .frame(width: 200, height: 200)
                .background(.red)
                .onTapGesture {
                    withAnimation {
                        insetAmount = Double.random(in: 10...90)
                    }
                }
        }
    }
}

struct AnimationDataView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatablePairView()
    }
}

