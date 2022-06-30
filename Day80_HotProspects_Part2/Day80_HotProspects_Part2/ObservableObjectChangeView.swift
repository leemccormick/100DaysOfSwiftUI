//
//  ObservableObjectChangeView.swift
//  Day80_HotProspects_Part2
//
//  Created by Lee McCormick on 6/28/22.
//

import SwiftUI

@MainActor class DelayedUpdater: ObservableObject {
    // @Published var value = 0 --> Now, if you remove the @Published property wrapper you’ll see the UI no longer changes. Behind the scenes all the asyncAfter() work is still happening, but it doesn’t cause the UI to refresh any more because no change notifications are being sent out.
    var value = 0 {
        willSet {
            print("value at willSet : \(value) --> at \(Date())") // Now you’ll get the old behavior back again – the UI will count to 10 as before. Except this time we have the opportunity to add extra functionality inside that willSet observer. Perhaps you want to log something, perhaps you want to call another method, or perhaps you want to clamp the integer inside value so it never goes outside of a range – it’s all under our control now.
            objectWillChange.send()
        }
    }
    
    init() {
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.value += 1
            }
        }
    }
}

struct ObservableObjectChangeView: View {
    let info = """
    Classes that conform to the ObservableObject protocol can use SwiftUI’s @Published property wrapper to automatically announce changes to properties, so that any views using the object get their body property reinvoked and stay in sync with their data. That works really well a lot of the time, but sometimes you want a little more control and SwiftUI’s solution is called objectWillChange.
    
    Every class that conforms to ObservableObject automatically gains a property called objectWillChange. This is a publisher, which means it does the same job as the @Published property wrapper: it notifies any views that are observing that object that something important has changed. As its name implies, this publisher should be triggered immediately before we make our change, which allows SwiftUI to examine the state of our UI and prepare for animation changes.
    
    To demonstrate this we’re going to build an ObservableObject class that updates itself 10 times. We’re going to use a method called DispatchQueue.main.asyncAfter(), which lets us run an attached closure after a delay of our choosing, which means we can say “do this work after 1 second” rather than “do this work now.”
    
    In this test case, we’re going to use asyncAfter() inside a loop from 1 through 10, so we increment an integer 10 values. That integer will be wrapped using @Published so change announcements are sent out to any views that are watching it.
    
    Add this class somewhere in your code:
    
    @MainActor class DelayedUpdater: ObservableObject {
        @Published var value = 0
    
        init() {
            for i in 1...10 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                    self.value += 1
                }
            }
        }
    }
    To use that, we just need to add a @StatedObject property in ContentView, then show the value in our body, like this:
    
    struct ContentView: View {
        @StateObject var updater = DelayedUpdater()
    
        var body: some View {
            Text("Value is: updater.value")
        }
    }
    When you run that code you’ll see the value counts upwards until it reaches 10, which is exactly what you’d expect.
    
    Now, if you remove the @Published property wrapper you’ll see the UI no longer changes. Behind the scenes all the asyncAfter() work is still happening, but it doesn’t cause the UI to refresh any more because no change notifications are being sent out.
    
    We can fix this by sending the change notifications manually using the objectWillChange property I mentioned earlier. This lets us send the change notification whenever we want, rather than relying on @Published to do it automatically.
    
    Try changing the value property to this:
    
    var value = 0 {
        willSet {
            objectWillChange.send()
        }
    }
    Now you’ll get the old behavior back again – the UI will count to 10 as before. Except this time we have the opportunity to add extra functionality inside that willSet observer. Perhaps you want to log something, perhaps you want to call another method, or perhaps you want to clamp the integer inside value so it never goes outside of a range – it’s all under our control now.
    """
    
    @StateObject var updater = DelayedUpdater()
    
    var body: some View {
        ScrollView {
            Text("Value is : \(updater.value)")
                .font(.largeTitle)
                .padding()
            Text(info)
                .padding()
        }
        .navigationTitle("Manually publishing ObservableObject changes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ObservableObjectChangeView_Previews: PreviewProvider {
    static var previews: some View {
        ObservableObjectChangeView()
    }
}
