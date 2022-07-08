//
//  ProspectsView.swift
//  Day85_HotProspects_WrapUp
//
//  Created by Lee McCormick on 7/7/22.
//

import CodeScanner
import SwiftUI
import UserNotifications

enum FilterType {
    case none, contacted, uncontacted
}

/*
 Challenge 3 : Use a confirmation dialog to customize the way users are sorted in each tab – by name or by most recent.
 */
enum SortedType {
    case name, mostRecent
}

struct ProspectsView: View {
    let filter: FilterType
    @EnvironmentObject var prospects: Prospects
    @State private var sorted: SortedType = .name
    @State private var isShowingScanner = false
    @State private var isShowingSortedConfirmationDialog = false
    let simulatedData = ["Lee McCormick\nleemccormick.developer@gmail.com", "Anny Ann\nAnnyAnn.developer@gmail.com", "Donny McCormick\ndonny.developer@gmail.com", "Sofie Jan\nsofie.developer@gmail.com", "Chirst Bach\nchirst.developer@gmail.com", "Tom Onato\ntom.developer@gmail.com"] // Challenge 3 --> Test Data
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    VStack(alignment: .center) {
                        if filter == .none { // Challenge 1 : Add an icon to the “Everyone” screen showing whether a prospect was contacted or not.
                            HStack {
                                Image(systemName: prospect.isContacted ? "checkmark.circle" : "questionmark.diamond")
                                    .font(.largeTitle)
                                VStack(alignment: .leading) {
                                    Text(prospect.name)
                                        .font(.headline)
                                    Text(prospect.emailAddress)
                                        .foregroundColor(.secondary)
                                }
                            }
                        } else {
                            VStack(alignment: .leading) {
                                Text(prospect.name)
                                    .font(.headline)
                                Text(prospect.emailAddress)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .swipeActions {
                        if prospect.isContacted {
                            Button {
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
                            Button {
                                addNotification(for: prospect   )
                            } label: {
                                Label("Remind Me",systemImage: "bell")
                            }
                            .tint(.orange)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        isShowingScanner = true
                    } label: {
                        Label("Scan", systemImage: "qrcode.viewfinder")
                    }
                    Button {
                        isShowingSortedConfirmationDialog = true
                    } label: {
                        Label("Sorted", systemImage: "square.and.pencil")
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                let testData = simulatedData.randomElement() ?? simulatedData[0]
                CodeScannerView(codeTypes: [.qr], simulatedData: testData, completion: handleScan)
            }
            // Challenge 3
            .confirmationDialog("Sorted Prospects !", isPresented: $isShowingSortedConfirmationDialog) {
                Button("Sorted By Name") {
                    sorted = .name
                }
                Button("Sorted By Most Recent Date") {
                    sorted = .mostRecent
                }
            }
        }
    }
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted"
        case .uncontacted:
            return "Uncontacted"
        }
    }
    
    var filteredProspects: [Prospect] {
        var filteredProspects : [Prospect] = []
        switch filter {
        case .none:
            filteredProspects = prospects.people
        case .contacted:
            filteredProspects = prospects.people.filter { $0.isContacted }
        case .uncontacted:
            filteredProspects = prospects.people.filter { !$0.isContacted }
        }
        // Challenge 3
        switch sorted {
        case .name:
            return filteredProspects.sorted { $0.name < $1.name }
        case .mostRecent:
            return filteredProspects.sorted { $0.date < $1.date }
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            var dateComponent = DateComponents()
            dateComponent.hour = 9
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        if let wrappedError = error {
                            print("D' oh : \(wrappedError)")
                        } else {
                            print("D' oh")
                        }
                    }
                }
            }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            prospects.add(person)
        case .failure(let error):
            print("Scaning failed : \(error.localizedDescription)")
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}

