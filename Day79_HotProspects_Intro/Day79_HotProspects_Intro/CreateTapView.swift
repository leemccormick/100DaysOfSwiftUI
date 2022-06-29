//
//  CreateTapView.swift
//  Day79_HotProspects_Intro
//
//  Created by Lee McCormick on 6/28/22.
//

import SwiftUI

struct CreateTapView: View {
    @State private var selectedTap = "One"
    let info = """
    Navigation views are great for letting us create hierarchical stacks of views that let users drill down into data, but they don’t work so well for showing unrelated data. For that we need to use SwiftUI’s TabView, which creates a button strip across the bottom of the screen, where tapping each button shows a different view.
    
    Placing tabs inside a TabView is as simple as listing them out one by one, like this:
    
    TabView {
        Text("Tab 1")
        Text("Tab 2")
    }
    However, in practice you will always want to customize the way the tabs are shown – in the code above the tab bar will be an empty gray space. Although you can tap on the left and right parts of that gray space to activate the two tabs, it’s a pretty terrible user experience.
    
    Instead, it’s a better idea to attach the tabItem() modifier to each view that’s inside a TabView. This lets you customize the way the view is shown in the tab bar, providing an image and some text to show next to it like this:
    
    TabView {
        Text("Tab 1")
            .tabItem {
                Label("One", systemImage: "star")
            }
    
        Text("Tab 2")
            .tabItem {
                Label("Two", systemImage: "circle")
            }
    }
    As well as letting the user switch views by tapping on their tab item, SwiftUI also allows us to control the current view programmatically using state. This takes four steps:
    
    Create an @State property to track the tab that is currently showing.
    Modify that property to a new value whenever we want to jump to a different tab.
    Pass that as a binding into the TabView, so it will be tracked automatically.
    Tell SwiftUI which tab should be shown for each value of that property.
    The first three of those are simple enough, so let’s get them out of the way. First, we need some state to track the current tab, so add this as a property to ContentView:
    
    @State private var selectedTab = "One"
    Second, we need to modify that somewhere, which will ask SwiftUI to switch tabs. In our little demo we could attach an onTapGesture() modifier to the first tab, like this:
    
    Text("Tab 1")
        .onTapGesture {
            selectedTab = "Two"
        }
        .tabItem {
            Label("One", systemImage: "star")
        }
    Third, we need to bind the selection of the TabView to $selectedTab. This is passed as a parameter when we create the TabView, so update your code to this:
    
    TabView(selection: $selectedTab) {
    Now for the interesting part: when we say selectedTab = "Two" how does SwiftUI know which tab that represents? You might think that the tabs could be treated as an array, in which case the second tab would be at index 1, but that causes all sorts of problems: what if we move that tab to a different position in the tab view?
    
    At a deeper level, it also breaks apart one of the core SwiftUI concepts: that we should be able to compose views freely. If tab 1 was the second item in the array, then:
    
    Tab 0 is the first tab.
    Tab 1 is the second tab.
    Tab 0 has an onTapGesture() that shows tab 1.
    Therefore tab 0 has intimate knowledge of how its parent, the TabView, is configured.
    This is A Very Bad Idea, and so SwiftUI offers a better solution: we can attach a unique identifier to each view, and use that for the selected tab. These identifiers are called tags, and are attached using the tag() modifier like this:
    
    Text("Tab 2")
        .tabItem {
            Image(systemName: "circle")
            Text("Two")
        }
        .tag("Two")
    So, our entire view would be this:
    
    struct ContentView: View {
        @State private var selectedTab = "One"
    
        var body: some View {
            TabView(selection: $selectedTab) {
                Text("Tab 1")
                    .onTapGesture {
                        selectedTab = "Two"
                    }
                    .tabItem {
                        Label("One", systemImage: "star")
                    }
                    .tag("One")
    
                Text("Tab 2")
                    .tabItem {
                        Label("Two", systemImage: "circle")
                    }
                    .tag("Two")
            }
        }
    }
    And now that code works: you can switch between tabs by pressing on their tab items, or by activating our tap gesture in the first tab.
    
    Of course, just using “One” and “Two” isn’t ideal – those values are fixed and so it solves the problem of views being moved around, but they aren’t easy to remember. Fortunately, you can use whatever values you like instead: give each view a string tag that is unique and reflects its purpose, then use that for your @State property. This is much easier to work with in the long term, and is recommended over integers.
    
    Tip: It’s common to want to use NavigationView and TabView at the same time, but you should be careful: TabView should be the parent view, with the tabs inside it having a NavigationView as necessary, rather than the other way around.
    """
    
    var body: some View {
        TabView(selection: $selectedTap) {
            ScrollView {
                Text("Tap 1")
                    .font(.headline)
                    .padding()
                Text(info)
                    .font(.body)
                    .padding()
            }
            .onTapGesture {
                selectedTap = "Two"
            }
            .tabItem {
                Label("One", systemImage: "star")
            }
            .tag("One")
            Text("Tap 2")
                .onTapGesture {
                    selectedTap = "One"
                }
                .tabItem {
                    Label("One", systemImage: "circle")
                }
                .tag("Two")
        }
        .navigationTitle("Creating tabs with TabView and tabItem()")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CreateTapView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTapView()
    }
}
