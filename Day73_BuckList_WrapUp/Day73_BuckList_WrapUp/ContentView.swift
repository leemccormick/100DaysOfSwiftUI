//
//  ContentView.swift
//  Day73_BuckList_WrapUp
//
//  Created by Lee McCormick on 5/24/22.
//

import SwiftUI
import MapKit

/*
 *** Challenge ***
 1) Our + button is rather hard to tap. Try moving all its modifiers to the image inside the button – what difference does it make, and can you think why?
 2) Our app silently fails when errors occur during biometric authentication, so add code to show those errors in an alert.
 3) Create another view model, this time for EditView. What you put in the view model is down to you, but I would recommend leaving dismiss and onSave in the view itself – the former uses the environment, which can only be read by the view, and the latter doesn’t really add anything when moved into the model.
 */

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    var body: some View {
        if viewModel.isUnlocked {
            ZStack {
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        VStack {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(Circle())
                            Text(location.name)
                                .fixedSize()
                        }
                        .onTapGesture {
                            viewModel.selectedLocation = location
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
                        Button {
                            viewModel.addLocation()
                        } label : {
                            // Challenge 1 : Our + button is rather hard to tap. Try moving all its modifiers to the image inside the button – what difference does it make, and can you think why?
                            Image(systemName: "plus")
                                .padding()
                                .background(.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding(.trailing)
                        }
                    }
                }
            }
            .sheet(item: $viewModel.selectedLocation) { location in
                EditView(location: location) { newLocation in
                    viewModel.update(location: newLocation)
                }
            }
        } else {
            Button("Unlock Places With Biometric") {
                viewModel.authenticate()
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            // Challenge 2 : Our app silently fails when errors occur during biometric authentication, so add code to show those errors in an alert.
            .alert("Failed To Authenticate Biometric!",isPresented: $viewModel.showAlertBiometricFailed) {
                Button("OK", role: .cancel) { }
            }
        }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
