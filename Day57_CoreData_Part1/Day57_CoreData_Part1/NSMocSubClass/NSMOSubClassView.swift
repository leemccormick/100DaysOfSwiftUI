//
//  NSMOSubClassView.swift
//  Day57_CoreData_Part1
//
//  Created by Lee McCormick on 5/7/22.
//

import SwiftUI

struct NSMOSubClassView: View {
    let createObjectSubclass =
"""
When we create a new Core Data entity, Xcode automatically generates a managed object class for us when we build our code. We can then use that in a SwiftUI @FetchRequest to show data in our user interface, but as you’ve seen it’s quite painful: there are lots of optionals to unwrap, so you need to scatter nil coalescing around in order to make your code work.

There are two solutions to this: a fast and easy one that can sometimes end up being problematic, or a slightly slower solution that works better in the long term.

First, let’s create an entity to work with: open your data model and create an entity called Movie with the attributes “title” (string), “director” (string), and “year” (an integer 16). Before you leave the data model editor, I’d like you to go to the View menu and choose Inspectors > Show Data Model Inspector, which brings up a pane on the right of Xcode containing more information about whatever you have selected right now.

When you select Movie you’ll see a variety of data model options for that entity, but there’s one in particular I’d like you to look at: “Codegen”. This controls how Xcode generates the entity as a managed object class when we build our project, and by default it will be Class Definition. I’d like to change that to Manual/None, which gives us full control over how the class is made.

Now that Xcode is no longer generating a Movie class for us to use in code, we can’t use it in code unless we actually make the class with some real Swift code. To do that, go to the Editor menu and choose Create NSManagedObject Subclass, make sure “CoreDataProject” is selected then press Next, then make sure Movie is selected and press Next again. You’ll be asked where Xcode should save its code, so please make sure you choose “CoreDataProject” with a yellow folder icon on its left, and select the CoreDataProject folder too. When you’re ready, press Create to finish the process.

What we just did was ask Xcode to convert its generated code into actual Swift files that we can see and change, although keep in mind if you change the files Xcode generated for us then re-generate those files, your changes will be lost.

Xcode will have generated two files for us, but we only care about one of them: Movie+CoreDataProperties.swift. Inside there you’ll see these three lines of code:

@NSManaged public var title: String?
@NSManaged public var director: String?
@NSManaged public var year: Int16
In that tiny slice of code you can see three things:

This is where our optional problem stems from.
year is not optional, which means Core Data will assume a default value for us.
It uses @NSManaged on all three properties.
@NSManaged is not a property wrapper – this is much older than property wrappers in SwiftUI. Instead, this reveals a little of how Core Data works internally: rather than those values actually existing as properties in the class, they are really just there to read and write from a dictionary that Core Data uses to store its information. When we read or write the value of a property that is @NSManaged, Core Data catches that and handles it internally – it’s far from a simple Swift string.

Now, you might look at that code and think “I don’t want optionals there,” and change it to this:

@NSManaged public var title: String
@NSManaged public var director: String
@NSManaged public var year: Int16
And you know what? That will absolutely work. You can make Movie objects with just the same code as before, use fetch requests to query them, save their managed object contexts, and more, all with no problems.

However, you might notice something strange: even though our properties aren’t optional any more, it’s still possible to create an instance of the Movie class without providing those values. This ought to be impossible: these properties aren’t optional, which means they must have values all the time, and yet we can create them without values.

What’s happening here is a little of that @NSManaged magic leaking out – remember, these aren’t real properties, and as a result @NSManaged is letting us do things that ought not to work. The fact that it does work is neat, and for small Core Data projects and/or learners I think removing the optionality is a great idea. However, there’s a deeper problem: Core Data is lazy.

Remember Swift’s lazy keyword, and how it lets us delay work until we actually need it? Core Data does much the same thing, except with data: sometimes it looks like some data has been loaded when it really hasn’t been because Core Data is trying to minimize its memory impact. Core Data calls these faults, in the sense of a “fault line” – a line between where something exists and where something is just a placeholder.

We don’t need to do any special work to handle these faults, because as soon as we try to read them Core Data transparently fetches the real data and sends it back – another benefit of @NSManaged. However, when we start futzing with the types of Core Data’s properties we risk exposing its peculiar underbelly. This thing specifically does not work the way Swift expects, and if we try to circumvent that then we’re pretty much inviting problems – values we’ve said definitely won’t be nil might suddenly be nil at any point.

Instead, you might want to consider adding computed properties that help us access the optional values safely, while also letting us store your nil coalescing code all in one place. For example, adding this as a property on Movie ensures that we always have a valid title string to work with:

public var wrappedTitle: String {
    title ?? "Unknown Title"
}
This way the whole rest of your code doesn’t have to worry about Core Data’s optionality, and if you want to make changes to default values you can do it in a single file.
"""
    
    var body: some View {
        ScrollView {
        Text("Creating NSManagedObject subclasses")
            .font(.title)
        Text(createObjectSubclass)
            .font(.body)
        }
    }
}

struct NSMOSubClassView_Previews: PreviewProvider {
    static var previews: some View {
        NSMOSubClassView()
    }
}
