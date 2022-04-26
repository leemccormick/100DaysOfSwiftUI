//
//  ContentView.swift
//  Day52_CupcakeCornerWrapup
//
//  Created by Lee McCormick on 4/21/22.
//

import SwiftUI
/* Challenge
 1) Our address fields are currently considered valid if they contain anything, even if it’s just only whitespace. Improve the validation to make sure a string of pure whitespace is invalid.
 2) If our call to placeOrder() fails – for example if there is no internet connection – show an informative alert for the user. To test this, try commenting out the request.httpMethod = "POST" line in your code, which should force the request to fail.
 3) For a more challenging task, see if you can convert our data model from a class to a struct, then create an ObservableObject class wrapper around it that gets passed around. This will result in your class having one @Published property, which is the data struct inside it, and should make supporting Codable on the struct much easier.
 */
struct ContentView: View {
    @StateObject private var order = Order()
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.cupCakeOrder.type) {
                        ForEach(order.types.indices) {
                            Text(order.types[$0])
                        }
                    }
                    Stepper("Number of cakes : \(order.cupCakeOrder.quantity)", value: $order.cupCakeOrder.quantity, in: 3...20)
                }
                Section {
                    Toggle("Any special requests?", isOn: $order.cupCakeOrder.specialRequest)
                    if order.cupCakeOrder.specialRequest {
                        Toggle("Any extra frosting?", isOn: $order.cupCakeOrder.extraFrosting)

                        Toggle("Any special sprinkles?", isOn: $order.cupCakeOrder.specialSprinkles)
                    }
                }
                Section {
                    NavigationLink {
                        AddressView(order: order)
                    } label : {
                        Text("Delivery Details")
                    }
                }
            }
            .navigationTitle("CupCake Corner WrapUp")
        }
     
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
