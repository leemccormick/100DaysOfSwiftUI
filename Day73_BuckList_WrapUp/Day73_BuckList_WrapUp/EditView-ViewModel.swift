//
//  EditView-ViewModel.swift
//  Day73_BuckList_WrapUp
//
//  Created by Lee McCormick on 5/26/22.
//

import Foundation
import MapKit

/* Challenge 3 : Create another view model, this time for EditView. What you put in the view model is down to you, but I would recommend leaving dismiss and onSave in the view itself – the former uses the environment, which can only be read by the view, and the latter doesn’t really add anything when moved into the model.
 */

extension EditView {
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @MainActor class ViewModel : ObservableObject {
        var location: Location
        @Published  var name: String
        @Published  var description: String
        @Published  var loadingState = LoadingState.loading
        @Published  var pages : [Page] = []
        
        init(location: Location) {
            self.location = location
            _name = Published(initialValue: location.name)
            _description = Published(initialValue: location.description)
        }
        
        func createNewLocation() -> Location {
            var newLocation = location
            newLocation.id = UUID()
            newLocation.name = name
            newLocation.description = description
            return newLocation
        }
        
        func fetchNearbyPlaces() async {
            let urlString  = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            guard let url = URL(string: urlString) else {
                print("Bad URL : \(urlString)")
                return }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let items = try JSONDecoder().decode(Result.self, from: data)
                pages = items.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }
        }
    }
}
