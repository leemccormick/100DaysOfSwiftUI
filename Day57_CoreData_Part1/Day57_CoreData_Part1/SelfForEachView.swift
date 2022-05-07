//
//  SelfForEachView.swift
//  Day57_CoreData_Part1
//
//  Created by Lee McCormick on 5/7/22.
//

import SwiftUI

struct Student: Hashable { // We can make Student conform to Hashable because all its properties already conform to Hashable, so Swift will calculate the hash values of each property then combine them into one hash that represents the whole struct. Of course, if we end up with two students that have the same name we’ll hit problems, just like if we had an array of strings with two identical strings.
    let name: String
}

struct SelfForEachView: View {
    let students = [Student(name: "Lee"), Student(name: "Donny")]
    var body: some View {
        Form {
            Text("Why does self work for ForEach?")
                .font(.title.bold())
            List {
                ForEach([2,4,6,8,10], id: \.self) {
                    Text("\($0) is even")
                }
            }
            List {
                ForEach(students, id: \.self) { // Now, you might think this leads to a problem: if we create two Core Data objects with the same values, they’ll generate the same hash, and we’ll hit animation problems. However, Core Data does something really smart here: the objects it creates for us actually have a selection of other properties beyond those we defined in our data model, including one called the object ID – an identifier that is unique to that object, regardless of what properties it contains. These IDs are similar to UUID, although Core Data generates them sequentially as we create objects. So, \.self works for anything that conforms to Hashable, because Swift will generate the hash value for the object and use that to uniquely identify it. This also works for Core Data’s objects because they already conform to Hashable. So, if you want to use a specific identifier that’s awesome, but you don’t need to because \.self is also an option.
                    Text($0.name)
                }
            }
        }
    }
}

struct SelfForEachView_Previews: PreviewProvider {
    static var previews: some View {
        SelfForEachView()
    }
}
