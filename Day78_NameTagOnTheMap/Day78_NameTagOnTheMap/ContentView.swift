//
//  ContentView.swift
//  Day78_NameTagOnTheMap
//
//  Created by Lee McCormick on 6/23/22.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    @State private var showAddNameView = false
    @State private var showLocationView = false
    @State private var selectedNameTag: NameTagOnMap?
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)])
    var cachedNameTags: FetchedResults<NameTagOnMap>
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
                            showLocationView = true
                            selectedNameTag = nt
                        }
                    }
                }
            }
            .navigationTitle("Day78 : Name Tag On Map")
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
            .sheet(isPresented: $showLocationView) {
                if let nameTag = selectedNameTag {
                    LocationView(nameTag: nameTag)
                }
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
