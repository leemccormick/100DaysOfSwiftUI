//
//  ContentView.swift
//  Day61_FriendFaceCoreData
//
//  Created by Lee McCormick on 5/14/22.
//

import SwiftUI

struct ContentView: View {
    @State private var users : [User] = []
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name),
]) var cachedUsers: FetchedResults<CachedUser>
    var body: some View {
        NavigationView {
            List {
                ForEach(cachedUsers, id: \.self) { user in
                    NavigationLink {
                       UserDetailView(user: user)
                    } label: {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(user.wrappedName)
                                    .font(.headline.bold())
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Text(user.isActive ? "🟢" : "🔴")
                            }
                            Text(user.wrappedEmail)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Friend Face Core Data")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            Task {
                await fetchUsers()
                await MainActor.run {
                    for user in users {
                        for friend in user.friends {
                            let newFriend = CachedFriend(context: moc)
                            newFriend.id = friend.id
                            newFriend.name = friend.name
                            newFriend.ofUser = CachedUser(context: moc)
                            newFriend.ofUser?.id  = user.id
                            newFriend.ofUser?.isActive = user.isActive
                            newFriend.ofUser?.name = user.name
                            newFriend.ofUser?.age = Int32(user.age)
                            newFriend.ofUser?.company = user.company
                            newFriend.ofUser?.email = user.email
                            newFriend.ofUser?.address = user.address
                            newFriend.ofUser?.about = user.about
                            newFriend.ofUser?.registered = user.registered
                            newFriend.ofUser?.tags = user.tags.joined(separator:",")
                        }
                    }
                    try? moc.save()
                }
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
                let fetchedUser = try decoder.decode([User].self, from: data)
                self.users = fetchedUser
            } catch {
                print("Failed To Fetch Users")
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
