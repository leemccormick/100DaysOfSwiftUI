//
//  Day57_CoreData_Part1App.swift
//  Day57_CoreData_Part1
//
//  Created by Lee McCormick on 5/6/22.
//

import SwiftUI

@main
struct Day57_CoreData_Part1App: App {
    @StateObject private var datacontroller = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, datacontroller.container.viewContext)
        }
    }
}

/* Project 12, part 1
 In this technique project we’re going to explore how Core Data and SwiftUI work together to help us build great apps. I already introduced you to the topic in project 11, but here we’re going to be going into more detail: custom managed object subclasses, ensuring uniqueness, and more.

 American entrepreneur Jim Rohn once said, “success is neither magical nor mysterious – success is the natural consequence of consistently applying the basic fundamentals.” Core Data is absolutely one of those basic fundamentals – you certainly won’t use it in every project, but understanding how it works and how to make the most of it will make you a better app developer.

 Today you have five topics to work through, in which you’ll learn how \.self works, how to save a managed object context only when needed, how to ensure objects are unique, and more.

 - Core Data: Introduction
 - Why does \.self work for ForEach?
 - Creating NSManagedObject subclasses
 - Conditional saving of NSManagedObjectContext
 - Ensuring Core Data objects are unique using constraints
 */

/* Core Data: Introduction
 This technique project is going to explore Core Data in more detail, starting with a summary of some basic techniques then building up to tackling some more complex problems.

 When you’re working with Core Data, please try to keep in mind that it has been around for a long time – it was designed way before Swift existed, never mind SwiftUI, so occasionally you’ll meet parts that don’t work quite as well in Swift as we might hope. Hopefully we’ll see this improve over the years ahead, but in the meantime be patient!

 We have lots of Core Data to explore, so please create a fresh project where we can try it out. Call it “CoreDataProject” and not just “CoreData” because that will cause Xcode to get confused.

 Make sure you do not check the “Use Core Data” box. Instead, please copy DataController.swift from your Bookworm project, make a new, empty Data Model called CoreDataProject.xcdatamodeld, then update CoreDataProjectApp.swift to create a DataController instance and inject it into the SwiftUI environment. This will leave you where we started in the early stages of the Bookworm project.

 Important: As you’re copying DataController from Bookworm to this new project, the data model file has changed – make sure you change NSPersistentContainer initializer to refer to the new data model file rather than Bookworm.

 As you progress, you might sometimes find that Xcode will ignore changes made in the Core Data editor, so I like to drive the point home by pressing Cmd+S before going to another file. Failing that, restart Xcode!

 All set? Let’s go!

 Tip: Sometimes you’ll see a heading titled “Want to go further?” This contains some bonus examples that help take your knowledge further, but you don’t need to follow here unless you want to – think of it as extra credit.
 */

/* Why does \.self work for ForEach?
 Previously we looked at the various ways ForEach can be used to create dynamic views, but they all had one thing in common: SwiftUI needs to know how to identify each dynamic view uniquely so that it can animate changes correctly.

 If an object conforms to the Identifiable protocol, then SwiftUI will automatically use its id property for uniquing. If we don’t use Identifiable, then we can use a keypath for a property we know to be unique, such as a book’s ISBN number. But if we don’t conform to Identifiable and don’t have a keypath that is unique, we can often use \.self.

 Previously we used \.self for primitive types such as Int and String, like this:

 List {
     ForEach([2, 4, 6, 8, 10], id: \.self) {
         Text("\($0) is even")
     }
 }
 With Core Data we can use a unique identifier if we want, but we can also use \.self and also have something that works well.

 When we use \.self as an identifier, we mean “the whole object”, but in practice that doesn’t mean much – a struct is a struct, so it doesn’t have any sort of specific identifying information other than its contents. So what actually happens is that Swift computes the hash value of the struct, which is a way of representing complex data in fixed-size values, then uses that hash as an identifier.

 Hash values can be generated in any number of ways, but the concept is identical for all hash-generating functions:

 Regardless of the input size, the output should be the same fixed size.
 Calculating the same hash for an object twice in a row should return the same value.
 Those two sound simple, but think about it: if we get the hash of “Hello World” and the hash of the complete works of Shakespeare, both will end up being the same size. This means it’s not possible to convert the hash back into its original value – we can’t convert 40 seemingly random hexadecimal letters and numbers into the complete works of Shakespeare.

 Hashes are commonly used for things like data verification. For example, if you download a 8GB zip file, you can check that it’s correct by comparing your local hash of that file against the server’s – if they match, it means the zip file is identical. Hashes are also used with dictionary keys and sets; that’s how they get their fast look up.

 All this matters because when Xcode generates a class for our managed objects, it makes that class conform to Hashable, which is a protocol that means Swift can generate hash values for it, which in turn means we can use \.self for the identifier. This is also why String and Int work with \.self: they also conform to Hashable.

 Hashable is a bit like Codable: if we want to make a custom type conform to Hashable, then as long as everything it contains also conforms to Hashable then we don’t need to do any work. To demonstrate this, we could create a custom struct that conforms to Hashable rather than Identifiable, and use \.self to identify it:

 struct Student: Hashable {
     let name: String
 }

 struct ContentView: View {
     let students = [Student(name: "Harry Potter"), Student(name: "Hermione Granger")]

     var body: some View {
         List(students, id: \.self) { student in
             Text(student.name)
         }
     }
 }
 We can make Student conform to Hashable because all its properties already conform to Hashable, so Swift will calculate the hash values of each property then combine them into one hash that represents the whole struct. Of course, if we end up with two students that have the same name we’ll hit problems, just like if we had an array of strings with two identical strings.

 Now, you might think this leads to a problem: if we create two Core Data objects with the same values, they’ll generate the same hash, and we’ll hit animation problems. However, Core Data does something really smart here: the objects it creates for us actually have a selection of other properties beyond those we defined in our data model, including one called the object ID – an identifier that is unique to that object, regardless of what properties it contains. These IDs are similar to UUID, although Core Data generates them sequentially as we create objects.

 So, \.self works for anything that conforms to Hashable, because Swift will generate the hash value for the object and use that to uniquely identify it. This also works for Core Data’s objects because they already conform to Hashable. So, if you want to use a specific identifier that’s awesome, but you don’t need to because \.self is also an option.

 Warning: Although calculating the same hash for an object twice in a row should return the same value, calculating it between two runs of your app – i.e., calculating the hash, quitting the app, relaunching, then calculating the hash again – can return different values.
 */

