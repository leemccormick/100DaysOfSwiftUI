//
//  Day51_CupcakeCornerPart3App.swift
//  Day51_CupcakeCornerPart3
//
//  Created by Lee McCormick on 4/20/22.
//

import SwiftUI

@main
struct Day51_CupcakeCornerPart3App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/* Project 10, part 3
 Years ago, a company called Sun Microsystems came up with a slogan that was way ahead of its time: “the network is the computer.” Today it almost seems obvious: we rely on our phones, laptops, and even watches to stay connected wherever we are, so we get push messages, emails, tweets, and more delivered from across the world.

 Think about it: the iPhone we have today got its name from the iPod, which in turn got its name from the iMac – a product that launched way back in 1998. Ken Segall, the marketer who came up with the name “iMac”, specifically said the “I” stands for “internet”, because back in the 90s getting online was nothing like as easy as it is today.

 So, it’s no surprise that our iPhones – our internet phones – place networking at the very center of their existence, and so many apps become richer and more useful because of an almost guaranteed internet connection. Today, at last, you’re going to add networking to your own apps, and I hope you’re impressed by how easy iOS makes it for us!

 Today you have just two topics to work through, in which you’ll create a custom Codable implementation, then use URLSession to send and receive data over the internet.

 - Encoding an ObservableObject class
 - Sending and receiving orders over the internet
 
 That’s another app finished – don’t forget to share your progress with others!
 */

/* Encoding an ObservableObject class
 We’ve organized our code so that we have one Order object that gets shared between all our screens, which has the advantage that we can move back and forward between those screens without losing data. However, this approach comes with a cost: we’ve had to use the @Published property wrapper for the properties in the class, and as soon we did that we lost support for automatic Codable conformance.

 If you don’t believe me, just try modifying the definition of Order to include Codable, like this:

 class Order: ObservableObject, Codable {
 The build will now fail, because Swift doesn’t understand how to encode and decode published properties. This is a problem, because we want to submit the user’s order to an internet server, which means we need it as JSON – we need the Codable protocol to work.

 The fix here is to add Codable conformance by hand, which means telling Swift what should be encoded, how it should be encoded, and also how it should be decoded – converted back from JSON to Swift data.

 That first step means adding an enum that conforms to CodingKey, listing all the properties we want to save. In our Order class that’s almost everything – the only thing we don’t need is the static types property.

 So, add this enum to Order now:

 enum CodingKeys: CodingKey {
     case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
 }
 The second step requires us to write an encode(to:) method that creates a container using the coding keys enum we just created, then writes out all the properties attached to their respective key. This is just a matter of calling encode(_:forKey:) repeatedly, each time passing in a different property and coding key.

 Add this method to Order now:

 func encode(to encoder: Encoder) throws {
     var container = encoder.container(keyedBy: CodingKeys.self)

     try container.encode(type, forKey: .type)
     try container.encode(quantity, forKey: .quantity)

     try container.encode(extraFrosting, forKey: .extraFrosting)
     try container.encode(addSprinkles, forKey: .addSprinkles)

     try container.encode(name, forKey: .name)
     try container.encode(streetAddress, forKey: .streetAddress)
     try container.encode(city, forKey: .city)
     try container.encode(zip, forKey: .zip)
 }
 Because that method is marked with throws, we don’t need to worry about catching any of the errors that are thrown inside – we can just use try without adding catch, knowing that any problems will automatically propagate upwards and be handled elsewhere.

 Our final step is to implement a required initializer to decode an instance of Order from some archived data. This is pretty much the reverse of encoding, and even benefits from the same throws functionality:

 required init(from decoder: Decoder) throws {
     let container = try decoder.container(keyedBy: CodingKeys.self)

     type = try container.decode(Int.self, forKey: .type)
     quantity = try container.decode(Int.self, forKey: .quantity)

     extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
     addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)

     name = try container.decode(String.self, forKey: .name)
     streetAddress = try container.decode(String.self, forKey: .streetAddress)
     city = try container.decode(String.self, forKey: .city)
     zip = try container.decode(String.self, forKey: .zip)
 }
 It’s worth adding here that you can encode your data in any order you want – you don’t need to match the order in which properties are declared in your object.

 That makes our code fully Codable compliant: we’ve effectively bypassed the @Published property wrapper, reading and writing the values directly. However, it doesn’t make our code compile – in fact, we now get a completely different error back in ContentView.swift.

 The problem now is that we just created a custom initializer for our Order class, init(from:), and Swift wants us to use it everywhere – even in places where we just want to create a new empty order because the app just started.

 Fortunately, Swift lets us add multiple initializers to a class, so that we can create it in any number of different ways. In this situation, that means we need to write a new initializer that can create an order without any data whatsoever – it will rely entirely on the default property values we assigned.

 So, add this new initializer to Order now:

 init() { }
 Now our code is back to compiling, and our Codable conformance is complete. This means we’re ready for the final step: sending and receiving Order objects over the network.


 */

