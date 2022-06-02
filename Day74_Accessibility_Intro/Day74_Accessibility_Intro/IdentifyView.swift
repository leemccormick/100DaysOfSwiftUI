//
//  IdentifyView.swift
//  Day74_Accessibility_Intro
//
//  Created by Lee McCormick on 6/1/22.
//

import SwiftUI
/*
 There’s nothing complicated there, but it already helps to illustrate two serious problems.

 If you haven’t already enabled VoiceOver in the Settings app on your iOS device, please do so now: Settings > Accessibility > VoiceOver, then toggle it on. Alternatively, you can activate Siri at any time and ask to enable or disable VoiceOver.

 Important: Immediately below the VoiceOver toggle is instructions for how to use it. The regular taps and swipes you’re used to no longer function the same way, so read those instructions!


 Now launch our app on your device, and try tapping once on the picture to activate it. If you listen carefully to VoiceOver you should hear two problems:

 1) Reading out “Kevin Horstmann one four one seven zero five” is not only unhelpful for the user because it doesn’t describe the picture at all, but it’s actually confusing – the long string of numbers does more harm than good.
 2) After reading the above string, VoiceOver then says “image”. This is true, it is an image, but it’s also acting as a button because we added an onTapGesture() modifier.
 */
struct IdentifyView: View {
    let pictures = [
        "ales-krivec-15949",
        "galina-n-189483",
        "kevin-horstmann-141705",
        "nicolas-tissot-335096"
    ]
    let labels = [
    "Tulips",
    "Frozen tree buds",
    "Sunflower",
    "Fireworks"
    ]
    @State private var selectedPicture = Int.random(in: 0...3)

    var body: some View {
        VStack {
       Image(pictures[selectedPicture])
            .resizable()
            .scaledToFit()
            .onTapGesture {
                selectedPicture = Int.random(in: 0...3)
            }
            /*
             We can control what VoiceOver reads for a given view by attaching two modifiers: .accessibilityLabel() and .accessibilityHint(). They both take text containing anything we want, but they serve different purposes:

             - The label is read immediately, and should be a short piece of text that gets right to the point. If this view deletes an item from the user’s data, it might say “Delete”.
             - The hint is read after a short delay, and should provide more details on what the view is there for. It might say “Deletes an email from your inbox”, for example.
             */
            .accessibilityLabel(labels[selectedPicture])
            .accessibilityAddTraits(.isButton) // We can fix this second problem using another modifier, .accessibilityAddTraits(). This lets us provide some extra behind the scenes information to VoiceOver that describes how the view works, and in our case we can tell it that our image is also a button by adding this modifier:
            .accessibilityRemoveTraits(.isImage) // If you wanted, you could remove the image trait as well, because it isn’t really adding much:
        }
        .navigationTitle("Identifying views with useful labels")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct IdentifyView_Previews: PreviewProvider {
    static var previews: some View {
        IdentifyView()
    }
}
