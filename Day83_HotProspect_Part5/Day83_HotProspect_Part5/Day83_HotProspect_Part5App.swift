//
//  Day83_HotProspect_Part5App.swift
//  Day83_HotProspect_Part5
//
//  Created by Lee McCormick on 7/2/22.
//

import SwiftUI

@main
struct Day83_HotProspect_Part5App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 16, part 5
 There’s a classic computer science book called Structure and Interpretation of Computer Programs, and in the preface the authors write some important words: “programs must be written for people to read, and only incidentally for machines to execute.”

 It’s worth reading that a few times, because it has a massive impact on the way we write software. Why do we force ourselves to use data types when languages such as JavaScript let you mix and match strings, integers, and even arrays freely? Why do we add comments to our code? Why do we try to break things up into functions? Why do we have access control?

 All those and many more can be answered by that single quote: because our goal must always be to make our intent clear to ourselves and other developers. The CPU running our code doesn’t care about data types, comments, access control, and more, but if you want to write great software that is scalable, testable, and maintainable, you need to add some rules.

 We’re actually going to use some interesting access control today, relying on two Swift features that don’t get used nearly enough: the fileprivate access control, and custom access control for setters. As with many features these aren’t the kinds of things you’ll use every day, but it’s just one more skill to add to your growing collection and worth keeping around!

 Today you have three topics to work through, in which you’ll write the “Me” tab, scan a QR code, then add swipe actions to our app.

 - Generating and scaling up a QR code
 - Scanning QR codes with SwiftUI
 - Adding options with swipe actions
 */

/* Generating and scaling up a QR code
 Core Image lets us generate a QR code from any input string, and do so extremely quickly. However, there’s a problem: the image it generates is very small because it’s only as big as the pixels required to show its data. It’s trivial to make the QR code larger, but to make it look good we also need to adjust SwiftUI’s image interpolation. So, in this step we’re going to ask the user to enter their name and email address in a form, use those two pieces of information to generate a QR code identifying them, and scale up the code without making it fuzzy.

 We already have a simple MeView struct that we made as a placeholder earlier, so our first job will be to add a couple of text fields and their string bindings.

 First, add these two new pieces of state to hold a name and email address:

 @State private var name = "Anonymous"
 @State private var emailAddress = "you@yoursite.com"
 When it comes to the body of the view we’re going to use two text fields with large fonts, but this time we’re going to attach a small but useful modifier to the text fields called textContentType() – it tells iOS what kind of information we’re asking the user for. This should allow iOS to provide autocomplete data on behalf of the user, which makes the app nicer to use.

 Replace your current body with this:

 NavigationView {
     Form {
         TextField("Name", text: $name)
             .textContentType(.name)
             .font(.title)

         TextField("Email address", text: $emailAddress)
             .textContentType(.emailAddress)
             .font(.title)
     }
     .navigationTitle("Your code")
 }
 We’re going to use the name and email address fields to generate a QR code, which is a square collection of black and white pixels that can be scanned by phones and other devices. Core Image has a filter for this built in, and as you’ve learned how to use Core Image filters previously you’ll find this is very similar.

 First, we need to bring in all the Core Image filters using a new import:

 import CoreImage.CIFilterBuiltins
 Second, we need two properties to store an active Core Image context and an instance of Core Image’s QR code generator filter. So, add these two to MeView:

 let context = CIContext()
 let filter = CIFilter.qrCodeGenerator()
 Now for the interesting part: making the QR code itself. If you remember, working with Core Image filters requires us to provide some input data, then convert the output CIImage into a CGImage, then that CGImage into a UIImage. We’ll be following the same steps here, except:

 Our input for the filter will be a string, but the input for the filter is Data, so we need to convert that.
 If conversion fails for any reason we’ll send back the “xmark.circle” image from SF Symbols.
 If that can’t be read – which is theoretically possible because SF Symbols is stringly typed – then we’ll send back an empty UIImage.
 So, add this method to the MeView struct now:

 func generateQRCode(from string: String) -> UIImage {
     filter.message = Data(string.utf8)

     if let outputImage = filter.outputImage {
         if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
             return UIImage(cgImage: cgimg)
         }
     }

     return UIImage(systemName: "xmark.circle") ?? UIImage()
 }
 Isolating all that functionality in a method works really well in SwiftUI, because it means the code we put in the body property stays as simple as possible. In fact, we can just use Image(uiImage:) directly with a call to generateQRCode(from:), then scale it up to a sensible size onscreen – SwiftUI will make sure the method gets called every time name or emailAddress changes.

 In terms of the string to pass in to generateQRCode(from:), we’ll be using the name and email address entered by the user, separated by a line break. This is a nice and simple format, and it’s easy to reverse when it comes to scanning these codes later on.

 Add this new Image view directly below the second text field:

 Image(uiImage: generateQRCode(from: "\(name)\n\(emailAddress)"))
     .resizable()
     .scaledToFit()
     .frame(width: 200, height: 200)
 If you run the code you’ll see it works pretty well – you’ll see a default QR code, but you can also type into either of the two text fields to make the QR code change dynamically.

 However, take a close look at the QR code – do you notice how it’s fuzzy? This is because Core Image is generating a tiny image, and SwiftUI is trying to smooth out the pixels as we scale it up.

 Line art like QR codes and bar codes is a great candidate for disabling image interpolation. Try adding this modifier to the image to see what I mean:

 .interpolation(.none)
 Now the QR code will be rendered nice and sharp, because SwiftUI will just repeat pixels rather than try to blend them neatly. I would imagine cameras don’t care which gets used, but it looks better to users!
 */

