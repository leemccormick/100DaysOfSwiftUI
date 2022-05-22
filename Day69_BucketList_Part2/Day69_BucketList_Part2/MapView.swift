//
//  MapView.swift
//  Day69_BucketList_Part2
//
//  Created by Lee McCormick on 5/21/22.
//
import MapKit
import SwiftUI

// To do this takes at least three steps depending on your goal: defining a new data type that contains your location, creating an array of those containing all your locations, then adding them as annotations in the map. Whatever new data type you create to store locations, it must conform to the Identifiable protocol so that SwiftUI can identify each map marker uniquely.
struct Location : Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)) // That centers on the city of London. Both sets of latitude and longitude are measured in degrees, but in practice longitude changes in its underlying value as you move further away from the equator so it might take a little experimentation to find a starting value you like.
    let locations = [
        Location(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
        Location(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
    ]
    var body: some View {
        // Map(coordinateRegion: $mapRegion)
        
        Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
            /* Step three is the important part: we can feed that array of locations into the Map view, as well as providing a function that transforms one location into a visible annotation on the map. SwiftUI provides us with a couple of different annotation types, but the simplest is MapMarker: a simple balloon with a latitude/longitude coordinate attached.
             // MapMarker(coordinate: location.coordinate)
             So, we could replace the balloons with stroked red circles like this: */
            MapAnnotation(coordinate: location.coordinate) {
                NavigationLink {
                    Text(location.name)
                } label: {
                    Circle()
                        .stroke(.red, lineWidth: 3)
                        .frame(width: 44, height: 44)
                    /*  .onTapGesture {
                     print("Tapped on \(location.name)")
                     } */
                }
            }
        }
        .navigationTitle("Integrating MapKit with SwiftUI")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
