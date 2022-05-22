//
//  Day70_BucketList_Part3App.swift
//  Day70_BucketList_Part3
//
//  Created by Lee McCormick on 5/21/22.
//

import SwiftUI

@main
struct Day70_BucketList_Part3App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
/* Project 14, part 3
 It’s time to start putting all our techniques into practice, which means building a map view where we can add and interact with annotations. As we progress, I’d like you to reflect a little on how our app benefits from all the standard design affordances that come with iOS, and what means for our users – they already know how to use maps, and how to tap on markers to activate functionality,

 Years ago, Steve Jobs said “design is not just what it looks like and feels like; design is how it works.” Users know how our map works because it works just like every other map on iOS. This means they can get on board with our app fast, and means we can focus on directing them towards the part of our app that’s unique and interesting.

 Today you have three topics to work through, in which we take a really deep dive into integrating MapKit with SwiftUI.

 - Adding user locations to a map
 - Improving our map annotations
 - Selecting and editing map annotations
 */

/* Adding user locations to a map
 This project is going to be based around a map view, asking users to add places to the map that they want to visit. To do that we need to place a Map so that it takes up our whole view, track its center coordinate, and then also whether or not the user is viewing place details, what annotations they have, and more.

 We’re going to start with a full-screen Map view, then place a translucent circle on top to represent the center point. Although this view will have a binding to track the center coordinate, we don’t need to use that to place the circle – a simple ZStack will make sure the circle always stays in the center of the map.

 First, add an extra import line so we get access to MapKit’s data types:

 import MapKit
 Second, add a property inside ContentView that will store the current state of the map. Later on we’re going to use this to add a place mark:

 @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
 That starts the map so that most of Western Europe and North Africa are visible.

 And now we can fill in the body property

 ZStack {
     Map(coordinateRegion: $mapRegion)
         .ignoresSafeArea()
     Circle()
         .fill(.blue)
         .opacity(0.3)
         .frame(width: 32, height: 32)
 }
 If you run the app now you’ll see you can move the map around freely, but there’s always a blue circle showing exactly where the center is.

 All this work by itself isn’t terribly interesting, so the next step is to add a button in the bottom-right that lets us add place marks to the map. We’re already inside a ZStack, so the easiest way to align this button is to place it inside a VStack and a HStack with spacers before it each time. Both those spacers end up occupying the full vertical and horizontal space that’s left over, making whatever comes at the end sit comfortably in the bottom-right corner.

 We’ll add some functionality for the button soon, but first let’s get it in place and add some basic styling to make it look good.

 Please add this VStack below the Circle:

 VStack {
     Spacer()
     HStack {
         Spacer()
         Button {
             // create a new location
         } label: {
             Image(systemName: "plus")
         }
         .padding()
         .background(.black.opacity(0.75))
         .foregroundColor(.white)
         .font(.title)
         .clipShape(Circle())
         .padding(.trailing)
     }
 }
 Notice how I added the padding() modifier twice there – once is to make sure the button is bigger before we add a background color, and the second time to push it away from the trailing edge.

 Where things get interesting is how we place locations on the map. We’ve bound the location of the map to a property in ContentView, but now we need to send in an array of locations we want to show.

 This takes a few steps, starting with a basic definition of the type of locations we’re creating in our app. This needs to conform to a few protocols:

 Identifiable, so we can create many location markers in our map.
 Codable, so we can load and save map data easily.
 Equatable, so we can find one particular location in an array of locations.
 In terms of the data it will contain, we’ll give each location a name and description, plus a latitude and longitude. We’ll also need to add a unique identifier so SwiftUI is happy to create them from dynamic data.

 So, create a new Swift file called Location.swift, giving it this code:

 struct Location: Identifiable, Codable, Equatable {
     let id: UUID
     var name: String
     var description: String
     let latitude: Double
     let longitude: Double
 }
 Storing latitude and longitude separately gives us Codable conformance out of the box, which is always nice to have. We’ll add a little more to that shortly, but it’s enough to get us moving.

 Now that we have a data type where we can store an individual location, we need an array of those to store all the places the user wants to visit. We’ll put this into ContentView for now just we can get moving, but again we’ll return to it shortly to add more.

 So, start by adding this property to ContentView:

 @State private var locations = [Location]()
 Next, we want to add a location to that whenever the + button is tapped, so replace the // create a new location comment with this:

 let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
 locations.append(newLocation)
 Finally, update ContentView so that it sends in the locations array to be converted into annotations:

 Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
     MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
 }
 .ignoresSafeArea()
 That’s enough map work for now, so go ahead and run your app again – you should be able to move around as much as you need, then press the + button to add locations.

 I know it took a fair amount of work to get set up, but at least you can see the basics of the app coming together!
 */

