//
//  AnimatablePairView.swift
//  Day45_DrawingPart3
//
//  Created by Lee McCormick on 4/14/22.
//

import SwiftUI

struct Checkerboard: Shape {
    var rows: Int
    var columns: Int
    
    // To resolve the first problem we’re going to use a new type called AnimatablePair. As its name suggests, this contains a pair of animatable values, and because both its values can be animated the AnimatablePair can itself be animated. We can read individual values from the pair using .first and .second. To resolve the second problem we’re just going to do some type conversion: we can convert a Double to an Int just by using Int(someDouble), and go the other way by using Double(someInt). So, to make our checkerboard animate changes in the number of rows and columns, add this property:
    var animatableData: AnimatablePair<Double, Double> {
        get {
           AnimatablePair(Double(rows), Double(columns))
        }
        set {
            rows = Int(newValue.first)
            columns = Int(newValue.second)
        }
    }
    
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // figure out how big each row/column needs to be
        let rowSize = rect.height / Double(rows)
        let columnSize = rect.width / Double(columns)

        // loop over all rows and columns, making alternating squares colored
        for row in 0..<rows {
            for column in 0..<columns {
                if (row + column).isMultiple(of: 2) {
                    // this square should be colored; add a rectangle here
                    let startX = columnSize * Double(column)
                    let startY = rowSize * Double(row)
                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    path.addRect(rect)
                }
            }
        }
        return path
    }
}


struct AnimatablePairView: View {
    @State private var rows = 4
    @State private var columns = 4
    
    var body: some View {
        VStack {
            Section {
                Checkerboard(rows: rows, columns: columns)
                   // .frame(width: 200, height: 200, alignment: .center)
                    .onTapGesture {
                        withAnimation {
                            rows = 8
                            columns = 16
                        }
                    }
            } header: {
                Text("Animating complex shapes with AnimatablePair")
                              .font(.title.bold())
            }
        }
    }
}

struct AnimatablePairView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatablePairView()
    }
}
