//
//  ContentView.swift
//  Day60_FriendFace_Milestone
//
//  Created by Lee McCormick on 5/11/22.
//

import SwiftUI

struct ContentView: View {
    @State private var users : [User] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(users) { user in
                    NavigationLink {
                        UserDetailView(user: user)
                    } label : {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(user.name)
                                    .font(.headline.bold())
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Text(user.isActive ? "🟢" : "🔴")
                                    .multilineTextAlignment(.trailing)
                            }
                            Text(user.email)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }  .padding()
                    }
                }
            }
            .navigationTitle("FriendFace Users")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            Task {
                await fetchUsers()
            }
        }
    }
    
    func fetchUsers() async {
        if users.isEmpty {
            let url = URL(string:"https://www.hackingwithswift.com/samples/friendface.json")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                if let response = response as? HTTPURLResponse {
                    print("Status Code : \(response.statusCode)")
                }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let  fetchedUser = try decoder.decode([User].self, from: data)
                self.users = fetchedUser
            } catch {
                print("Failed to fetch users.")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension DateFormatter {
  static let iso8601Full: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}
