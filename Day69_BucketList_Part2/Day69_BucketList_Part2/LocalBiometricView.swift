//
//  LocalBiometricView.swift
//  Day69_BucketList_Part2
//
//  Created by Lee McCormick on 5/21/22.
//
/*
 Before we write any code, you need to add a new key to your project options, explaining to the user why you want access to Face ID. For reasons known only to Apple, we pass the Touch ID request reason in code, and the Face ID request reason in project options.
 
 So, select your current target, go to the Info tab, right-click on an existing key, then choose Add Row. Scroll through the list of keys until you find “Privacy - Face ID Usage Description” and give it the value “We need to unlock your data.”
 */
import LocalAuthentication
import SwiftUI

struct LocalBiometricView: View {
    let info = """
    I mentioned earlier this was “only a little bit unpleasant”, and here’s where it comes in: Swift developers use the Error protocol for representing errors that occur at runtime, but Objective-C uses a special class called NSError. We need to be able to pass that into the function and have it changed inside the function rather than returning a new value – although this was the standard in Objective-C, it’s quite an alien way of working in Swift so we need to mark this behavior specially by using &.
    
    We’re going to write an authenticate() method that isolates all the biometric functionality in a single place. To make that happen requires four steps:
    
    1) Create instance of LAContext, which allows us to query biometric status and perform the authentication check.
    2) Ask that context whether it’s capable of performing biometric authentication – this is important because iPod touch has neither Touch ID nor Face ID.
    3) If biometrics are possible, then we kick off the actual request for authentication, passing in a closure to run when authentication completes.
    4) When the user has either been authenticated or not, our completion closure will be called and tell us whether it worked or not, and if not what the error was.
    """
    @State private var isUnlocked = false
    var body: some View {
        VStack {
            if isUnlocked {
                ScrollView {
                    Text("Unlocked With Biometric")
                        .font(.headline.bold())
                        .padding()
                    Text(info)
                        .padding()
                }
            } else {
                Text("Locked Data Until Authorize With Biometric...")
            }
        }
        .onAppear(perform: authenticate)
        .navigationTitle("Using Touch ID and Face ID with SwiftUI")
        .navigationBarTitleDisplayMode(.inline)
    }
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // It's possible, so go ahead and use it
            let reason = "We need to unlock your data."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    // authenticated successfully
                    isUnlocked = true
                } else {
                    // there was a problem
                    isUnlocked = false
                }
            }
        } else {
            // no biometrics
            isUnlocked = false
        }
    }
}

struct LocalBiometricView_Previews: PreviewProvider {
    static var previews: some View {
        LocalBiometricView()
    }
}