/* Sending and receiving orders over the internet
 iOS comes with some fantastic functionality for handling networking, and in particular the URLSession class makes it surprisingly easy to send and receive data. If we combine that with Codable to convert Swift objects to and from JSON, we can use a new URLRequest struct to configure exactly how data should be sent, accomplishing great things in about 20 lines of code.

 First, let’s create a method we can call from our Place Order button – add this to CheckoutView:

 func placeOrder() async {
 }
 Just like when we were downloading data using URLSession, uploading is also done asynchronously.

 Now modify the Place Order button to this:

 Button("Place Order") {
     placeOrder()
 }
 .padding()
 That code won’t work, and Swift will be fairly clear why: it calls an asynchronous function from a function that does not support concurrency. What it means is that our button expects to be able to run its action immediately, and doesn’t understand how to wait for something – even if wrote await placeOrder() it still wouldn’t work, because the button doesn’t want to wait.

 Previously I mentioned that onAppear() didn’t work with these asynchronous functions, and we needed to use the task() modifier instead. That isn’t an option here because we’re executing an action rather than just attaching modifiers, but Swift provides an alternative: we can create a new task out of thin air, and just like the task() modifier this will run any kind of asynchronous code we want.

 In fact, all it takes is placing our await call inside a task, like this:

 Button("Place Order") {
     Task {
         await placeOrder()
     }
 }
 And now we’re all set – that code will call placeOrder() asynchronously just fine. Of course, that function doesn’t actually do anything just yet, so let’s fix that now.

 Inside placeOrder() we need to do three things:

 Convert our current order object into some JSON data that can be sent.
 Tell Swift how to send that data over a network call.
 Run that request and process the response.
 The first of those is straightforward, so let’s get it out of the way. We’ve made the Order class conform to Codable, which means we can use JSONEncoder to archive it by adding this code to placeOrder():

 guard let encoded = try? JSONEncoder().encode(order) else {
     print("Failed to encode order")
     return
 }
 The second step means using a new type called URLRequest, which is like a URL except it gives us options to add extra information such as the type of request, user data, and more.

 We need to attach the data in a very specific way so that the server can process it correctly, which means we need to provide two extra pieces of data beyond just our order:

 The HTTP method of a request determines how data should be sent. There are several HTTP methods, but in practice only GET (“I want to read data”) and POST (“I want to write data”) are used much. We want to write data here, so we’ll be using POST.
 The content type of a request determines what kind of data is being sent, which affects the way the server treats our data. This is specified in what’s called a MIME type, which was originally made for sending attachments in emails, and it has several thousand highly specific options.
 So, the next code for placeOrder() will be to create a URLRequest object, then configure it to send JSON data using a HTTP POST request. We can then use that to upload our data using URLSession, and handle whatever comes back.

 Of course, the real question is where to send our request, and I don’t think you really want to set up your own web server in order to follow this tutorial. So, instead we’re going to use a really helpful website called https://reqres.in – it lets us send any data we want, and will automatically send it back. This is a great way of prototyping network code, because you’ll get real data back from whatever you send.

 Add this code to placeOrder() now:

 let url = URL(string: "https://reqres.in/api/cupcakes")!
 var request = URLRequest(url: url)
 request.setValue("application/json", forHTTPHeaderField: "Content-Type")
 request.httpMethod = "POST"
 That first line contains a force unwrap for the URL(string:) initializer, which means “this returns an optional URL, but please force it to be nonoptional.” Creating URLs from strings might fail because you inserted some gibberish, but here I hand-typed the URL so I can see it’s always going to be correct – there are no string interpolations in there that might cause problems.

 At this point we’re all set to make our network request, which we’ll do using a new method called URLSession.shared.upload() and the URL request we just made. So, go ahead and add this to placeOrder():

 do {
     let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
     // handle the result
 } catch {
     print("Checkout failed.")
 }
 Now for the important work: we need to read the result of our request for times when everything has worked correctly. If something went wrong – perhaps because there was no internet connection – then our catch block will be run, so we don’t have to worry about that here.

 Because we’re using the ReqRes.in, we’ll actually get back the same order we sent, which means we can use JSONDecoder to convert that back from JSON to an object.

 To confirm everything worked correctly we’re going to show an alert containing some details of our order, but we’re going to use the decoded order we got back from ReqRes.in. Yes, this ought to be identical to the one we sent, so if it isn’t it means we made a mistake in our coding.

 Showing an alert requires properties to store the message and whether it’s visible or not, so please add these two new properties to CheckoutView now:

 @State private var confirmationMessage = ""
 @State private var showingConfirmation = false
 We also need to attach an alert() modifier to watch that Boolean, and show an alert as soon as its true. Add this modifier below the navigation title modifiers in CheckoutView:

 .alert("Thank you!", isPresented: $showingConfirmation) {
     Button("OK") { }
 } message: {
     Text(confirmationMessage)
 }
 And now we can finish off our networking code: we’ll decode the data that came back, use it to set our confirmation message property, then set showingConfirmation to true so the alert appears. If the decoding fails – if the server sent back something that wasn’t an order for some reason – we’ll just print an error message.

 Add this final code to placeOrder(), replacing the // handle the result comment:

 let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
 confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
 showingConfirmation = true
 With that final code in place our networking code is complete, and in fact our app is complete too. If you try running it now you should be able to select the exact cakes you want, enter your delivery information, then press Place Order to see an alert appear!

 We’re done! Well, I’m done – you still have some challenges to complete!
 */
