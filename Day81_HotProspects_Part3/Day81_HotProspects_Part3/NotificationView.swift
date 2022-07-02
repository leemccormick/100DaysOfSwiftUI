//
//  NotificationView.swift
//  Day81_HotProspects_Part3
//
//  Created by Lee McCormick on 6/29/22.
//

import SwiftUI
import UserNotifications

struct NotificationView: View {
    let info =
    """
    iOS has a framework called UserNotifications that does pretty much exactly what you expect: lets us create notifications to the user that can be shown on the lock screen. We have two types of notifications to work with, and they differ depending on where they were created: local notifications are ones we schedule locally, and remote notifications (commonly called push notifications) are sent from a server somewhere.
    
    Remote notifications require a server to work, because you send your message to Apple’s push notification service (APNS), which then forwards it to users. But local notifications are nice and easy in comparison, because we can send any message at any time as long as the user allows it.
    
    To try this out, start by adding an extra import near the top of ContentView.swift:
    
    import UserNotifications
    Next we’re going to put in some basic structure that we’ll fill in with local notifications code. Using local notifications requires asking the user for permission, then actually registering the notification we want to show. We’ll place each of those actions into separate buttons inside a VStack, so please put this inside your ContentView struct now:
    
    VStack {
        Button("Request Permission") {
            // first
        }
    
        Button("Schedule Notification") {
            // second
        }
    }
    OK, that’s our setup complete so let’s turn our focus to the first of two important pieces of work: requesting authorization to show alerts. Notifications can take a variety of forms, but the most common thing to do is ask for permission to show alerts, badges, and sounds – that doesn’t mean we need to use all of them at the same time, but asking permission up front means we can be selective later on.
    
    When we tell iOS what kinds of notifications we want, it will show a prompt to the user so they have the final say on what our app can do. When they make their choice, a closure we provide will get called and tell us whether the request was successful or not.
    
    So, replace the // first comment with this:
    
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        if success {
            print("All set!")
        } else if let error = error {
            print(error.localizedDescription)
        }
    }
    If the user grants permission, then we’re all clear to start scheduling notifications. Even though notifications might seem simple, Apple breaks them down into three parts to give it maximum flexibility:
    
    The content is what should be shown, and can be a title, subtitle, sound, image, and so on.
    The trigger determines when the notification should be shown, and can be a number of seconds from now, a date and time in the future, or a location.
    The request combines the content and trigger, but also adds a unique identifier so you can edit or remove specific alerts later on. If you don’t want to edit or remove stuff, use UUID().uuidString to get a random identifier.
    When you’re just learning notifications the easiest trigger type to use is UNTimeIntervalNotificationTrigger, which lets us request a notification to be shown in a certain number of seconds from now. So, replace the // second comment with this:
    
    let content = UNMutableNotificationContent()
    content.title = "Feed the cat"
    content.subtitle = "It looks hungry"
    content.sound = UNNotificationSound.default
    
    // show this notification five seconds from now
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    
    // choose a random identifier
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    // add our notification request
    UNUserNotificationCenter.current().add(request)
    If you run your app now, press the first button to request notification permission, then press the second to add an actual notification.
    
    Now for the important part: once your notification has been added press Cmd+L in the simulator to lock the screen. After a few seconds have passed the device should wake up with a sound, and show our message – nice!
    """
    
    var body: some View {
        VStack {
            Button("Request Permission") {
                // First request notification pernission
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
            .padding()
            Button("Schedule Notification") {
                // Second schedule notification
                let content = UNMutableNotificationContent()
                content.title = "Feed the cat"
                content.subtitle = "It looks hungry"
                content.sound = UNNotificationSound.default
                // Show this notification 5 secode from now
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                // Choose a random identifier
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                // Add our notification request
                UNUserNotificationCenter.current().add(request)
            }
            .padding()
            ScrollView {
                Text(info)
            }
            .padding()
        }
        .navigationTitle("Scheduling local notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
