//
//  CheckoutView.swift
//  Day52_CupcakeCornerWrapup
//
//  Created by Lee McCormick on 4/21/22.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    @State private var showConfimationMessage = false
    @State private var confirmationMessage = ""
    @State private var isSuccessToSendOrderToServer = false
    var body: some View {
        VStack {
            AsyncImage(url: (URL(string: "https://hws.dev/img/cupcakes@3x.jpg")), scale: 0.3)  { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 240)
            Text("Your total is : \(order.cost, format: .currency(code:"USD"))")
                .font(.title)
            Button("Place Order") {
                Task {
                    await placeOrder()
                }
            }
            .padding()
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isSuccessToSendOrderToServer ? "Thank you!" : "Check out failed !", isPresented: $showConfimationMessage) {
            Button("OK") {}
        } message: {
            Text(confirmationMessage)
        }
    }
    func placeOrder() async {
        guard let enconded = try? JSONEncoder().encode(order.cupCakeOrder) else {
            print("Failed to encoded order")
            return
        }
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: enconded)
            let decoded =  try JSONDecoder().decode(CupCakeOrder.self, from: data)
            confirmationMessage = "Your order for \(decoded.quantity) x \(order.types[decoded.type].lowercased()) cupcakes is on its way!"
            showConfimationMessage = true
            isSuccessToSendOrderToServer = true
        } catch {
            print("Check out failed.")
            confirmationMessage = "Unable to place an order please try again later."
            showConfimationMessage = true
            isSuccessToSendOrderToServer = false // Challenge 2 : If our call to placeOrder() fails then show an informative alert for the user.
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
