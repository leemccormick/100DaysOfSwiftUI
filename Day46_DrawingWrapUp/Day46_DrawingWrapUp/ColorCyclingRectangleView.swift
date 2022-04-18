//
//  ColorCyclingRectangleView.swift
//  Day46_DrawingWrapUp
//
//  Created by Lee McCormick on 4/16/22.
//

import SwiftUI

// Challenge 3 :  Create a ColorCyclingRectangle shape that is the rectangular cousin of ColorCyclingCircle, allowing us to control the position of the gradient using one or more properties.
struct ColorCyclingRectangle: View {
    var amount = 0.0
    var steps = 100
    var body : some View {
        ZStack {
            ForEach(0..<steps) { value in
                Rectangle()
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
                    )
            }
        }
        .drawingGroup()
    }
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount
        if targetHue > 1 {
            targetHue -= 1
        }
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ColorCyclingRectangleView: View {
    @State private var colorCycle = 0.0
    @State private var stepsCycle = 150
    let steps = [50, 80, 100, 120, 150]

    var body: some View {
        VStack {
            
            ColorCyclingRectangle(amount: colorCycle, steps: stepsCycle)
                .frame(width: 300, height: 300)
            Text("Color : ")
                .foregroundColor(.blue)
                .font(.title.bold())
                .padding()
            Slider(value: $colorCycle)
            Text("Step : ")
                .foregroundColor(.blue)
                .font(.title.bold())
                .padding()
            Picker("Steps", selection: $stepsCycle) {
                ForEach(steps, id: \.self) { step in
                    Text("\(step)")
                }
            }
            .pickerStyle(.segmented)
        }
        .navigationTitle("Color Cycling Rectangle")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ColorCyclingRectangleView_Previews: PreviewProvider {
    static var previews: some View {
        ColorCyclingRectangleView()
    }
}
