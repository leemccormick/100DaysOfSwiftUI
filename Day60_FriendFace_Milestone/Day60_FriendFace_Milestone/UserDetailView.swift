//
//  UserDetailView.swift
//  Day60_FriendFace_Milestone
//
//  Created by Lee McCormick on 5/12/22.
//

import SwiftUI

struct UserDetailView: View {
    let user : User
    
    var body: some View {
        Form {
            Section {
                Text("Age : \(user.age)")
                Text("Company : \(user.company)")
                Text("Email : \(user.email)")
                Text("Address : \(user.address)")
                Text("About : \(user.about)")
                Text("Registered : \(user.registered)")
            } header: {
                Text("\(user.name)'s Info")
            }
            Section {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(0..<user.tags.count) {
                            Text("#\(user.tags[$0])")
                        }
                    }
                }
            } header: {
                Text("\(user.name)'s interest")
            }
            Section {
                List {
                    ForEach(user.friends) { friend in
                        Text(friend.name)
                    }
                }
            } header: {
                Text("\(user.name)'s friends")
            }
        }
        .navigationTitle("\(user.isActive ? "🟢" : "🔴")  \(user.name) ")
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(user: User(id: "1234", isActive: true, name: "Lee", age: 32, company: "M3ts", email: "lee@lee.com", address: "2751", about: "", registered: Date(), tags: [], friends: []))
    }
}

