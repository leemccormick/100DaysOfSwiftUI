//
//  AddressView.swift
//  Day76_Accessibility_WrapUp
//
//  Created by Lee McCormick on 6/9/22.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: Order
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.cupCakeOrder.name)
                TextField("Street Address", text: $order.cupCakeOrder.street)
                TextField("City", text: $order.cupCakeOrder.city)
                TextField("Zip", text: $order.cupCakeOrder.zip)
            }
            Section {
                NavigationLink {
                    CheckoutView(order: order)
                } label: {
                    Text("Check out")
                }
                .disabled(order.hasValidAddress == false)
            }
        }
        .navigationBarTitle("Delivery Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