/* Creating NSManagedObject subclasses
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
 */

/* Conditional saving of NSManagedObjectContext
 We’ve been using the save() method of NSManagedObjectContext to flush out all unsaved changes to permanent storage, but what we haven’t done is check whether any changes actually need to be saved. This is often OK, because it’s common to place save() calls only after we specifically made a change such as inserting or deleting data.

 However, it’s also common to bulk your saves together so that you save everything at once, which has a lower performance impact. In fact, Apple specifically states that we should always check for uncommitted changes before calling save(), to avoid making Core Data do work that isn’t required.

 Fortunately, we can check for changes in two ways. First, every managed object is given a hasChanges property, that is true when the object has unsaved changes. And, the entire context also contains a hasChanges property that checks whether any object owned by the context has changes.

 So, rather than call save() directly you should always wrap it in a check first, like this:

 if moc.hasChanges {
     try? moc.save()
 }
 It’s a small change to make, but it matters – there’s no point doing work that isn’t needed, no matter how small, particularly because if you do enough small work you realize you’ve stacked up some big work.
 */

/* Ensuring Core Data objects are unique using constraints
 By default Core Data will add any object you want, but this can get messy very quickly, particularly if you know two or more objects don’t make sense at the same time. For example, if you stored details of contacts using their email address, it wouldn’t make sense to have two or three different contacts attached to the same email address.

 To help resolve this, Core Data gives us constraints: we can make one attribute constrained so that it must always be unique. We can then go ahead and make as many objects as we want, unique or otherwise, but as soon as we ask Core Data to save those objects it will resolve duplicates so that only one piece of data gets written. Even better, if there was some data already written that clashes with our constraint, we can choose how it should handle merging the data.

 To try this out, create a new entity called Wizard, with one string attribute called “name”. Now select the Wizard entity, look in the data model inspector for Constraints, and press the + button directly below. You should see “comma,separated,properties” appear, giving us an example to work from. Select that and press enter to rename it, and give it the text “name” instead – that makes our name attribute unique. Remember to press Cmd+S to save your change!

 Now go over to ContentView.swift and give it this code:

 struct ContentView: View {
     @Environment(\.managedObjectContext) var moc

     @FetchRequest(sortDescriptors: []) var wizards: FetchedResults<Wizard>

     var body: some View {
         VStack {
             List(wizards, id: \.self) { wizard in
                 Text(wizard.name ?? "Unknown")
             }

             Button("Add") {
                 let wizard = Wizard(context: moc)
                 wizard.name = "Harry Potter"
             }

             Button("Save") {
                 do {
                     try moc.save()
                 } catch {
                     print(error.localizedDescription)
                 }
             }
         }
     }
 }
 You can see that has a list for showing wizards, one button for adding wizards, and a second button for saving. When you run the app you’ll find that you can press Add multiple times to see “Harry Potter” slide into the table, but when you press “Save” we get an error instead – Core Data has detected the collision and is refusing to save the changes.

 If you want Core Data to write the changes, you need to open DataController.swift and adjust the loadPersistentStores() completion handler to specify how data should be merged in this situation:

 container.loadPersistentStores { description, error in
     if let error = error {
         print("Core Data failed to load: \(error.localizedDescription)")
         return
     }

     self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
 }
 That asks Core Data to merge duplicate objects based on their properties – it tries to intelligently overwrite the version in its database using properties from the new version. If you run the code again you’ll see something quite brilliant: you can press Add as many times as you want, but when you press Save it will all collapse down into a single row because Core Data strips out the duplicates.
 */
