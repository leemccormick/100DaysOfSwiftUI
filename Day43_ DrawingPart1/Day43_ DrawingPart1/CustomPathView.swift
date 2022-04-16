//
//  CustomPathView.swift
//  Day43_ DrawingPart1
//
//  Created by Lee McCormick on 4/13/22.
//

import SwiftUI

struct CustomPathView: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 200, y: 100))
            path.addLine(to: CGPoint(x: 100, y: 300))
            path.addLine(to: CGPoint(x: 300, y: 300))
            path.addLine(to: CGPoint(x: 200, y: 100))
            // path.closeSubpath() // This is particularly useful because one of the options for join and cap is .round, which creates gently rounded shapes: With that in place you can remove the call to path.closeSubpath(), because it’s no longer needed.
         }
        // .fill(.pink) // We’ll look at a better option shortly, but first let’s look at coloring our path. One option is to use the fill() modifier, like this:
         // .stroke(.pink, lineWidth: 10) // We can also use the stroke() modifier to draw around the path rather than filling it in:
        .stroke(.pink, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round)) // An alternative is to use SwiftUI’s dedicated StrokeStyle struct, which gives us control over how every line should be connected to the line after it (line join) and how every line should be drawn when it ends without a connection after it (line cap). This is particularly useful because one of the options for join and cap is .round, which creates gently rounded shapes:
    }
}

struct CustomPathView_Previews: PreviewProvider {
    static var previews: some View {
        CustomPathView()
    }
}
