//
//  CodableDataView.swift
//  Day39_MoonShotPart1
//
//  Created by Lee McCormick on 4/9/22.
//

import SwiftUI

struct User: Codable {
    let name: String
    let address: Address
}

struct Address: Codable {
    let street: String
    let city: String
}

struct CodableDataView: View {
    @State private var userInfo = ""
    
    var body: some View {
        VStack {
            Text("Working with hierarchical Codable data")
                .font(.largeTitle)
                .bold()
            Button("Decode JSON") {
                let input = """
            {
                "name": "Taylor Swift",
                "address": {
                    "street": "555, Taylor Swift Avenue",
                    "city": "Nashville"
                }
            }
            """
                // Now for the best part: we can convert our JSON string to the Data type (which is what Codable works with), then decode that into a User instance:
                let data = Data(input.utf8)
                let decoder = JSONDecoder()
                // There’s no limit to the number of levels Codable will go through – all that matters is that the structs you define match your JSON string.
                if let user = try? decoder.decode(User.self, from: data) {
                    userInfo = "Name: \(user.name) Street : \(user.address.street) City : \(user.address.city)"
                    print(user.address.street)
                }
            }
            Text("User Decoder : \(userInfo)")
        }
    }
}

struct CodableDataView_Previews: PreviewProvider {
    static var previews: some View {
        CodableDataView()
    }
}
