//
//  OnChangeView.swift
//  Day62_Instafilter_Part1
//
//  Created by Lee McCormick on 5/14/22.
//

import SwiftUI

struct OnChangeView: View {
    @State private var blurAmout = 0.0
    let info =
    """
Now that code will correctly print out values as the slider changes, because onChange() is watching it. Notice how most other things have stayed the same: we still use @State private var to declare the blurAmount property, and we still use blur(radius: blurAmount) as the modifier for our text view.

What all this means is that you can do whatever you want inside the onChange() function: you can call methods, run an algorithm to figure out how to apply the change, or whatever else you might need.
"""
    var body: some View {
        VStack {
            Text("Hello ! Using OnChange On Slider !")
                .blur(radius: blurAmout)
                .font(.headline.bold())
                .multilineTextAlignment(.center)
            Text("\(info)")
                .blur(radius: blurAmout)
                .multilineTextAlignment(.leading)
            Slider(value: $blurAmout, in: 0...20)
                .onChange(of: blurAmout) { newValue in
                    print("New Value is \(newValue)") // To fix this we need to use the onChange() modifier, which tells SwiftUI to run a function of our choosing when a particular value changes. SwiftUI will automatically pass in the new value to whatever function you attach, or you can just read the original property if you prefer:
                }
        }
        .navigationBarTitle("Responding to state changes using onChange()")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct OnChangeView_Previews: PreviewProvider {
    static var previews: some View {
        OnChangeView()
    }
}
