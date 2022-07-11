//
//  AccessibilityView.swift
//  Day87_Flashzilla_Part2
//
//  Created by Lee McCormick on 7/10/22.
//

import SwiftUI

struct AccessibilityView: View {
    let info =
    """
             SwiftUI gives us a number of environment properties that describe the user’s custom accessibility settings, and it’s worth taking the time to read and respect those settings.
    
             Back in project 15 we looked at accessibility labels and hints, traits, groups, and more, but these settings are different because they are provided through the environment. This means SwiftUI automatically monitors them for changes and will reinvoke our body property whenever one of them changes.
    
             For example, one of the accessibility options is “Differentiate without color”, which is helpful for the 1 in 12 men who have color blindness. When this setting is enabled, apps should try to make their UI clearer using shapes, icons, and textures rather than colors.
    
             To use this, just add an environment property like this one:
    
             @Environment(\'.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
             That will be either true or false, and you can adapt your UI accordingly. For example, in the code below we use a simple green background for the regular layout, but when Differentiate Without Color is enabled we use a black background and add a checkmark instead:
    
             struct ContentView: View {
                 @Environment(\'.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
                 var body: some View {
                     HStack {
                         if differentiateWithoutColor {
                             Image(systemName: "checkmark.circle")
                         }
    
                         Text("Success")
                     }
                     .padding()
                     .background(differentiateWithoutColor ? .black : .green)
                     .foregroundColor(.white)
                     .clipShape(Capsule())
                 }
             }
             You can test that in the simulator by going to the Settings app and choosing Accessibility > Display & Text Size > Differentiate Without Color.
    
             Another common option is Reduce Motion, which again is available in the simulator under Accessibility > Motion > Reduce Motion. When this is enabled, apps should limit the amount of animation that causes movement on screen. For example, the iOS app switcher makes views fade in and out rather than scale up and down.
    
             With SwiftUI, this means we should restrict the use of withAnimation() when it involves movement, like this:
    
             struct ContentView: View {
                 @Environment(\'.accessibilityReduceMotion) var reduceMotion
                 @State private var scale = 1.0
    
                 var body: some View {
                     Text("Hello, World!")
                         .scaleEffect(scale)
                         .onTapGesture {
                             if reduceMotion {
                                 scale *= 1.5
                             } else {
                                 withAnimation {
                                     scale *= 1.5
                                 }
                             }
                         }
                 }
             }
             I don’t know about you, but I find that rather annoying to use. Fortunately we can add a little wrapper function around withAnimation() that uses UIKit’s UIAccessibility data directly, allowing us to bypass animation automatically:
    
             func withOptionalAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
                 if UIAccessibility.isReduceMotionEnabled {
                     return try body()
                 } else {
                     return try withAnimation(animation, body)
                 }
             }
             So, when Reduce Motion Enabled is true the closure code that’s passed in is executed immediately, otherwise it’s passed along using withAnimation(). The whole throws/rethrows thing is more advanced Swift, but it’s a direct copy of the function signature for withAnimation() so that the two can be used interchangeably.
    
             Use it like this:
    
             struct ContentView: View {
                 @State private var scale = 1.0
    
                 var body: some View {
                     Text("Hello, World!")
                         .scaleEffect(scale)
                         .onTapGesture {
                             withOptionalAnimation {
                                 scale *= 1.5
                             }
                         }
                 }
             }
             Using this approach you don’t need to repeat your animation code every time.
    
             One last option you should consider supporting is Reduce Transparency, and when that’s enabled apps should reduce the amount of blur and translucency used in their designs to make doubly sure everything is clear.
    
             For example, this code uses a solid black background when Reduce Transparency is enabled, otherwise using 50% transparency:
    
             struct ContentView: View {
                 @Environment(\'.accessibilityReduceTransparency) var reduceTransparency
    
                 var body: some View {
                     Text("Hello, World!")
                         .padding()
                         .background(reduceTransparency ? .black : .black.opacity(0.5))
                         .foregroundColor(.white)
                         .clipShape(Capsule())
                 }
             }
             That’s the final technique I want you to learn ahead of building the real project, so please reset your project back to its original state so we have a clean slate to start on.
    """
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differrentiateWithoutColor
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @State private var scale = 1.0
    
    var body: some View {
        VStack {
            Text("Supporting specific accessibility needs with SwiftUI")
                .font(.largeTitle)
                .padding()
            
            // DifferrentiateWithoutColor --> You can test that in the simulator by going to the Settings app and choosing Accessibility > Display & Text Size > Differentiate Without Color.
            HStack {
                if differrentiateWithoutColor {
                    Image(systemName: "checkmark.circle")
                }
                Text("Success --> differrentiateWithoutColor")
            }
            .padding()
            .background(differrentiateWithoutColor ? .black : .green)
            .foregroundColor(.white)
            .clipShape(Capsule())
            
            // ReduceMotion --> Another common option is Reduce Motion, which again is available in the simulator under Accessibility > Motion > Reduce Motion. When this is enabled, apps should limit the amount of animation that causes movement on screen. For example, the iOS app switcher makes views fade in and out rather than scale up and down.
            Text("Hello, ReduceMotion")
                .padding()
                .scaleEffect(scale)
                .onTapGesture {
                    if reduceMotion {
                        scale *= 1.5
                    } else {
                        withAnimation {
                            scale *= 1.5
                        }
                    }
                }
            
            // So, when Reduce Motion Enabled is true the closure code that’s passed in is executed immediately, otherwise it’s passed along using withAnimation(). The whole throws/rethrows thing is more advanced Swift, but it’s a direct copy of the function signature for withAnimation() so that the two can be used interchangeably.
            Text("Hello, ReduceMotion With UIKit’s UIAccessibility")
                .padding()
                .scaleEffect(scale)
                .onTapGesture {
                    withOptionalAnimation {
                        scale *= 1.5
                    }
                }
            
            ScrollView {
                Text(info)
                    .font(.body)
                    .padding()
            }
        }
    }
    
    // I don’t know about you, but I find that rather annoying to use. Fortunately we can add a little wrapper function around withAnimation() that uses UIKit’s UIAccessibility data directly, allowing us to bypass animation automatically:
    func withOptionalAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
        if UIAccessibility.isReduceMotionEnabled {
            return try body()
        } else {
            return try withAnimation(animation, body)
        }
    }
}

struct AccessibilityView_Previews: PreviewProvider {
    static var previews: some View {
        AccessibilityView()
    }
}
