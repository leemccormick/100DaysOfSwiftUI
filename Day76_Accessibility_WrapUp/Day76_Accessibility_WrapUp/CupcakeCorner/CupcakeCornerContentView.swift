//
//  CupcakeCornerContentView.swift
//  Day76_Accessibility_WrapUp
//
//  Created by Lee McCormick on 6/9/22.
//

import SwiftUI

struct CupcakeCornerContentView: View {
    @StateObject private var order = Order()
    var body: some View {
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

struct CupcakeCornerContentView_Previews: PreviewProvider {
    static var previews: some View {
        CupcakeCornerContentView()
    }
}
