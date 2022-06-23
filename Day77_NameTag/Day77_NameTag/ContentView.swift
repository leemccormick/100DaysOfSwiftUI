//
//  ContentView.swift
//  Day77_NameTag
//
//  Created by Lee McCormick on 6/18/22.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    @State private var showAddNameView = false
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)])
    var cachedNameTags: FetchedResults<NameTag>
    var nameTagDirectory = NameTagDirectory()
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(cachedNameTags) { nt in
                        VStack {
                            Image(uiImage: nameTagDirectory.load(fileName: nt.wrappedPath) ?? UIImage())
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100, alignment: .center)
                                .clipShape(Rectangle())
                                .cornerRadius(6)
                            Text("\(nt.wrappedName)")
                                .font(.headline)
                        }
                        .onTapGesture {
                            moc.delete(nt)
                            nameTagDirectory.delete(fileName: nt.wrappedPath)
                            try? moc.save()
                        }
                    }
                }
            }
            .navigationTitle("Day77 : Name Tag")
            .toolbar {
                Button() {
                    showAddNameView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showAddNameView) {
                AddNameTagView()
            }
        }
    }
}

// MARK: - PreviewProvider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
