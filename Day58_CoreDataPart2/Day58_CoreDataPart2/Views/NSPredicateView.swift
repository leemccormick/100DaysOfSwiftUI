//
//  NSPredicateView.swift
//  Day58_CoreDataPart2
//
//  Created by Lee McCormick on 4/27/22.
//

import SwiftUI

struct NSPredicateView: View {
    let predicateInfo =
    """
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "universe == 'Star Wars'")) var ships: FetchedResults<Ship>
    That gets complicated if your data includes quote marks, so it’s more common to use special syntax instead: `%@‘ means “insert some data here”, and allows us to provide that data as a parameter to the predicate rather than inline.

    So, we could instead write this:

    NSPredicate(format: "universe == %@", "Star Wars"))
    As well as ==, we can also use comparisons such as < and > to filter our objects. For example this will return Defiant, Enterprise, and Executor:

    NSPredicate(format: "name < %@", "F"))
    %@ is doing a lot of work behind the scenes, particularly when it comes to converting native Swift types to their Core Data equivalents. For example, we could use an IN predicate to check whether the universe is one of three options from an array, like this:

    NSPredicate(format: "universe IN %@", ["Aliens", "Firefly", "Star Trek"])
    We can also use predicates to examine part of a string, using operators such as BEGINSWITH and CONTAINS. For example, this will return all ships that start with a capital E:

    NSPredicate(format: "name BEGINSWITH %@", "E"))
    That predicate is case-sensitive; if you want to ignore case you need to modify it to this:

    NSPredicate(format: "name BEGINSWITH[c] %@", "e"))
    CONTAINS[c] works similarly, except rather than starting with your substring it can be anywhere inside the attribute.

    Finally, you can flip predicates around using NOT, to get the inverse of their regular behavior. For example, this finds all ships that don’t start with an E:

    NSPredicate(format: "NOT name BEGINSWITH[c] %@", "e"))
    If you need more complicated predicates, join them using AND to build up as much precision as you need, or add an import for Core Data and take a look at NSCompoundPredicate – it lets you build one predicate out of several smaller ones.
    """
    @Environment(\.managedObjectContext) var moc
    // NSPredicate(format: "universe == 'Star Wars'"))
    // NSPredicate(format: "universe == %@", "Star Wars"))
    // NSPredicate(format: "name < %@", "F"))
    // NSPredicate(format: "universe IN %@", ["Aliens", "FireFly", "Star Trek"]))
    // NSPredicate(format: "name BEGINSWITH %@", "E"))
    // NSPredicate(format: "name BEGINSWITH[c] %@", "e"))
    // NSPredicate(format: "name CONTAINS[c] %@", "c"))
    // NSPredicate(format: "NOT name CONTAINS[c] %@", "c"))
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "NOT name CONTAINS[c] %@", "c")) var ships: FetchedResults<Ship>
    
    var body: some View {
        VStack {
        Text("Filtering @FetchRequest using NSPredicate")
            .font(.title.bold())
            List(ships, id: \.self) { ship in
                Text(ship.name ?? "Unknown name")
            }
            Button("Add Example") {
                let ship1 = Ship(context: moc)
                ship1.name = "Enterprise"
                ship1.universe = "Star Trek"
                
                let ship2 = Ship(context: moc)
                ship2.name = "Defiant"
                ship2.universe = "Star Trek"
                
                let ship3 = Ship(context: moc)
                ship3.name = "Millennium Falcon"
                ship3.universe = "Star Wars"
                
                let ship4 = Ship(context: moc)
                ship4.name = "Executor"
                ship4.universe = "Star Wars"
                try? moc.save()
            }
            NavigationLink {
                Text(predicateInfo)
            } label : {
                Text("Example using NSPredicate")
            }
        }
    }
}

struct NSPredicateView_Previews: PreviewProvider {
    static var previews: some View {
        NSPredicateView()
    }
}

