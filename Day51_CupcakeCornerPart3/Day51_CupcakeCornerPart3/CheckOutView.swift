//
//  CheckOutView.swift
//  Day51_CupcakeCornerPart3
//
//  Created by Lee McCormick on 4/20/22.
//

import SwiftUI

struct CheckOutView: View {
    @ObservedObject var order: Order
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                Button("Place Order") {
                    // Previously I mentioned that onAppear() didn’t work with these asynchronous functions, and we needed to use the task() modifier instead. That isn’t an option here because we’re executing an action rather than just attaching modifiers, but Swift provides an alternative: we can create a new task out of thin air, and just like the task() modifier this will run any kind of asynchronous code we want. In fact, all it takes is placing our await call inside a task, like this:
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check Out")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") {}
        } message: {
            Text(confirmationMessage)
        }
    }
    
    // iOS comes with some fantastic functionality for handling networking, and in particular the URLSession class makes it surprisingly easy to send and receive data. If we combine that with Codable to convert Swift objects to and from JSON, we can use a new URLRequest struct to configure exactly how data should be sent, accomplishing great things in about 20 lines of code.
    func placeOrder() async {
        // 1) Convert our current order object into some JSON data that can be sent.
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        // 2) Tell Swift how to send that data over a network call.
        // 2.1) The HTTP method of a request determines how data should be sent. There are several HTTP methods, but in practice only GET (“I want to read data”) and POST (“I want to write data”) are used much. We want to write data here, so we’ll be using POST.
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        // 2.2) The content type of a request determines what kind of data is being sent, which affects the way the server treats our data. This is specified in what’s called a MIME type, which was originally made for sending attachments in emails, and it has several thousand highly specific options.
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        // 3) Run that request and process the response.
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decoded = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decoded.quantity) x \(Order.types[decoded.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
        } catch  {
            print("Checkout failed")
        }
    }
}

struct CheckOutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckOutView(order: Order())
    }
}
