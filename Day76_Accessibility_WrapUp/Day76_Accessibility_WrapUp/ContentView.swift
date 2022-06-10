//
//  ContentView.swift
//  Day76_Accessibility_WrapUp
//
//  Created by Lee McCormick on 6/9/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                NavigationLink {
                    CupcakeCornerContentView()
                } label: {
                    Text("Cupcake Corner")
                }
                NavigationLink {
                    iExpenseContentView()
                } label: {
                    Text("iExpense")
                }
                NavigationLink {
                    MoonshotContentView()
                } label: {
                    Text("Moonshot")
                }
            }
            .navigationTitle("Day76 : Accessibilily Wrap Up")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
