//
//  ProspectsView.swift
//  Day83_HotProspect_Part5
//
//  Created by Lee McCormick on 7/2/22.
//

/*
 My package is called CodeScanner, and its available on GitHub under the MIT license at https://github.com/twostraws/CodeScanner – you’re welcome to inspect and/or edit the source code if you want. Here, though, we’re just going to add it to Xcode by following these steps:

 1) Go to File > Swift Packages > Add Package Dependency.
 2) Enter https://github.com/twostraws/CodeScanner as the package repository URL.
 3) For the version rules, leave “Up to Next Major” selected, which means you’ll get any bug fixes and additional features but not any breaking changes.
 4) Press Finish to import the finished package into your project
 */
import CodeScanner
import SwiftUI

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    let filter: FilterType
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailAddress)
                            .foregroundColor(.secondary)
                    }
                    /*
                     Now, remember that this view is shared in three places, so we need to make sure the swipe actions look correct no matter where it’s used. We could try and use a bunch of ternary conditional operators, but later on we’ll add a second button so the ternary operator approach won’t really help much. Instead, we’ll just wrap the button inside a simple condition – add this to the VStack now:
                     */
                    .swipeActions {
                        if prospect.isContacted {
                            Button {
                                // prospect.isContacted.toggle()
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.xmark")
                            }
                            .tint(.green)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                Button {
                    isShowingScanner = true
                } label: {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Lee McCormick\nleemccormick.developer@gmail.com", completion: handleScan)
            }
        }
    }
    
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
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else {return}
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            prospects.people.append(person)
        case .failure(let error):
            print("Scaning failed: \(error.localizedDescription)")
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}


/*
 Before we show the scanner and try to handle its result, we need to ask the user for permission to use the camera:

 - Go to your target’s configuration options under its Info tab.
 - Right-click on an existing key and select Add Row.
 - Select “Privacy - Camera Usage Description” for the key.
 - For the value enter “We need to scan QR codes.”

 And now we’re ready to scan some QR codes! We already have the isShowingScanner state that determines whether to show a code scanner or not, so we can now attach a sheet() modifier to present our scanner UI.

 *** Creating a CodeScanner view takes three parameters:  ***

 1) An array of the types of codes we want to scan. We’re only scanning QR codes in this app so [.qr] is fine, but iOS supports lots of other types too.
 2) A string to use as simulated data. Xcode’s simulator doesn’t support using the camera to scan codes, so CodeScannerView automatically presents a replacement UI so we can still test that things work. This replacement UI will automatically send back whatever we pass in as simulated data.
 3) A completion function to use. This could be a closure, but we just wrote the handleScan() method so we’ll use that.
 So, add this below the existing toolbar() modifier in ProspectsView:
 */
