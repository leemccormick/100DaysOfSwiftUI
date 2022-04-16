//
//  SpirographView.swift
//  Day45_DrawingPart3
//
//  Created by Lee McCormick on 4/14/22.
//

import SwiftUI

struct Spirograph: Shape {
    let innerRadius: Int
    let outerRadius: Int
    let distance: Int
    let amount: Double
    
    // We then prepare three values from that data, starting with the greatest common divisor (GCD) of the inner radius and outer radius. Calculating the GCD of two numbers is usually done with Euclid's algorithm, which in a slightly simplified form looks like this:
    func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b
        while b != 0 {
            let temp = b
            b = a % b
            a = temp
        }
        return a
    }
    
    // The other two values are the difference between the inner radius and outer radius, and how many steps we need to perform to draw the roulette – this is 360 degrees multiplied by the outer radius divided by the greatest common divisor, multiplied by our amount input. All our inputs work best when provided as integers, but when it comes to drawing the roulette we need to use Double, so we’re also going to create Double copies of our inputs.
    func path(in rect: CGRect) -> Path {
        let divisor = gcd(innerRadius, outerRadius)
        let outerRadius = Double(self.outerRadius)
        let innerRadius = Double(self.innerRadius)
        let distance = Double(self.distance)
        let difference = innerRadius - outerRadius
        let endPoint = ceil(2 * Double.pi * outerRadius / Double(divisor)) * amount
        
        // Finally we can draw the roulette itself by looping from 0 to our end point, and placing points at precise X/Y coordinates. Calculating the X/Y coordinates for a given point in that loop (known as “theta”) is where the real mathematics comes in, but honestly I just converted the standard equation to Swift from Wikipedia – this is not something I would dream of memorizing! X is equal to the radius difference multiplied by the cosine of theta, added to the distance multiplied by the cosine of the radius difference divided by the outer radius multiplied by theta. Y is equal to the radius difference multiplied by the sine of theta, subtracting the distance multiplied by the sine of the radius difference divided by the outer radius multiplied by theta.
        var path = Path()
        /*
         for theta in stride(from: 0, through: endPoint, by: 0.01) {
         var x = difference * cos(theta) + distance * cos(difference / outerRadius * theta)
         var y = difference * sin(theta) - distance * sin(difference / outerRadius * theta)
         x += rect.width / 2
         y += rect.height / 2
         if theta == 0 {
         path.move(to: CGPoint(x: x, y: y))
         } else {
         path.addLine(to: CGPoint(x: x, y: y))
         }
         }
         */
        // That’s the core algorithm, but we’re going to make two small changes: we’re going to add to X and Y half the width or height of our drawing rectangle respectively so that it’s centered in our drawing space, and if theta is 0 – i.e., if this is the first point in our roulette being drawn – we’ll call move(to:) rather than addLine(to:) for our path.
        for theta in stride(from: 0, through: endPoint, by: 0.01) {
            var x = difference * cos(theta) + distance * cos(difference / outerRadius * theta)
            var y = difference * sin(theta) - distance * sin(difference / outerRadius * theta)
            x += rect.width / 2
            y += rect.height / 2
            if theta == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        return path
    }
}

struct SpirographView: View {
    @State private var innerRadius = 125.0
    @State private var outerRadius = 75.0
    @State private var distance = 25.0
    @State private var amount = 1.0
    @State private var hue = 0.6
    
    var body: some View {
        Section {
            VStack(spacing: 0) {
                Spacer()
                Spirograph(innerRadius: Int(innerRadius), outerRadius: Int(outerRadius), distance: Int(distance), amount: amount)
                    .stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 1)
                    .frame(width: 300, height: 300)
                Spacer()
                Group {
                    Text("Inner radius: \(Int(innerRadius))")
                    Slider(value: $innerRadius, in: 10...150, step: 1)
                        .padding([.horizontal, .bottom])
                    
                    Text("Outer radius: \(Int(outerRadius))")
                    Slider(value: $outerRadius, in: 10...150, step: 1)
                        .padding([.horizontal, .bottom])
                    
                    Text("Distance: \(Int(distance))")
                    Slider(value: $distance, in: 1...150, step: 1)
                        .padding([.horizontal, .bottom])
                    
                    Text("Amount: \(amount, format: .number.precision(.fractionLength(2)))")
                    Slider(value: $amount)
                        .padding([.horizontal, .bottom])
                    
                    Text("Color")
                    Slider(value: $hue)
                        .padding(.horizontal)
                }
            }
        } header: {
            Text("Creating a spirograph with SwiftUI")
                .font(.title.bold())
        }
    }
}

struct SpirographView_Previews: PreviewProvider {
    static var previews: some View {
        SpirographView()
    }
}
