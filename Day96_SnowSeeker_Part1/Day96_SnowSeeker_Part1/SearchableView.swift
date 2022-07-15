//
//  SearchableView.swift
//  Day96_SnowSeeker_Part1
//
//  Created by Lee McCormick on 7/15/22.
//

import SwiftUI

// MARK: - SearchableView
struct SearchableView: View {
    let topic = "Making a SwiftUI view searchable"
    let info =
    """
    iOS can add a search bar to our views using the searchable() modifier, and we can bind a string property to it to filter our data as the user types.
    
    To see how this works, try this simple example:
    
    struct ContentView: View {
        @State private var searchText = ""
    
        var body: some View {
            NavigationView {
                Text("Searching for \'(searchText)")
                    .searchable(text: $searchText, prompt: "Look for something")
                    .navigationTitle("Searching")
            }
        }
    }
    Important: You need to make sure your view is inside a NavigationView, otherwise iOS won’t have anywhere to put the search box.
    
    When you run that code example, you should see a search bar you can type into, and whatever you type will be shown in the view below.
    
    In practice, searchable() is best used with some kind of data filtering. Remember, SwiftUI will reinvoke your body property when an @State property changes, so you could use a computed property to handle the actual filtering:
    
    struct ContentView: View {
        @State private var searchText = ""
        let allNames = ["Subh", "Vina", "Melvin", "Stefanie"]
    
        var body: some View {
            NavigationView {
                List(filteredNames, id: \'.self) { name in
                    Text(name)
                }
                .searchable(text: $searchText, prompt: "Look for something")
                .navigationTitle("Searching")
            }
        }
    
        var filteredNames: [String] {
            if searchText.isEmpty {
                return allNames
            } else {
                return allNames.filter { $0.contains(searchText) }
            }
        }
    }
    When you run that, iOS will automatically hide the search bar at the very top of the list – you’ll need to pull down gently to reveal it, which matches the way other iOS apps work. iOS doesn’t require that we make our lists searchable, but it really makes a huge difference to users!
    
    Tip: Rather than using contains() here, you probably want to use another method with a much longer name: localizedCaseInsensitiveContains(). That lets us check any part of the search strings, without worrying about uppercase or lowercase letters.
    """
    // MARK: - Properties
    @State private var searchText = ""
    let allNames = ["Subh", "Vina", "Melvin", "Stefanie"]
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                // Topic
                Text(topic).font(.largeTitle).padding()
                /* Search Example With Text
                 Text("Searching for \(searchText)")
                 .searchable(text: $searchText, prompt: "Look for something")
                 .navigationTitle("Searching")
                 */
                
                // Search Example With List
                List(filteredName, id: \.self) { name in
                    Text(name)
                }
                .searchable(text: $searchText, prompt: "Look for something")
                .navigationTitle("Searching")
                
                // Info
                ScrollView {
                    Text(info).font(.body).padding()
                }
            }
        }
    }
    
    // MARK: - filteredName
    var filteredName: [String] {
        if searchText.isEmpty {
            return allNames
        } else {
            return allNames.filter {$0.localizedCaseInsensitiveContains(searchText)}
            // == allNames.filter {$0.contains(searchText)} -->  But this code is not coverd the case sensitive
        }
    }
}

// MARK: - PreviewProvider
struct SearchableView_Previews: PreviewProvider {
    static var previews: some View {
        SearchableView()
    }
}
