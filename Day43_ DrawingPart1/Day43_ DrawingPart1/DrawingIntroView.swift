//
//  DrawingIntroView.swift
//  Day43_ DrawingPart1
//
//  Created by Lee McCormick on 4/13/22.
//

import SwiftUI

struct Underline: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundColor(.secondary)
            .padding(.vertical)
    }
}


struct DrawingIntroView: View {
    var body: some View {
        Text("Drawing : Introduction")
            .font(.largeTitle.bold())
        Underline()
        Text("In this technique project we’re going to take a close look at drawing in SwiftUI, including creating custom paths and shapes, animating your changes, solving performance problems, and more – it’s a really big topic, and deserves close attention. Behind the scenes, SwiftUI uses the same drawing system that we have on the rest of Apple’s frameworks: Core Animation and Metal. Most of the time Core Animation is responsible for our drawing, whether that’s custom paths and shapes or UI elements such as TextField, but when things really get complex we can move down to Metal – Apple’s low-level framework that’s optimized for complex drawing. One of the neat features of SwiftUI is that these two are almost interchangeable: we can move from Core Animation to Metal with one small change. Anyway, we have lots to cover so please create a new App project called Drawing and let’s dive in…")
            .font(.body)
        Underline()
        
    }
}

struct DrawingIntroView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingIntroView()
    }
}
