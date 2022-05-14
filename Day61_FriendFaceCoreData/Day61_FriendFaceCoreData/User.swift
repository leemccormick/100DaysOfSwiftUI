//
//  User.swift
//  Day61_FriendFaceCoreData
//
//  Created by Lee McCormick on 5/14/22.
//

import Foundation

struct User : Codable, Identifiable {
    let id : String
    let isActive: Bool
    let name: String
    let age : Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: Date
    let tags: [String]
    let friends : [Friend]
}

struct Friend : Codable, Identifiable {
    let id: String
    let name: String
}
