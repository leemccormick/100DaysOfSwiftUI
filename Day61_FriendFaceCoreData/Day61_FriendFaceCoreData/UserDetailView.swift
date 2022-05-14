//
//  UserDetailView.swift
//  Day61_FriendFaceCoreData
//
//  Created by Lee McCormick on 5/14/22.
//

import SwiftUI

struct UserDetailView: View {
    let user: CachedUser
    var body: some View {
        Form {
            Section {
                Text("Age : \(user.age)")
                Text("Company : \(user.wrappedCompany)")
                Text("Email : \(user.wrappedEmail)")
                Text("Address : \(user.wrappedEmail)")
                Text("About : \(user.wrappedAbout)")
                Text("Registered : \(user.wrappedRegistered)")
            } header: {
                Text("\(user.wrappedName)'s Info")
            }
            Section {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(0..<user.wrappedTagsArray.count) {
                            Text("#\(user.wrappedTagsArray[$0])")
                        }
                    }
                }
            } header: {
                Text("\(user.wrappedName)'s interest")
            }
            Section {
                List {
                    ForEach(user.friendArray) { friend in
                        Text(friend.wrappedName)
                    }
                }
            } header : {
                Text("\(user.wrappedName)'s friends")
            }
        }
        .navigationBarTitle("\(user.isActive ? "🟢" : "🔴") \(user.wrappedName)")
        .navigationBarTitleDisplayMode(.inline)
    }
}
