//
//  EditView.swift
//  Day70_BucketList_Part3
//
//  Created by Lee McCormick on 5/21/22.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var location: Location
    /*
     That makes the code compile, but we have a second problem: when we’re done editing the location, how can we pass the new location data back? We could use something like @Binding to pass in a remote value, but that creates problems with our optional in ContentView – we want EditView to be bound to a real value rather than an optional value, because otherwise it would get confusing.
     
     We’re going to take simplest solution we can: we’ll require a function to call where we can pass back whatever new location we want. This means any other SwiftUI can send us some data, and get back some new data to process however we want.
     
     Start by adding this property to EditView:
     */
    var onSave: (Location) -> Void
    @State private var name: String
    @State private var description: String
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $name)
                    TextField("Description", text: $description)
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.id = UUID() // The problem here is that we told SwiftUI that two places were identical if their IDs were identical, and that isn’t true any more – when we update a marker so it has a different name, SwiftUI will compare the old marker and new one, see that their IDs are the same, and therefore not bother to change the map. The fix here is to make the id property mutable, like this:
                    newLocation.name = name
                    newLocation.description = description
                    onSave(newLocation) // Speaking of which, we need to update that Save button to create a new location with the modified details, and send it back with onSave():
                    dismiss()
                }
            }
        }
    }
    /*
     That code won’t compile, because we have a conundrum: what initial values should we use for the name and description properties? Previously we’ve used @State with initial values, but we can’t do that here – their initial values should come from what location is being passed in, so the user sees the saved data.
     
     The solution is to create a new initializer that accepts a location, and uses that to create State structs using the location’s data. This uses the same underscore approach we used when creating a fetch request inside an initializer, which allows us to create an instance of the property wrapper not the data inside the wrapper.
     */
    init(location: Location, onSave: @escaping (Location) -> Void) { // Remember, @escaping means the function is being stashed away for user later on, rather than being called immediately, and it’s needed here because the onSave function will get called only when the user presses Save.
        self.location = location
        self.onSave = onSave
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}
