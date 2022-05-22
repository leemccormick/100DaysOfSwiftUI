//
//  ContentView.swift
//  Day70_BucketList_Part3
//
//  Created by Lee McCormick on 5/21/22.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    @State private var locations = [Location]()
    @State private var selectedPlace: Location? // What we’re saying is that we might have a selected location, or we might not – and that’s all SwiftUI needs to know in order to present a sheet. As soon as we place a value into that optional we’re telling SwiftUI to show the sheet, and the value will automatically be set back to nil when the sheet is dismissed. Even better, SwiftUI automatically unwraps the optional for us, so when we’re creating the contents of our sheet we can be sure we have a real value to work with.
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
                // MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) { ==> Before adding computed property
                MapAnnotation(coordinate: location.coordinate) {
                    VStack {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(Circle())
                        Text(location.name)
                            .fixedSize() // We can fix this with a new modifier called fixedSize(), which forces any view to be given its natural size rather than try to accommodate the amount of space offered by its parent. In this case, the MapAnnotation doesn’t do a great job of handling resizing children, which causes the clipping, but fixedSize() lets us bypass that so the text automatically grows into as much space as needed.
                    }
                    .onTapGesture { // That’s it! We can now present a sheet showing the selected location’s name, and it only took a small amount of code. This kind of optional binding isn’t always possible, but I think where it is possible it makes for much more natural code – SwiftUI’s behavior of unwrapping the optional automatically is really helpful.
                        selectedPlace = location
                    }
                }
            }
            .ignoresSafeArea()
            Circle()
                .fill(.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        // Create a new location
                        let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
                        locations.append(newLocation)
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
        }
        .sheet(item: $selectedPlace) { place in // place is the unwrap place ==> As you can see, it takes an optional binding, but also a function that will receive the unwrapped optional when it has a value set. So, inside there our sheet can refer to place.name directly rather than needing to unwrap the optional or use nil coalescing.
            // Text(place.name)
            // So, that passes the location into EditView, and also passes in a closure to run when the Save button is pressed. That accepts the new location, then looks up where the current location is and replaces it in the array. This will cause our map to update immediately with the new data.
            EditView(location: place) { newLocation in
                if let index = locations.firstIndex(of: place) {
                    locations[index] = newLocation
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
