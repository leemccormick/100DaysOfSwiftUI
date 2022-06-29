//
//  EnviromentView.swift
//  Day79_HotProspects_Intro
//
//  Created by Lee McCormick on 6/28/22.
//

import SwiftUI

// As you can see, that uses @MainActor, ObservableObject, and @Published just like we’ve learned previously – all that knowledge you built up continues to pay off.
@MainActor class User: ObservableObject {
    @Published var name = "Taylor Swift"
}

// Next we can define two SwiftUI views to use our new class. These will use the @EnvironmentObject property wrapper to say that the value of this data comes from the environment rather than being created locally:
struct EditView: View {
    @EnvironmentObject var user: User
    var body: some View {
        TextField("Name", text: $user.name)
            .multilineTextAlignment(TextAlignment.center)
            .padding()
    }
}

// That @EnvironmentObject property wrapper will automatically look for a User instance in the environment, and place whatever it finds into the user property. If it can’t find a User in the environment your code will just crash, so please be careful.
struct DisplayView: View {
    @EnvironmentObject var user: User
    var body: some View {
        Text(user.name)
            .padding()
    }
}

struct EnviromentView: View {
    @StateObject var user: User // Tip: Given that we are explicitly sharing our User instance with other views, I would personally be inclined to remove the private access control because it’s not accurate.
    let info =
    """
     You’ve seen how @State is used to work with state that is local to a single view, and how @ObservedObject lets us pass one object from view to view so we can share it. Well, @EnvironmentObject takes that one step further: we can place an object into the environment so that any child view can automatically have access to it.
    
     Imagine we had multiple views in an app, all lined up in a chain: view A shows view B, view B shows view C, C shows D, and D shows E. View A and E both want to access the same object, but to get from A to E you need to go through B, C, and D, and they don’t care about that object. If we were using @ObservedObject we’d need to pass our object from each view to the next until it finally reached view E where it could be used, which is annoying because B, C, and D don’t care about it. With @EnvironmentObject view A can put the object into the environment, view E can read the object out from the environment, and views B, C, and D don’t have to know anything happened – it’s much nicer.
    
     There’s one last thing before I show you some code: environment objects use the same ObservableObject protocol you’ve already learned, and SwiftUI will automatically make sure all views that share the same environment object get updated when it changes.
    
     OK, let’s look at some code that shows how to share data between two views using environment objects. First, here’s some basic data we can work with:
    
     @MainActor class User: ObservableObject {
         @Published var name = "Taylor Swift"
     }
     As you can see, that uses @MainActor, ObservableObject, and @Published just like we’ve learned previously – all that knowledge you built up continues to pay off.
    
     Next we can define two SwiftUI views to use our new class. These will use the @EnvironmentObject property wrapper to say that the value of this data comes from the environment rather than being created locally:
    
     struct EditView: View {
         @EnvironmentObject var user: User
    
         var body: some View {
             TextField("Name", text: $user.name)
         }
     }
    
     struct DisplayView: View {
         @EnvironmentObject var user: User
    
         var body: some View {
             Text(user.name)
         }
     }
     That @EnvironmentObject property wrapper will automatically look for a User instance in the environment, and place whatever it finds into the user property. If it can’t find a User in the environment your code will just crash, so please be careful.
    
     We can now bring those two views together in one place, and send in a User instance for them to work with:
    
     struct ContentView: View {
         @StateObject private var user = User()
    
         var body: some View {
             VStack {
                 EditView().environmentObject(user)
                 DisplayView().environmentObject(user)
             }
         }
     }
     And that’s all it takes to get our code working – you can run the app now and change the textfield to see its value appear in the text view below. Of course, we could have represented this in a single view, but this way you can see exactly how seamless the communication is when using environment objects.
    
     Now, here’s the clever part. Try rewriting the body property of ContentView to this:
    
     VStack {
         EditView()
         DisplayView()
     }
     .environmentObject(user)
     What you’ll find is that it works identically. We’re now placing user into the environment of ContentView, but because both EditView and DisplayView are children of ContentView they inherit its environment automatically.
    
     Tip: Given that we are explicitly sharing our User instance with other views, I would personally be inclined to remove the private access control because it’s not accurate.
    
     Now, you might wonder how SwiftUI makes the connection between .environmentObject(user) and @EnvironmentObject var user: User – how does it know to place that object into the correct property?
    
     Well, you’ve seen how dictionaries let us use one type for the key and another for the value. The environment effectively lets us use data types themselves for the key, and instances of the type as the value. This is a bit mind bending at first, but imagine it like this: the keys are things like Int, String, and Bool, with the values being things like 5, “Hello”, and true, which means we can say “give me the Int” and we’d get back 5.
    """
    
    var body: some View {
        ScrollView {
            VStack {
                EditView()
                DisplayView()
                /* Now, here’s the clever part. Try rewriting the body property of ContentView to this:
                 EditView().environmentObject(user)
                 DisplayView().environmentObject(user)
                 */
            }
            .environmentObject(user) // What you’ll find is that it works identically. We’re now placing user into the environment of ContentView, but because both EditView and DisplayView are children of ContentView they inherit its environment automatically.
            VStack {
                Text("Reading custom values from the environment with @EnvironmentObject")
                    .font(.headline)
                    .padding()
                Text(info)
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle("Reading custom values from the environment with @EnvironmentObject")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EnviromentView_Previews: PreviewProvider {
    static var previews: some View {
        EnviromentView(user: User())
    }
}
