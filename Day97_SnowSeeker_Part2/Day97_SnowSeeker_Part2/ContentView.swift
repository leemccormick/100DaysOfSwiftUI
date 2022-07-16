//
//  ContentView.swift
//  Day97_SnowSeeker_Part2
//
//  Created by Lee McCormick on 7/15/22.
//

import SwiftUI

// MARK: - View Extension
// Although UIKit lets us control whether the primary view should be shown on iPad portrait, this is not yet possible in SwiftUI. However, we can stop iPhones from using the slide over approach if that’s what you want – try it first and see what you think. If you want it gone, add this extension to your project:
extension View {
    // That uses Apple’s UIDevice class to detect whether we are currently running on a phone or a tablet, and if it’s a phone enables the simpler StackNavigationViewStyle approach. We need to use the @ViewBuilder attribute here because the two returned view types are different.
    @ViewBuilder func phoneOnlyNavigationView() -> some View { // ViewBuilder --> Return different kind of view
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        }
    }
}

// MARK: - ContentView
struct ContentView: View {
    // MARK: - Properties
    let resorts: [Resort] = Bundle.main.decode("resorts.json") // Load from bundle
    @State private var searchText = ""
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            //List(resorts) { resort in --> Use filteredResort instead
            List(filteredResorts) { resort in // Using filteredResort from searchable
                NavigationLink {
                    // Text(resort.name) --> Use ResortView() instead
                    ResortView(resort: resort)
                } label: {
                    Image(resort.country)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 25)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.black, lineWidth: 1)
                        )
                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                        Text("\(resort.runs) runs")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Resorts")
            .searchable(text: $searchText, prompt: "Search for a resort")
            WelcomeView()
        }
        // .phoneOnlyNavigationView() --> Once you have that extension, simply add the .phoneOnlyStackNavigationView() modifier to your NavigationView so that iPads retain their default behavior whilst iPhones always use stack navigation. Again, give it a try and see what you think – it’s your app, and it’s important you like how it works. Tip: I’m not going to be using this modifier in my own project because I prefer to use Apple’s default behavior where possible, but don’t let that stop you from making your own choice!
    }
    
    // This is the variable to filter the resort when user type on Search  --> .searchable(text: ....)
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            return resorts
        } else {
            return resorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

// MARK: - PreviewProvider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
