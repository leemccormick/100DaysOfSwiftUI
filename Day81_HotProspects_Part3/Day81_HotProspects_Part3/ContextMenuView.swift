//
//  ContextMenuView.swift
//  Day81_HotProspects_Part3
//
//  Created by Lee McCormick on 6/29/22.
//

import SwiftUI

struct ContextMenuView: View {
    let info =
    """
    When the user taps a button or a navigation link, it’s pretty clear that SwiftUI should trigger the default action for those views. But what if they press and hold on something? On older iPhones users could trigger a 3D Touch by pressing hard on something, but the principle is the same: the user wants more options for whatever they are interacting with.
    
    SwiftUI lets us attach context menus to objects to provide this extra functionality, all done using the contextMenu() modifier. You can pass this a selection of buttons and they’ll be shown in order, so we could build a simple context menu to control a view’s background color like this:
    
    struct ContentView: View {
        @State private var backgroundColor = Color.red
    
        var body: some View {
            VStack {
                Text("Hello, World!")
                    .padding()
                    .background(backgroundColor)
    
                Text("Change Color")
                    .padding()
                    .contextMenu {
                        Button("Red") {
                            backgroundColor = .red
                        }
    
                        Button("Green") {
                            backgroundColor = .green
                        }
    
                        Button("Blue") {
                            backgroundColor = .blue
                        }
                    }
            }
        }
    }
    Just like TabView, each item in a context menu can have text and an image attached to it using a Label view.
    
    Now, there is a catch here: to keep user interfaces looking somewhat uniform across apps, iOS renders each image as a solid color where the opacity is preserved. This makes many pictures useless: if you had three photos of three different dogs, all three would be rendered as a plain black square because all the color got removed.
    
    Instead, you should aim for line art icons such as Apple’s SF Symbols, like this:
    
    Button {
        backgroundColor = .red
    } label: {
        Label("Red", systemImage: "checkmark.circle.fill")
            .foregroundColor(.red)
    }
    When you run that you’ll see the foregroundColor() modifier is ignored – iOS really does want our menus to look uniform, so trying to color them randomly just won’t work. If you really want that item to appear red, which as you should know means destructive, you should use a button role instead:
    
    Button(role: .destructive) {
        backgroundColor = .red
    } label: {
        Label("Red", systemImage: "checkmark.circle.fill")
    }
    I have a few tips for you when working with context menus, to help ensure you give your users the best experience:
    
    If you’re going to use them, use them in lots of places – it can be frustrating to press and hold on something only to find nothing happens.
    Keep your list of options as short as you can – aim for three or less.
    Don’t repeat options the user can already see elsewhere in your UI.
    Remember, context menus are by their nature hidden, so please think twice before hiding important actions in a context menu.
    """
    
    @State private var backgroundColor = Color.red
    
    var body: some View {
        ScrollView {
            Text("Hello, World!")
                .padding()
                .background(backgroundColor)
            Text("Change Color")
                .padding()
                .contextMenu {
                    // Button("Red") {
                    Button(role: .destructive) { // When you run that you’ll see the foregroundColor() modifier is ignored – iOS really does want our menus to look uniform, so trying to color them randomly just won’t work. If you really want that item to appear red, which as you should know means destructive, you should use a button role instead:
                        backgroundColor = .red
                    } label: {
                        Label("Red", systemImage: "checkmark.circle.fill")
                    }
                    Button("Green") {
                        backgroundColor = .green
                    }
                    Button("Blue") {
                        backgroundColor = .blue
                    }
                }
            Text(info)
                .padding()
        }
        .navigationTitle("Creating context menus")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContextMenuView_Previews: PreviewProvider {
    static var previews: some View {
        ContextMenuView()
    }
}
