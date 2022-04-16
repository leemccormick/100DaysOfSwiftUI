//
//  DrawingGroupView.swift
//  Day44_DrawingPart2
//
//  Created by Lee McCormick on 4/14/22.
//

import SwiftUI

struct ColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Circle()
                    .inset(by: Double(value))
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color(for: value, brightness: 1),
                                color(for: value, brightness: 0.5)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2
                    ) // However, if we increase the complexity a little we’ll find things aren’t quite so rosy. Replace the existing strokeBorder() modifier with this one:
                // .strokeBorder(color(for: value, brightness: 1), lineWidth: 2)
            }
        }
        .drawingGroup() // We can fix this by applying one new modifier, called drawingGroup(). This tells SwiftUI it should render the contents of the view into an off-screen image before putting it back onto the screen as a single rendered output, which is significantly faster. Behind the scenes this is powered by Metal, which is Apple’s framework for working directly with the GPU for extremely fast graphics.
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount
        if targetHue > 1 {
            targetHue -= 1
        }
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct DrawingGroupView: View {
    @State private var colorCycle = 0.0
    
    var body: some View {
        VStack {
            Text("Enabling high-performance Metal rendering with drawingGroup()")
                .font(.title.bold())
                .padding()
            ColorCyclingCircle(amount: colorCycle)
                .frame(width: 300, height: 300)
            Slider(value: $colorCycle)
        }
    }
}

struct DrawingGroupView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingGroupView()
    }
}