/* Scanning QR codes with SwiftUI
 Scanning a QR code – or indeed any kind of visible code such as barcodes – can be done by Apple’s AVFoundation library. This doesn’t integrate into SwiftUI terribly smoothly, so to skip over a whole lot of pain I’ve packaged up a QR code reader into a Swift package that we can add and use directly inside Xcode.

 My package is called CodeScanner, and its available on GitHub under the MIT license at https://github.com/twostraws/CodeScanner – you’re welcome to inspect and/or edit the source code if you want. Here, though, we’re just going to add it to Xcode by following these steps:

 Go to File > Swift Packages > Add Package Dependency.
 Enter https://github.com/twostraws/CodeScanner as the package repository URL.
 For the version rules, leave “Up to Next Major” selected, which means you’ll get any bug fixes and additional features but not any breaking changes.
 Press Finish to import the finished package into your project.
 The CodeScanner package gives us one CodeScanner SwiftUI view to use, which can be presented in a sheet and handle code scanning in a clean, isolated way. I know I keep repeating myself, but I hope you can see the continuing theme: the best way to write SwiftUI is to isolate functionality in discrete methods and wrappers, so that all you expose to your SwiftUI layouts is clean, clear, and unambiguous.

 We already have a “Scan” button in ProspectsView, and we’re going to use that trigger QR scanning. So, start by adding this new @State property to ProspectsView:

 @State private var isShowingScanner = false
 Earlier we added some test functionality to the “Scan” button so we could insert some sample data, but we don’t need that any more because we’re about to scan real QR codes. So, replace the action code for the toolbar button with this:

 isShowingScanner = true
 When it comes to handling the result of the QR scanning, I’ve made the CodeScanner package do literally all the work of figuring out what the code is and how to send it back, so all we need to do here is catch the result and process it somehow.

 When the CodeScannerView finds a code, it will call a completion closure with a Result instance either containing details about the code that was found or an error saying what the problem was – perhaps the camera wasn’t available, or the camera wasn’t able to scan codes, for example. Regardless of what code or error comes back, we’re just going to dismiss the view; we’ll add more code shortly to do more work.

 Start by adding this new import near the top of ProspectsView.swift:

 import CodeScanner
 Now add this method to ProspectsView:

 func handleScan(result: Result<ScanResult, ScanError>) {
    isShowingScanner = false
    // more code to come
 }
 Before we show the scanner and try to handle its result, we need to ask the user for permission to use the camera:

 Go to your target’s configuration options under its Info tab.
 Right-click on an existing key and select Add Row.
 Select “Privacy - Camera Usage Description” for the key.
 For the value enter “We need to scan QR codes.”
 And now we’re ready to scan some QR codes! We already have the isShowingScanner state that determines whether to show a code scanner or not, so we can now attach a sheet() modifier to present our scanner UI.

 Creating a CodeScanner view takes three parameters:

 An array of the types of codes we want to scan. We’re only scanning QR codes in this app so [.qr] is fine, but iOS supports lots of other types too.
 A string to use as simulated data. Xcode’s simulator doesn’t support using the camera to scan codes, so CodeScannerView automatically presents a replacement UI so we can still test that things work. This replacement UI will automatically send back whatever we pass in as simulated data.
 A completion function to use. This could be a closure, but we just wrote the handleScan() method so we’ll use that.
 So, add this below the existing toolbar() modifier in ProspectsView:

 .sheet(isPresented: $isShowingScanner) {
     CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
 }
 That’s enough to get most of this screen working, but there is one last step: replacing the // more code to come comment in handleScan() with some actual functionality to process the data we found.

 If you recall, the QR codes we’re generating are a name, then a line break, then an email address, so if our scanning result comes back successfully then we can pull apart the code string into those components and use them to create a new Prospect. If code scanning failed, we’ll just print an error – you’re welcome to show some more interesting UI if you want!

 Replace the // more code to come comment with this:

 switch result {
 case .success(let result):
     let details = result.string.components(separatedBy: "\n")
     guard details.count == 2 else { return }

     let person = Prospect()
     person.name = details[0]
     person.emailAddress = details[1]

     prospects.people.append(person)
 case .failure(let error):
     print("Scanning failed: \(error.localizedDescription)")
 }
 Go ahead and run the code now. If you’re using the simulator you’ll see a test UI appear, and tapping anywhere will dismiss the view and send back our simulated data. If you’re using a real device you’ll see a permission message asking the user to allow camera use, and you grant that you’ll see a scanner view. To test out scanning on a real device, simultaneously launch the app in the simulator and switch to the Me tab – your phone should be able to scan the simulator screen on your computer.
 */

