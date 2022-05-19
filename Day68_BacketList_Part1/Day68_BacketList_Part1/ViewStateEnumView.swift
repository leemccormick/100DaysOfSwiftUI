//
//  ViewStateEnumView.swift
//  Day68_BacketList_Part1
//
//  Created by Lee McCormick on 5/19/22.
//

import SwiftUI

// There are two parts to this solution. The first is to define an enum for the various view states you want to represent. For example, you might define this as a nested enum:
enum LoadingState {
    case loading, success, failed
}

struct LoadingView: View {
    var body: some View {
        Text("Loading...")
    }
}

struct SuccessView: View {
    var body: some View {
        Text("Success!")
    }
}

struct FailedView: View {
    var body: some View {
        Text("Failed.")
    }
}

struct ViewStateEnumView: View {
    var loadingState = LoadingState.loading // With those two parts in place, we now effectively use ContentView as a simple wrapper that tracks the current app state and shows the relevant child view. That means giving it a property to store the current LoadingState value:
    
    var body: some View {
        Form {
            Section {
                if Bool.random() {
                    Rectangle()
                } else {
                    Circle()
                }
            }
            Section {
                if loadingState == .loading {
                    LoadingView()
                } else if loadingState == .success {
                    SuccessView()
                } else if loadingState == .failed {
                    FailedView()
                }
            }
        }
        .navigationTitle("Switching view states with enums")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ViewStateEnumView_Previews: PreviewProvider {
    static var previews: some View {
        ViewStateEnumView()
    }
}