/* Improving our map annotations
 Right now we’re using MapMarker to place locations in our Map view, but SwiftUI lets us place any kind of view on top of our map so we can have complete customizability. So, we’re going to use that to show a custom SwiftUI view containing an icon and some text to show the location’s name, then take a look at the underlying data type to see what improvements can be made there.

 Thanks to the brilliance of SwiftUI, this takes hardly any code at all – replace your existing MapMarker code with this:

 MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
     VStack {
         Image(systemName: "star.circle")
             .resizable()
             .foregroundColor(.red)
             .frame(width: 44, height: 44)
             .background(.white)
             .clipShape(Circle())

         Text(location.name)
     }
 }
 That’s already an immediate improvement, because now it’s clear what each marker represents – the location name appears directly underneath. However, I want to look beyond just the SwiftUI view: I want to look at the Location struct itself, and apply a few improvements that make it better.

 First, I don’t particularly like having to make a CLLocationCoordinate2D inside our SwiftUI view, and I’d much prefer to move that kind of logic inside our Location struct. So, we can move that into a computed property to clean up our code. First, add an import for MapKit into Location.swift, then add this to Location:

 var coordinate: CLLocationCoordinate2D {
     CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
 }
 Now our ContentView code is simpler:

 MapAnnotation(coordinate: location.coordinate) {
 The second change I want to make is one I encourage everyone to make when building custom data types for use with SwiftUI: add an example! This makes previewing significantly easier, so where possible I would encourage you to add a static example property to your types containing some sample data that can be previewed well.

 So, add this second property to Location now:

 static let example = Location(id: UUID(), name: "Buckingham Palace", description: "Where Queen Elizabeth lives with her dorgis.", latitude: 51.501, longitude: -0.141)
 The last change I’d like to make here is to add a custom == function to the struct. We already made Location conform to Equatable, which means we can already compare one location to another using ==. Behind the scenes, Swift will write this function for us by comparing every property against every other property, which is rather wasteful – all our locations already have a unique identifier, so if two locations have the same identifier then we can be sure they are the same without also checking the other properties.

 So, we can save a bunch of work by writing our own == function to Location, which compares two identifiers and nothing else:

 static func ==(lhs: Location, rhs: Location) -> Bool {
     lhs.id == rhs.id
 }
 I’m a huge fan of making structs conform to Equatable as standard, even if you can’t use an optimized comparison function like above – structs are simple values like strings and integers, and I think we should extend that same status to our own custom structs too.

 With that in place the next step of our project is complete, so please run it now – you should be able to drop a marker and see our custom annotation, but now behind the scenes know that our code is a little bit neater too!
 */