/* Adding options with swipe actions
 We need a way to move people between the Contacted and Uncontacted tabs, and the easiest thing to do is add a swipe action to the VStack in ProspectsView. This will allow users to swipe on any person in the list, then tap a single option to move them between the tabs.

 Now, remember that this view is shared in three places, so we need to make sure the swipe actions look correct no matter where it’s used. We could try and use a bunch of ternary conditional operators, but later on we’ll add a second button so the ternary operator approach won’t really help much. Instead, we’ll just wrap the button inside a simple condition – add this to the VStack now:

 .swipeActions {
     if prospect.isContacted {
         Button {
             prospect.isContacted.toggle()
         } label: {
             Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
         }
         .tint(.blue)
     } else {
         Button {
             prospect.isContacted.toggle()
         } label: {
             Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
         }
         .tint(.green)
     }
 }
 While the text for that is OK and the context menu displays correctly, the action doesn’t do anything. Well, that’s not strictly true: it does toggle the Boolean, but it doesn’t actually update the UI.

 This problem occurs because the people array in Prospects is marked with @Published, which means if we add or remove items from that array a change notification will be sent out. However, if we quietly change an item inside the array then SwiftUI won’t detect that change, and no views will be refreshed.

 To fix this, we need to tell SwiftUI by hand that something important has changed. So, rather than flipping a Boolean in ProspectsView, we are instead going to call a method on the Prospects class to flip that same Boolean while also sending a change notification out.

 Start by adding this method to the Prospects class:

 func toggle(_ prospect: Prospect) {
     objectWillChange.send()
     prospect.isContacted.toggle()
 }
 Important: You should call objectWillChange.send() before changing your property, to ensure SwiftUI gets its animations correct.

 Now you can replace the prospect.isContacted.toggle() action with this:

 prospects.toggle(prospect)
 If you run the app now you’ll see it works much better – scan a user, then bring up the context menu and tap its action to see the user move between the Contacted and Uncontacted tabs.

 We could leave it there, but there’s one more change I want to make. As you saw, changing isContacted directly causes problems, because although the Boolean has changed internally our UI has become stale. If we leave our code as-is, it’s possible we (or other developers) might forget about this problem and try to flip the Boolean directly from elsewhere, which will just cause more bugs.

 Swift can help us mitigate this problem by stopping us from modifying the Boolean outside of Prospects.swift. There’s a specific access control option called fileprivate, which means “this property can only be used by code inside the current file.” Of course, we still want to read that property, and so we can deploy another useful Swift feature: fileprivate(set), which means “this property can be read from anywhere, but only written from the current file” – the exact combination we need to make sure the Boolean is safe to use.

 So, modify the isContacted Boolean in Prospect to this:

 fileprivate(set) var isContacted = false
 It hasn’t affected our project here, but it does help keep us safe in the future. If you were wondering why we put the Prospect and Prospects classes in the same file, now you know!
 */
