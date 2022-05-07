//
//  ContentView.swift
//  Day57_CoreData_Part1
//
//  Created by Lee McCormick on 5/6/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                NavigationLink {
                    CoreDataIntroView()
                } label: {
                    Text("Core Data : Introduction")
                        .font(.headline.bold())
                        .padding()
                }
                NavigationLink {
                    SelfForEachView()
                } label: {
                    Text("Why does self work for ForEach?")
                        .font(.headline.bold())
                        .padding()
                }
                NavigationLink {
                    NSMOSubClassView()
                } label: {
                    Text("Creating NSManagedObject subclasses")
                        .font(.headline.bold())
                        .padding()
                }
                NavigationLink {
                    SaveMocView()
                } label: {
                    Text("Conditional saving of NSManagedObjectContext")
                        .font(.headline.bold())
                        .padding()
                }
                NavigationLink {
                    UniqueObjectView()
                } label: {
                    Text("Ensuring Core Data objects are unique using constraints")
                        .font(.headline.bold())
                        .padding()
                }
            }
            .navigationBarTitle("Day57 : CoreData Part 1")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
