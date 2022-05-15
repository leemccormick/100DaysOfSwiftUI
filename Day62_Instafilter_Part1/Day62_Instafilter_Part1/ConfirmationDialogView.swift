//
//  ConfirmationDialogView.swift
//  Day62_Instafilter_Part1
//
//  Created by Lee McCormick on 5/14/22.
//

import SwiftUI

struct ConfirmationDialogView: View {
    @State private var showingConfirmation = false
    @State private var backgroundColor = Color.white
    let info =
    """
     Visually alerts and confirmation dialogs are very different: on iPhones, alerts appear in the center of the screen and must actively be dismissed by choosing a button, whereas confirmation dialogs slide up from the bottom, can contain multiple buttons, and can be dismissed by tapping on Cancel or by tapping outside of the options.
    
     Although they look very different, confirmation dialogs and alerts are created almost identically:
    
     - Both are created by attaching a modifier to our view hierarchy – alert() for alerts and confirmationDialog() for confirmation dialogs.
     - Both get shown automatically by SwiftUI when a condition is true.
     - Both can be filled with buttons to take various actions.
     - Both can have a second closure attached to provide an extra message.
    """
    var body: some View {
        VStack {
            Spacer()
            Text("Hello... Tapped To Pop up Confirmation Dialog !")
                .frame(width: 300, height: 100)
                .background(backgroundColor)
                .font(.headline.bold())
                .onTapGesture {
                    showingConfirmation = true
                }
                .confirmationDialog("Change Background", isPresented: $showingConfirmation) {
                    Button("🔴 Red") { backgroundColor = .red}
                    Button("🟢 Green") { backgroundColor = .green}
                    Button("🔵 Blue") { backgroundColor = .blue}
                    Button("🟡 Yellow") { backgroundColor = .yellow}
                    Button("🟣 Purple") { backgroundColor = .purple}
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Select a new color")
                }
            ScrollView {
                Text(info)
            }
            .padding()
            .background(backgroundColor)
        }
        .navigationTitle("Showing multiple options with confirmationDialog()")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ConfirmationDialogView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationDialogView()
    }
}

/*
 Just like alert(), we have a confirmationDialog() modifier that accepts two parameters: a binding that decides whether the dialog is currently presented or not, and a closure that provides the buttons that should be shown – usually provided as a trailing closure.
 
 We provide our confirmation dialog with a title and optionally also a message, then an array of buttons. These are stacked up vertically on the screen in the order you provide, and it’s generally a good idea to include a cancel button at the end – yes, you can cancel by tapping elsewhere on the screen, but it’s much better to give users the explicit option.
 */
