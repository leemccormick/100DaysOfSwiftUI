//
//  PushViewNavigationLink.swift
//  Day39_MoonShotPart1
//
//  Created by Lee McCormick on 4/9/22.
//

import SwiftUI

// NavigationLink is for showing details about the user’s selection, like you’re digging deeper into a topic.
struct PushViewNavigationLink: View {
    var body: some View {
        NavigationView {
            /*      NavigationLink {
             Text("Detail View")
             } label: {
             Text("Hello, world!")
             .padding()
             } */
            List(0..<100) { row in
                NavigationLink {
                    Text("Detail \(row)")
                } label: {
                    Text("Row \(row)")
                }
            }
            .navigationTitle("Pushing new views onto the stack using NavigationLink")
        }
    }
}

struct PushViewNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        PushViewNavigationLink()
    }
}
