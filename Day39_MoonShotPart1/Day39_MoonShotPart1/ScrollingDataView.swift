//
//  ScrollingDataView.swift
//  Day39_MoonShotPart1
//
//  Created by Lee McCormick on 4/9/22.
//

import SwiftUI

// The result will look identical, but now when you run the app you’ll see “Creating a new CustomText” printed a hundred times in Xcode’s log – SwiftUI won’t wait until you scroll down to see them, it will just create them immediately. If you want to avoid this happening, there’s an alternative for both VStack and HStack called LazyVStack and LazyHStack respectively.
struct CustomText: View {
    let text: String
    var body: some View {
        Text(text)
    }
    init(_ text: String) {
        print("Creating custom text!")
        self.text = text
    }
}

struct ScrollingDataView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                //VStack(spacing: 10) {
                Text("How ScrollView lets us work with scrolling data")
                    .font(.largeTitle)
                    .bold()
                ForEach(0..<20) {
                    Text("Item \($0)")
                        .font(.title)
                }
                ForEach(0..<20) {
                    CustomText("This is CustomText :  \($0)")
                        .font(.title2)
                }
            }
            .frame(maxWidth: .infinity) // You might also notice that it’s a bit annoying having to tap directly in the center – it’s more common to have the whole area scrollable. To get that behavior, we should make the VStack take up more space while leaving the default centre alignment intact, like this:
        }
        
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                Text("Horizontal ScrollView ")
                    .font(.largeTitle)
                    .bold()
                ForEach(0..<20) {
                    Text("Horizontal Item \($0)")
                        .font(.title)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct ScrollingDataView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollingDataView()
    }
}
