//
//  NotifiedBackgroundView.swift
//  Day87_Flashzilla_Part2
//
//  Created by Lee McCormick on 7/10/22.
//

import SwiftUI

struct NotifiedBackgroundView: View {
    let info =
    """
         SwiftUI can detect when your app moves to the background (i.e., when the user returns to the home screen), and when it comes back to the foreground, and if you put those two together it allows us to make sure our app pauses and resumes work depending on whether the user can see it right now or not.
    
         This is done using three steps:
    
         Adding a new property to watch an environment value called scenePhase.
         Using onChange() to watch for the scene phase changing.
         Responding to the new scene phase somehow.
         You might wonder why it’s called scene phase as opposed to something to do with your current app state, but remember that on iPad the user can run multiple instances of your app at the same time – they can have multiple windows, known as scenes, each in a different state.
    
         To see the various scene phases in action, try this code:
    
         struct ContentView: View {
             @Environment(\'.scenePhase) var scenePhase
    
             var body: some View {
                 Text("Hello, world!")
                     .padding()
                     .onChange(of: scenePhase) { newPhase in
                         if newPhase == .active {
                             print("Active")
                         } else if newPhase == .inactive {
                             print("Inactive")
                         } else if newPhase == .background {
                             print("Background")
                         }
                     }
             }
         }
         When you run that back, try going to the home screen in your simulator, locking the virtual device, and other common activities to see how the scene phase changes.
    
         As you can see, there are three scene phases we need to care about:
    
         Active scenes are running right now, which on iOS means they are visible to the user. On macOS an app’s window might be wholly hidden by another app’s window, but that’s okay – it’s still considered to be active.
         Inactive scenes are running and might be visible to the user, but the user isn’t able to access them. For example, if you’re swiping down to partially reveal the control center then the app underneath is considered inactive.
         Background scenes are not visible to the user, which on iOS means they might be terminated at some point in the future.
    """
    
    /* This is done using three steps:
     - Adding a new property to watch an environment value called scenePhase.
     - Using onChange() to watch for the scene phase changing.
     - Responding to the new scene phase somehow.
     */
    
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        VStack {
            Text("How to be notified when your SwiftUI app moves to the background")
                .font(.largeTitle)
                .padding()
            Text("Scene Phase")
                .padding()
                .onChange(of: scenePhase) { newPhase in
                    if newPhase == .active {
                        print("ScenePhase : Active at \(Date())")
                    } else if newPhase == .inactive {
                        print("ScenePhase : Inactive at \(Date())")
                    } else if newPhase == .background {
                        print("ScenePhase : Background at \(Date())")
                    }
                }
            ScrollView {
                Text(info)
                    .font(.body)
                    .padding()
            }
        }
    }
}

struct NotifiedBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        NotifiedBackgroundView()
    }
}
