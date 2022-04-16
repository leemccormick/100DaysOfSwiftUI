//
//  ScrollingGridView.swift
//  Day39_MoonShotPart1
//
//  Created by Lee McCormick on 4/9/22.
//

import SwiftUI

struct ScrollingGridView: View {
    // For example, if we have a vertically scrolling grid then we might say we want our data laid out in three columns exactly 80 points wide by adding this property to our view:
 /*   let layout = [
        GridItem(.fixed(80)),
        GridItem(.fixed(80)),
        GridItem(.fixed(80))
    ]
    let layout = [
        GridItem(.adaptive(minimum: 80)),
    ]*/
    let layout = [
        GridItem(.adaptive(minimum: 80, maximum: 120)),
    ]
    var body: some View {
        ScrollView {
            Text("How to lay out views in a scrolling grid")
                .font(.largeTitle)
                .bold()
            LazyVGrid(columns: layout) {
                 ForEach(0..<1000) {
                    Text("Item \($0)")
                }
            }
            // Before we’re done, I want to briefly show you how to make horizontal grids. The process is almost identical, you just need to make your ScrollView work horizontally, then create a LazyHGrid using rows rather than columns:
           /* LazyHGrid(rows: layout) {
                   ForEach(0..<1000) {
                       Text("Item \($0)")
                   }
               }
            */
        }
    }
}

struct ScrollingGridView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollingGridView()
    }
}
