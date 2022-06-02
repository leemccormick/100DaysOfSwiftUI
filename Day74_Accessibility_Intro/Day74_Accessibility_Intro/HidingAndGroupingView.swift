//
//  HidingAndGroupingView.swift
//  Day74_Accessibility_Intro
//
//  Created by Lee McCormick on 6/1/22.
//

import SwiftUI

struct HidingAndGroupingView: View {
    var body: some View {
        ScrollView {
            /* For example, we can tell SwiftUI that a particular image is just there to make the UI look better by using Image(decorative:). Whether it’s a simple bullet point or an animation of your app’s mascot character running around, it doesn’t actually convey any information and so Image(decorative:) tells SwiftUI it should be ignored by VoiceOver. */
            Image(decorative: "character")
                .accessibilityHidden(true) // If you want to go a step further, you can use the .accessibilityHidden() modifier, which makes any view completely invisible to the accessibility system:
            
            /*
             With that modifier the image becomes invisible to VoiceOver regardless of what traits it has. Obviously you should only use this if the view in question really does add nothing – if you had placed a view offscreen so that it wasn’t currently visible to users, you should mark it inaccessible to VoiceOver too.
             
             The last way to hide content from VoiceOver is through grouping, which lets us control how the system reads several views that are related. As an example, consider this layout:
             */
            VStack {
                Text("Your score is")
                Text("1000")
                    .font(.title)
            }
            // .accessibilityElement(children: .combine) // modifier comes in: we can apply it to a parent view, and ask it to combine children into a single accessibility element. For example, this will cause both text views to be read together:
            .accessibilityElement(children: .ignore) // That works really well when the child views contain separate information, but in our case the children really should be read as a single entity. So, the better solution here is to use .accessibilityElement(children: .ignore) so the child views are invisible to VoiceOver, then provide a custom label to the parent, like this:
            .accessibilityLabel("Your score is 1000")
            /*
             It’s worth trying both of these to see how they differ in practice. Using .combine adds a pause between the two pieces of text, because they aren’t necessarily designed to be read together. Using .ignore and a custom label means the text is read all at once, and is much more natural.
             
             Tip: .ignore is the default parameter for children, so you can get the same results as .accessibilityElement(children: .ignore) just by saying .accessibilityElement().
             */
        }
        .navigationTitle("Hiding and grouping accessibility data")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HidingAndGroupingView_Previews: PreviewProvider {
    static var previews: some View {
        HidingAndGroupingView()
    }
}
