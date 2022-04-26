//
//  BindingView.swift
//  Day53_Bookworm_Part1
//
//  Created by Lee McCormick on 4/23/22.
//

import SwiftUI

struct PushButton: View {
    let title: String
    @Binding var isOn: Bool // To switch over to @Binding we need to make just two changes. First, in PushButton change its isOn property to this:
    var onColors = [Color.red, Color.yellow]
    var offColors = [Color(white: 0.6), Color(white: 0.4)]
    
    var body: some View {
        Button(title) {
            isOn.toggle()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: isOn ? onColors : offColors), startPoint: .top, endPoint: .bottom))
    }
}

struct BindingView: View {
    @State private var rememberMe = false
    var body: some View {
        VStack {
            Toggle("Remember Me Toggle", isOn: $rememberMe)
                .padding()
            PushButton(title: "Remember Me Modify Button", isOn: $rememberMe) // And second, in ContentView change the way we create the button to this:
                .padding()
            Text(rememberMe ? "ON" : "OFF")
                .font(.title.bold())
                .padding()
        }
        .navigationBarTitle("Using Binding")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BindingView_Previews: PreviewProvider {
    
    static var previews: some View {
        BindingView()
    }
}
