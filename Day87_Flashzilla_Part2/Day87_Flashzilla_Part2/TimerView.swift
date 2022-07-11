//
//  TimerView.swift
//  Day87_Flashzilla_Part2
//
//  Created by Lee McCormick on 7/10/22.
//

import SwiftUI //  import SwiftUI we also implicitly import parts of Combine.

struct TimerView: View {
    let info =
     """
     iOS comes with a built-in Timer class that lets us run code on a regular basis. This uses a system of publishers that comes from an Apple framework called Combine. We’ve actually been using parts of Combine for many apps in this series, although it’s unlikely you noticed it. For example, both the @Published property wrapper and ObservableObject protocols both come from Combine, but we didn’t need to know that because when you import SwiftUI we also implicitly import parts of Combine.
     
     Apple’s core system library is called Foundation, and it gives us things like Data, Date, SortDescriptor, UserDefaults, and much more. It also gives us the Timer class, which is designed to run a function after a certain number of seconds, but it can also run code repeatedly. Combine adds an extension to this so that timers can become publishers, which are things that announce when their value changes. This is where the @Published property wrapper gets its name from, and timer publishers work the same way: when your time interval is reached, Combine will send an announcement out containing the current date and time.
     
     The code to create a timer publisher looks like this:
     
     let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
     That does several things all at once:
     
     It asks the timer to fire every 1 second.
     It says the timer should run on the main thread.
     It says the timer should run on the common run loop, which is the one you’ll want to use most of the time. (Run loops let iOS handle running code while the user is actively doing something, such as scrolling in a list.)
     It connects the timer immediately, which means it will start counting time.
     It assigns the whole thing to the timer constant so that it stays alive.
     If you remember, back in project 7 I said “@Published is more or less half of @State” – it sends change announcements that something else can monitor. In the case of regular publishers like this one, we need to catch the announcements by hand using a new modifier called onReceive(). This accepts a publisher as its first parameter and a function to run as its second, and it will make sure that function is called whenever the publisher sends its change notification.
     
     For our timer example, we could receive its notifications like this:
     
     Text("Hello, World!")
         .onReceive(timer) { time in
             print("The time is now \'(time)")
         }
     That will print the time every second until the timer is finally stopped.
     
     Speaking of stopping the timer, it takes a little digging to stop the one we created. You see, the timer property we made is an autoconnected publisher, so we need to go to its upstream publisher to find the timer itself. From there we can connect to the timer publisher, and ask it to cancel itself. Honestly, if it weren’t for code completion this would be rather hard to find, but here’s how it looks in code:
     
     timer.upstream.connect().cancel()
     For example, we could update our existing example so that it fires the timer only five times, like this:
     
     struct ContentView: View {
         let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
         @State private var counter = 0
     
         var body: some View {
             Text("Hello, World!")
                 .onReceive(timer) { time in
                     if counter == 5 {
                         timer.upstream.connect().cancel()
                     } else {
                         print("The time is now \'(time)")
                     }
     
                     counter += 1
                 }
         }
     }
     Before we’re done, there’s one more important timer concept I want to show you: if you’re OK with your timer having a little float, you can specify some tolerance. This allows iOS to perform important energy optimization, because it can fire the timer at any point between its scheduled fire time and its scheduled fire time plus the tolerance you specify. In practice this means the system can perform timer coalescing: it can push back your timer just a little so that it fires at the same time as one or more other timers, which means it can keep the CPU idling more and save battery power.
     
     As an example, this adds half a second of tolerance to our timer:
     
     let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
     If you need to keep time strictly then leaving off the tolerance parameter will make your timer as accurate as possible, but please note that even without any tolerance the Timer class is still “best effort” – the system makes no guarantee it will execute precisely.
     """
    
    /* That does several things all at once:
     - It asks the timer to fire every 1 second.
     - It says the timer should run on the main thread.
     - It says the timer should run on the common run loop, which is the one you’ll want to use most of the time. (Run loops let iOS handle running code while the user is actively doing something, such as scrolling in a list.)
     - It connects the timer immediately, which means it will start counting time.
     - It assigns the whole thing to the timer constant so that it stays alive.
     */
    
    // let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // If you remember, back in project 7 I said “@Published is more or less half of @State” – it sends change announcements that something else can monitor. In the case of regular publishers like this one, we need to catch the announcements by hand using a new modifier called onReceive(). This accepts a publisher as its first parameter and a function to run as its second, and it will make sure that function is called whenever the publisher sends its change notification.
    @State private var counter = 0 // Speaking of stopping the timer, it takes a little digging to stop the one we created. You see, the timer property we made is an autoconnected publisher, so we need to go to its upstream publisher to find the timer itself. From there we can connect to the timer publisher, and ask it to cancel itself. Honestly, if it weren’t for code completion this would be rather hard to find.
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect() // In practice this means the system can perform timer coalescing: it can push back your timer just a little so that it fires at the same time as one or more other timers, which means it can keep the CPU idling more and save battery power.
    
    var body: some View {
        VStack {
            Text("Triggering events repeatedly using a timer")
                .font(.largeTitle)
                .padding()
            Text("Hello, Triggering Events With Timer")
                .onReceive(timer) { time in
                    if counter == 5 {
                        print("The timer is stopping at \(time)")
                        timer.upstream.connect().cancel()
                    } else {
                        print("The time is now --> \(time)") // That will print the time every second until the timer is finally stopped.
                    }
                    counter += 1
                }
            ScrollView {
                Text(info)
                    .font(.body)
                    .padding()
            }
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
