//
//  StructPropertyWrapperView.swift
//  Day62_Instafilter_Part1
//
//  Created by Lee McCormick on 5/14/22.
//

import SwiftUI

struct StructPropertyWrapperView: View {
    let info = "So, changing the property directly using a button works fine, because it goes through the nonmutating setter and triggers the didSet observer, but using a $ binding doesn’t because it bypasses the setter and adjusts the value directly."
    // Property wrappers have that name because they wrap our property inside another struct. What this means is that when we use @State to wrap a string, the actual type of property we end up with is a State<String>. Similarly, when we use @Environment and others we end up with a struct of type Environment that contains some other value inside it.
    // Xcode has a really helpful command called “Open Quickly” (accessed using Cmd+Shift+O), which lets you find any file or type in your project or any of the frameworks you have imported. Activate it now, and type “State” – hopefully the first result says SwiftUI below it, but if not please find that and select it.
    @State private var blurAmount = 0.0 { // On the surface, that states “when blurAmount changes, print out its new value.” However, because @State actually wraps its contents, what it’s actually saying is that when the State struct that wraps blurAmount changes, print out the new blur amount.
        didSet {
            print("New value is \(blurAmount)") // Still with me? Now let’s go a stage further: you’ve just seen how State wraps its value using a non-mutating setter, which means neither blurAmount or the State struct wrapping it are changing – our binding is directly changing the internally stored value, which means the property observer is never being triggered.
        }
    }
    var body: some View {
        VStack {
            Text("Hello Text Can be Blured !")
                .blur(radius: blurAmount)
            Slider(value: $blurAmount, in: 0...20)
            Button("Random Blur") {
                blurAmount = Double.random(in: 0...20) // So, changing the property directly using a button works fine, because it goes through the nonmutating setter and triggers the didSet observer, but using a $ binding doesn’t because it bypasses the setter and adjusts the value directly.
            }
            Text(info)
                .padding()
                .font(.body)
                .blur(radius: blurAmount)
        }
        .navigationTitle("How property wrappers become structs")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StructPropertyWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        StructPropertyWrapperView()
    }
}

/*
 That @propertyWrapper attribute is what makes this into @State for us to use.

 Now look a few lines further down, and you should see this:

 public var wrappedValue: Value { get nonmutating set }
 That wrapped value is the actual value we’re trying to store, such as a string. What this generated interface is telling us is that the property can be read (get), and written (set), but that when we set the value it won’t actually change the struct itself. Behind the scenes, it sends that value off to SwiftUI for storage in a place where it can be modified freely, so it’s true that the struct itself never changes.
 */
