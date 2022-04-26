//
//  MultilineInputView.swift
//  Day53_Bookworm_Part1
//
//  Created by Lee McCormick on 4/23/22.
//

import SwiftUI

struct MultilineInputView: View {
    // Mostly because it has nothing special in the way of configuration options, using TextEditor is actually easier than using TextField – you can’t adjust its style or add placeholder text, you just bind it to a string. However, you do need to be careful to make sure it doesn’t go outside the safe area, otherwise typing will be tricky; embed it in a NavigationView, a Form, or similar. For example, we could create the world’s simplest notes app by combining TextEditor with @AppStorage, like this:
    @AppStorage("notes") private var notes = "" // Important: @AppStorage writes your data to UserDefaults, which is not secure storage. As a result, you should not save any personal data using @AppStorage, because it’s relatively easy to extract.
    var body: some View {
        NavigationView {
            TextEditor(text: $notes)
                .navigationTitle("Notes Multiline Input View")
                .navigationBarTitleDisplayMode(.inline)
                .padding()
        }
    }
}

struct MultilineInputView_Previews: PreviewProvider {
    static var previews: some View {
        MultilineInputView()
    }
}
