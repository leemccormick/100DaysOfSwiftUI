//
//  RelationshipView.swift
//  Day58_CoreDataPart2
//
//  Created by Lee McCormick on 4/27/22.
//

import SwiftUI

struct RelationshipView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var countries: FetchedResults<Country>
    var body: some View {
        VStack {
        Text("One-to-many relationships with Core Data, SwiftUI, and @FetchRequest")
            .font(.title.bold())
            List { // As for the body of the view, we’re going to use a List with two ForEach views inside it: one to create a section for each country, and one to create the candy inside each country. This List will in turn go inside a VStack so we can add a button below to generate some sample data:
                ForEach(countries, id: \.self) { country in
                    Section(country.wrappedFullName) {
                        ForEach(country.candyArray, id: \.self) { candy in
                            Text(candy.wrappedName)
                        }
                    }
                }
            }
            Button("Add Examples") {
                let candy1 = Candy(context: moc)
                candy1.name = "Mars"
                candy1.origin = Country(context: moc)
                candy1.origin?.shortName = "UK"
                candy1.origin?.fullName = "United Kingdom"
                
                let candy2 = Candy(context: moc)
                candy2.name = "KitKat"
                candy2.origin = Country(context: moc)
                candy2.origin?.shortName = "UK"
                candy2.origin?.fullName = "United Kingdom"
                
                let candy3 = Candy(context: moc)
                candy3.name = "Twix"
                candy3.origin = Country(context: moc)
                candy3.origin?.shortName = "UK"
                candy3.origin?.fullName = "United Kingdom"
                
                let candy4 = Candy(context: moc)
                candy4.name = "Toblerone"
                candy4.origin = Country(context: moc)
                candy4.origin?.shortName = "CH"
                candy4.origin?.fullName = "Switzerland"
                
                try? moc.save()
            }
        }
    }
}

struct RelationshipView_Previews: PreviewProvider {
    static var previews: some View {
        RelationshipView()
    }
}

/*
 To demonstrate this, we’re going to build two Core Data entities: one to track candy bars, and one to track countries where those bars come from.

 Relationships come in four forms:

 A one to one relationship means that one object in an entity links to exactly one object in another entity. In our example, this would mean that each type of candy has one country of origin, and each country could make only one type of candy.
 A one to many relationship means that one object in an entity links to many objects in another entity. In our example, this would mean that one type of candy could have been introduced simultaneously in many countries, but that each country still could only make one type of candy.
 A many to one relationship means that many objects in an entity link to one object in another entity. In our example, this would mean that each type of candy has one country of origin, and that each country can make many types of candy.
 A many to many relationship means that many objects in an entity link to many objects in another entity. In our example, this would mean that one type of candy had been introduced simultaneously in many countries, and each country can make many types of candy.
 All of those are used at different times, but in our candy example the many to one relationship makes the most sense – each type of candy was invented in a single country, but each country can have invented many types of candy.
 
 Before we’re done with this data model, we need to tell Core Data there’s a one-to-many relationship between Candy and Country:

 With Country selected, press + under the Relationships table. Call the relationship “candy”, change its destination to Candy, then over in the data model inspector change Type to To Many.
 Now select Candy, and add another relationship there. Call the relationship “origin”, change its destination to “Country”, then set its inverse to “candy” so Core Data understands the link goes both ways.
 */
