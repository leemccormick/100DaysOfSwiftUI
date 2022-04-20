//
//  ValidateFormView.swift
//  Day49_CupCakeCornerPart1
//
//  Created by Lee McCormick on 4/19/22.
//

import SwiftUI

struct ValidateFormView: View {
    @State private var username = ""
    @State private var email = ""
    var disableForm: Bool {
        username.count < 5 || email.count < 5
    }
    var body: some View {
        Form {
            Text("Validating and disabling forms")
                .font(.title.bold())
            Section {
                TextField("Username", text: $username)
                TextField("Email", text: $email)
            }
            
            Section {
                Button("Create account") {
                    print("Creating account…")
                }
            }
            // .disabled(username.isEmpty || email.isEmpty) // You might find that it’s worth spinning out your conditions into a separate computed property, such as this:
            .disabled(disableForm)
        }
    }
}

struct ValidateFormView_Previews: PreviewProvider {
    static var previews: some View {
        ValidateFormView()
    }
}
