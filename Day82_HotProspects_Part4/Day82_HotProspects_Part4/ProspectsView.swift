//
//  ProspectsView.swift
//  Day82_HotProspects_Part4
//
//  Created by Lee McCormick on 7/2/22.
//

import SwiftUI

struct ProspectsView: View {
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    let filter: FilterType
    
    var title: String {
        switch filter {
            
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    @EnvironmentObject var prospects: Prospects // Important: When you use @EnvironmentObject you are explicitly telling SwiftUI that your object will exist in the environment by the time the view is created. If it isn’t present, your app will crash immediately – be careful, and treat it like an implicitly unwrapped optional.
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted } // When filter() runs, it passes every element in the people array through our test. So, $0.isContacted means “does the current element have its isContacted property set to true?” All items in the array that pass that test – that have isContacted set to true – will be added to a new array and sent back from filteredResults. And when we use !$0.isContacted we get the opposite: only prospects that haven’t been contacted get included.
        }
    }
    
    var body: some View {
        NavigationView {
            // Text("People : \(prospects.people.count)")
            // When we added an @EnvironmentObject property to ProspectsView, we also asked SwiftUI to reinvoke the body property whenever that property changes. So, whenever we insert a new person into the people array its @Published property wrapper will announce the update to all views that are watching it, and SwiftUI will reinvoke the body property of ProspectsView. That in turn will calculate our computed property again, so the List will change.
            List {
                ForEach(filteredProspects) { prospect in
                    VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailAddress)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                Button {
                    let prospect = Prospect()
                    prospect.name = "Lee McCormick"
                    prospect.emailAddress = "leemccormick.developer@gmail.com"
                    prospects.people.append(prospect)
                } label: {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