/* Selecting and editing map annotations
 Users can now drop markers onto our SwiftUI Map, but they can’t do anything with them – they can’t attach their own name and description. Fixing this requires a few steps, and learning a couple of things along the way, but it really brings the whole app together as you’ll see.

 First, we want to show some kind of sheet when the user selects a map annotation, giving them the chance to view or edit details about a location.

 The way we’ve tackled sheets previously has meant creating a Boolean that determines whether the sheet is visible, then sending in some other data for the sheet to present or edit. This time, though, we’re going to take a different approach: we’re going to handle it all with one property.

 So, add this to ContentView now:

 @State private var selectedPlace: Location?
 What we’re saying is that we might have a selected location, or we might not – and that’s all SwiftUI needs to know in order to present a sheet. As soon as we place a value into that optional we’re telling SwiftUI to show the sheet, and the value will automatically be set back to nil when the sheet is dismissed. Even better, SwiftUI automatically unwraps the optional for us, so when we’re creating the contents of our sheet we can be sure we have a real value to work with.

 To try it out, attach this modifier to the ZStack in ContentView:

 .sheet(item: $selectedPlace) { place in
     Text(place.name)
 }
 As you can see, it takes an optional binding, but also a function that will receive the unwrapped optional when it has a value set. So, inside there our sheet can refer to place.name directly rather than needing to unwrap the optional or use nil coalescing.

 Now to bring the whole thing to life, we just need to give selectedPlace a value by adding a tap gesture to the VStack in our map annotation:

 .onTapGesture {
     selectedPlace = location
 }
 That’s it! We can now present a sheet showing the selected location’s name, and it only took a small amount of code. This kind of optional binding isn’t always possible, but I think where it is possible it makes for much more natural code – SwiftUI’s behavior of unwrapping the optional automatically is really helpful.

 Of course, just showing the place’s name isn’t too useful, so the next step here is to create a detail view where used can see and adjust a location’s name and description. This needs to receive a location to edit, allow the user to adjust the two values for that location, then will send back a new location with that tweaked data – it will effectively work like a function, receiving data and sending back something transformed.

 As always we’re going to start small and work our way up, so please create a new SwiftUI view called “EditView” then give it this code:

 struct EditView: View {
     @Environment(\.dismiss) var dismiss
     var location: Location

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
                     dismiss()
                 }
             }
         }
     }
 }
 That code won’t compile, because we have a conundrum: what initial values should we use for the name and description properties? Previously we’ve used @State with initial values, but we can’t do that here – their initial values should come from what location is being passed in, so the user sees the saved data.

 The solution is to create a new initializer that accepts a location, and uses that to create State structs using the location’s data. This uses the same underscore approach we used when creating a fetch request inside an initializer, which allows us to create an instance of the property wrapper not the data inside the wrapper.

 So, to solve our problem we need to add this initializer to EditView:

 init(location: Location) {
     self.location = location

     _name = State(initialValue: location.name)
     _description = State(initialValue: location.description)
 }
 You’ll need to modify your preview code to use that initializer:

 static var previews: some View {
     EditView(location: Location.example)
 }
 That makes the code compile, but we have a second problem: when we’re done editing the location, how can we pass the new location data back? We could use something like @Binding to pass in a remote value, but that creates problems with our optional in ContentView – we want EditView to be bound to a real value rather than an optional value, because otherwise it would get confusing.

 We’re going to take simplest solution we can: we’ll require a function to call where we can pass back whatever new location we want. This means any other SwiftUI can send us some data, and get back some new data to process however we want.

 Start by adding this property to EditView:

 var onSave: (Location) -> Void
 That asks for a function that accepts a single location and returns nothing, which is perfect for our usage. We need to accept that in our initializer, like this:

 init(location: Location, onSave: @escaping (Location) -> Void) {
     self.location = location
     self.onSave = onSave

     _name = State(initialValue: location.name)
     _description = State(initialValue: location.description)
 }
 Remember, @escaping means the function is being stashed away for user later on, rather than being called immediately, and it’s needed here because the onSave function will get called only when the user presses Save.

 Speaking of which, we need to update that Save button to create a new location with the modified details, and send it back with onSave():

 Button("Save") {
     var newLocation = location
     newLocation.name = name
     newLocation.description = description

     onSave(newLocation)
     dismiss()
 }
 By taking a variable copy of the original location, we get access to its existing data – it’s identifier, latitude, and longitude.

 Don’t forget to update your preview code too – just passing in a placeholder closure is fine here:

 EditView(location: Location.example) { newLocation in }
 That completes EditView for now, but there’s still some work to do back in ContentView because we need to present the new UI in our sheet, send in the location that was selected, and also handle updating changes.

 Well, thanks to the way we’ve built our code this only takes a handful of lines of code – place this into the sheet() modifier in ContentView:

 EditView(location: place) { newLocation in
     if let index = locations.firstIndex(of: place) {
         locations[index] = newLocation
     }
 }
 So, that passes the location into EditView, and also passes in a closure to run when the Save button is pressed. That accepts the new location, then looks up where the current location is and replaces it in the array. This will cause our map to update immediately with the new data.

 Go ahead and give the app a try – see if you spot a problem with our code. Hopefully it’s rather glaring: renaming doesn’t actually work!

 The problem here is that we told SwiftUI that two places were identical if their IDs were identical, and that isn’t true any more – when we update a marker so it has a different name, SwiftUI will compare the old marker and new one, see that their IDs are the same, and therefore not bother to change the map.

 The fix here is to make the id property mutable, like this:

 var id: UUID
 And now we can adjust that when we create new locations:

 var newLocation = location
 newLocation.id = UUID()
 newLocation.name = name
 newLocation.description = description
 There is no hard and fast rule for when it’s better to make a wholly new object from scratch, or just copy an existing one and change the bits you want like we’re doing here; I encourage you to experiment and find an approach you like.

 Anyway, with that you can now run your code again. Sure, it doesn’t save any data yet, but you can now add as many locations as you want and give them meaningful names.

 There is one last thing, though, and it’s entirely possible this might not exist in a future SwiftUI update so try it for yourself: right now I find that giving a location a short name such as “Home”, then changing it to have a long name such as “This is my home”, will cause its label to be clipped until you interact with the map.

 We can fix this with a new modifier called fixedSize(), which forces any view to be given its natural size rather than try to accommodate the amount of space offered by its parent. In this case, the MapAnnotation doesn’t do a great job of handling resizing children, which causes the clipping, but fixedSize() lets us bypass that so the text automatically grows into as much space as needed.

 So, to finish up this step please modify your map annotation content to this:

 Text(location.name)
     .fixedSize()
 It’s a small change, and again hopefully it will get resolved in a future SwiftUI release, but it solves our problem for now.
 */
