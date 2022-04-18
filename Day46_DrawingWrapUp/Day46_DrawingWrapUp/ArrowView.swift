//
//  ArrowView.swift
//  Day46_DrawingWrapUp
//
//  Created by Lee McCormick on 4/16/22.
//

import SwiftUI

// Challenge 1 : Create an Arrow shape
struct Arrow: InsettableShape {
    let arrowWidth: CGFloat = 100
    let arrowHeigh: CGFloat  = 200
    var arrowInsetAmount: CGFloat = 0
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX - (arrowWidth * 0.7), y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + (arrowWidth * 0.7), y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + (arrowWidth * 0.7), y: rect.minY + (arrowHeigh * 0.7)))
        path.addLine(to: CGPoint(x: rect.maxX - (arrowWidth * 0.1), y: rect.minY + (arrowHeigh * 0.7)))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + (arrowHeigh * 0.7)))
        path.addLine(to: CGPoint(x: rect.midX - (arrowWidth * 0.7), y: rect.minY + (arrowHeigh * 0.7)))
        path.addLine(to: CGPoint(x: rect.midX - (arrowWidth * 0.7), y: rect.maxY))
        path.closeSubpath()
        return path
    }
    // Challenge 2 :  Make the line thickness of your Arrow shape animatable.
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arrow = self
        arrow.arrowInsetAmount += amount
        return arrow
    }
}

struct ArrowView: View {
    @State private var arrowLineThinkness = 5.0
    var body: some View {
        VStack(spacing: 20) {
            Arrow()
                .strokeBorder(Color.red ,lineWidth: arrowLineThinkness)
            Spacer()
            Slider(value: $arrowLineThinkness, in: 0...100, step: 1)
                .padding()
        }
        .navigationTitle("Arrow")
    }
}

struct ArrowView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

