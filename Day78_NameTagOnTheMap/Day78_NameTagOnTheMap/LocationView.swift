//
//  LocationView.swift
//  Day78_NameTagOnTheMap
//
//  Created by Lee McCormick on 6/24/22.
//

import SwiftUI
import MapKit

struct LocationView: View {
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    let nameTag: NameTagOnMap
    let nameTagDirectory = NameTagDirectory()
    
    var body: some View {
        VStack {
            VStack(alignment: .center, spacing: 20) {
                HStack {
                    Button() {
                        dismiss()
                    } label: {
                        Image(systemName: "homekit")
                    }
                    .frame(width: 30, height: 30, alignment: .leading)
                    Spacer()
                    Button() {
                        moc.delete(nameTag)
                        nameTagDirectory.delete(fileName: nameTag.wrappedPath)
                        try? moc.save()
                        dismiss()
                    } label: {
                        Image(systemName: "trash")
                    }
                    .frame(width: 30, height: 30, alignment: .trailing)
                }
                Image(uiImage: nameTagDirectory.load(fileName: nameTag.wrappedPath) ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 250, alignment: .center)
                    .clipShape(Rectangle())
                    .cornerRadius(6)
                Text("\(nameTag.wrappedName)")
                    .font(.headline)
            }
            .padding()
            .onAppear {
                mapRegion =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: nameTag.latitude, longitude: nameTag.longitude), span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5))
            }
            Map(coordinateRegion: $mapRegion, annotationItems: [nameTag]) { place in
                MapAnnotation(coordinate: place.coordinate) {
                    VStack(spacing: 0) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.caption)
                            .foregroundColor(.red)
                            .offset(x: 0, y: -5)
                        Text("You and \(nameTag.wrappedName) met here !")
                            .font(.callout)
                            .padding(5)
                            .background(Color(.white))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(nameTag: NameTagOnMap())
    }
}
