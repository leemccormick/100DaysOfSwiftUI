//
//  TwoSideView.swift
//  Day96_SnowSeeker_Part1
//
//  Created by Lee McCormick on 7/15/22.
//

import SwiftUI

struct TwoSideView: View {
    let topic = "Working with two side by side views in SwiftUI"
    let info =
    """
    You might not have realized it, but one of the smartest, simplest ways that our apps adapt to varying screen sizes is actually baked right in to NavigationView.
    
    You’re already familiar with the basic usage of NavigationView, which allows us to create views like this one:
    
    struct ContentView: View {
        var body: some View {
            NavigationView {
                Text("Hello, world!")
                    .navigationTitle("Primary")
            }
        }
    }
    However, what you see when that runs depends on several factors. If you’re using an iPhone in portrait then you’ll see the layout you’ve come to expect: a large “Primary” title at the top, then a small “Hello, world!” centered in the space below.
    
    If you rotate that same phone to landscape, then you’ll see one of two things: on the majority of iPhones the navigation title will shrink away to small text so that it takes up less space, but on max-sized iPhones, such as the iPhone 13 Pro Max, you’ll see that our title becomes a blue button in the top-left corner, leaving the whole rest of the screen clear. Tapping that button makes the “Hello, world!” text slide in from the leading edge, where you’ll also see the “Primary” title at the top.
    
    On iPad things get even cleverer, because the system will select from three different layouts depending on the device’s size and the available screen space. For example, if we were using a 12.9-inch iPad Pro in landscape, then:
    
    If our app has the whole screen to itself, you’ll see the “Hello, world!” view visible on the left, with nothing on the right.
    If the app has very little space, it will look just like a long iPhone in portrait.
    For other sizes, you’re likely to see the “Primary” button visible, which causes the “Hello, world!” text to slide in when pressed.
    What you’re seeing here is called adaptive layout, and it’s used in many of Apple’s apps such as Notes, Mail, and more. It allows iOS to make best use of available screen space without us needing to get involved.
    
    What’s actually happening here is that iOS is giving us a primary/secondary layout: a primary view to act as navigation, such as selecting from a list of books we’ve read or a list of Apollo missions, and a secondary view to act as further information, such as more details about a book or Apollo mission selected in the primary view.
    
    In our trivial code example, SwiftUI interprets the single view inside our NavigationView as being the primary view in this primary/secondary layout. However, if we do provide two views then we get some really useful behavior out of the box. Try changing your view to this:
    
    NavigationView {
        Text("Hello, world!")
            .navigationTitle("Primary")
    
        Text("Secondary")
    }
    When you launch the app what you see once again depends on your device and orientation, but on Max-sized phones and iPads you’ll see “Secondary”, with the Primary toolbar button bringing up the “Hello, world!” view.
    
    SwiftUI automatically links the primary and secondary views, which means if you have a NavigationLink in the primary view it will automatically load its content in the secondary view:
    
    NavigationView {
        NavigationLink {
            Text("New secondary")
        } label: {
            Text("Hello, World!")
        }
        .navigationTitle("Primary")
    
        Text("Secondary")
    }
    However, right now at least, all this magic has a few drawbacks that I hope will be fixed in a future SwiftUI update:
    
    Detail views always get a navigation bar whether you want it or not, so you need to use navigationBarHidden(true) to hide it.
    There’s no way of making the primary view stay visible even when there is more than enough space.
    You can’t make the primary view shown in landscape by default; SwiftUI always chooses the detail.
    Tip: You can even add a third view to NavigationView, which lets you create a sidebar. You’ll see these in apps such as Notes, where you can navigate up from from the list of notes to browse note folders. So, navigation links in the first view control the second view, and navigation links in the second view control the third view – it’s an extra level of organization for times when you need it.
    """
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            NavigationLink {
                Text("New Secondary")
                    .font(.largeTitle)
                Text("Tip: You can even add a third view to NavigationView, which lets you create a sidebar. You’ll see these in apps such as Notes, where you can navigate up from from the list of notes to browse note folders. So, navigation links in the first view control the second view, and navigation links in the second view control the third view – it’s an extra level of organization for times when you need it.")
                    .padding()
            } label: {
                Text(info)
                    .padding()
            }
            .navigationTitle(topic)
            Text("Secondary ---> Show this one second and then back to the main view, then click back show Navigation Link View")            .padding()
            Text("Tertiary  --> Show this one first, then click back show Secondary.")
                .padding()
            
            /*
             Text("Hello, No Navigation Link -->   What’s actually happening here is that iOS is giving us a primary/secondary layout: a primary view to act as navigation, such as selecting from a list of books we’ve read or a list of Apollo missions, and a secondary view to act as further information, such as more details about a book or Apollo mission selected in the primary view. In our trivial code example, SwiftUI interprets the single view inside our NavigationView as being the primary view in this primary/secondary layout. However, if we do provide two views then we get some really useful behavior out of the box. When you launch the app what you see once again depends on your device and orientation, but on Max-sized phones and iPads you’ll see “Secondary”, with the Primary toolbar button bringing up the “Hello, world!” view.")
             .navigationTitle(topic)
             Text("Secondary ---> Show this one second and then back to the main view, then click back show Navigation Link View")            .padding()
             Text("Tertiary  --> Show this one first, then click back show Secondary.")
             .padding()
             */
        }
    }
}

// MARK: - PreviewProvider
struct TwoSideView_Previews: PreviewProvider {
    static var previews: some View {
        TwoSideView()
    }
}
