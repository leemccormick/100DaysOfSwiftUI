//
//  EditCardsView.swift
//  Day91_Flashzilla_WrapUp
//
//  Created by Lee McCormick on 7/11/22.
//

import SwiftUI

// MARK: - EditCardsView
struct EditCardsView: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm : CardsDocumentDirectoryController
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $vm.newPrompt)
                    TextField("Answer", text: $vm.newAnswer)
                    Button("Add Card", action: vm.addCard)
                }
                Section {
                    ForEach(0..<vm.cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(vm.cards[index].prompt)
                                .font(.headline)
                            Text(vm.cards[index].answer)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: vm.removeCards)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done") { dismiss() }
            }
            .listStyle(.grouped)
        }
    }
}

// MARK: - PreviewProvider
struct EditCardsView_Previews: PreviewProvider {
    static var previews: some View {
        EditCardsView()
    }
}
