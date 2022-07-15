//
//  TransparentLayoutView.swift
//  Day96_SnowSeeker_Part1
//
//  Created by Lee McCormick on 7/15/22.
//

import SwiftUI

// MARK: - UserView
struct UserView: View {
    var body: some View {
        Group {
            Text("Name : Pual")
            Text("Country : England")
            Text("Pets : Luna and Arya")
        }
        .font(.title)
    }
}

// MARK: - TransparentLayoutView
struct TransparentLayoutView: View {
    let topic = "Using groups as transparent layout containers"
    let info =
    """
    SwiftUI’s Group view is commonly used to work around the 10-child view limit, but it also has another important behavior: it acts as a transparent layout container. This means the group doesn’t actually affect our layout at all, but still gives us the ability to add SwiftUI modifiers as needed, or send back multiple views without using @ViewBuilder.
    
    For example, this UserView has a Group containing three text views:
    
    struct UserView: View {
        var body: some View {
            Group {
                Text("Name: Paul")
                Text("Country: England")
                Text("Pets: Luna and Arya")
            }
            .font(.title)
        }
    }
    That group contains no layout information, so we don’t know whether the three text fields will be stacked vertically, horizontally, or by depth. This is where the transparent layout behavior of Group becomes important: whatever parent places a UserView gets to decide how its text views get arranged.
    
    For example, we could create a ContentView like this:
    
    struct ContentView: View {
        @State private var layoutVertically = false
    
        var body: some View {
            Group {
                if layoutVertically {
                    VStack {
                        UserView()
                    }
                } else {
                    HStack {
                        UserView()
                    }
                }
            }
            .onTapGesture {
                layoutVertically.toggle()
            }
        }
    }
    That flips between vertical and horizontal layout every time the group is tapped, and again you see that using Group lets us attach the tap gesture to everything at once.
    
    You might wonder how often you need to have alternative layouts like this, but the answer might surprise you: it’s really common! You see, this is exactly what you want to happen when trying to write code that works across multiple device sizes – if we want layout to happen vertically when horizontal space is constrained, but horizontally otherwise. Apple provides a very simple solution called size classes, which is a thoroughly vague way of telling us how much space we have for our views.
    
    When I say “thoroughly vague” I mean it: we have only two size classes horizontally and vertically, called “compact” and “regular”. That’s it – that covers all screen sizes from the largest iPad Pro in landscape down to the smallest iPhone in portrait. That doesn’t mean it’s useless – far from it! – just that it only lets us reason about our user interfaces in the broadest terms.
    
    To demonstrate size classes in action, we could create a view that has a property to track the current size class so we can switch between VStack and HStack automatically:
    
    struct ContentView: View {
        @Environment(\'.horizontalSizeClass) var sizeClass
    
        var body: some View {
            if sizeClass == .compact {
                VStack {
                    UserView()
                }
            } else {
                HStack {
                    UserView()
                }
            }
        }
    }
    Tip: In situations like this, where you have only one view inside a stack and it doesn’t take any parameters, you can pass the view’s initializer directly to the VStack to make your code shorter:
    
    if sizeClass == .compact {
        VStack(content: UserView.init)
    } else {
        HStack(content: UserView.init)
    }
    I know short code isn’t everything, but this technique is pleasingly concise when you’re using this approach to grouped view layout.
    
    What you see when that code runs depends on the device you’re using. For example, an iPhone 13 Pro will have a compact horizontal size class in both portrait and landscape, whereas an iPhone 13 Pro Max will have a regular horizontal size class when in landscape.
    
    Regardless of whether we’re toggling our layout using size classes or tap gestures, the point is that UserView just doesn’t care – its Group simply groups the text views together without affecting their layout at all, so the layout arrangement UserView is given depends entirely on how it’s used.
    """
    
    // MARK: - Properties
    @State private var layoutVertically = false
    @Environment(\.horizontalSizeClass) var sizeClass
    
    // MARK: - Body
    var body: some View {
        VStack {
            // Topic
            Text(topic).font(.largeTitle).padding()
            
            // Using SizeClass
            VStack {
                if sizeClass == .compact {
                    VStack(content: UserView.init) // == VStack { UserView() }
                } else {
                    HStack(content: UserView.init) // == HStack { UserView() }
                }
            }
            
            // Using Var Layout Boolean
            VStack {
                Group {
                    if layoutVertically {
                        VStack {
                            UserView()
                        }
                    } else {
                        HStack {
                            UserView()
                        }
                    }
                }
                .onTapGesture {
                    layoutVertically.toggle()
                }
            }
        }
        
        // Info
        ScrollView {
            Text(info)
                .padding()
        }
    }
}

// MARK: - PreviewProvider
struct TransparentLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        TransparentLayoutView()
    }
}
