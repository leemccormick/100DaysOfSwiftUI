//
//  SendReceiveDataView.swift
//  Day49_CupCakeCornerPart1
//
//  Created by Lee McCormick on 4/19/22.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct SendReceiveDataView: View {
    @State private var results = [Result]()
    var body: some View {
        Text("Sending and receiving Codable data with URLSession and SwiftUI")
            .font(.title.bold())
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading, spacing: 5) {
                Text(item.trackName)
                    .font(.headline.bold())
                Text(item.collectionName)
                
            }
            
        }
        .task { // SwiftUI provides a different modifier for these kinds of tasks, helpfully called just task(). This can call functions that might go to sleep for a while; all Swift asks us to do is mark those functions with a second keyword, await, so we’re explicitly acknowledging that a sleep might happen. Add this modifier to the List now:
            await loadData()
        }
    }
    
    func loadData() async { // Notice the new async keyword in there – we’re telling Swift this function might want to go to sleep in order to complete its work.
        // 1) Creating the URL we want to read.
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
        // 2) Fetching the data for that URL.
        do {
            /*
             - Our work is being done by the data(from:) method, which takes a URL and returns the Data object at that URL. This method belongs to the URLSession class, which you can create and configure by hand if you want, but you can also use a shared instance that comes with sensible defaults.
             - The return value from data(from:) is a tuple containing the data at the URL and some metadata describing how the request went. We don’t use the metadata, but we do want the URL’s data, hence the underscore – we create a new local constant for the data, and toss the metadata away.
             - When using both try and await at the same time, we must write try await – using await try is not allowed. There’s no special reason for this, but they had to pick one so they went with the one that reads more naturally.
             */
            let (data, response) = try await URLSession.shared.data(from: url)
            // 3) Decoding the result of that data into a Response struct.
            if let r = response as? HTTPURLResponse {
                print("Status Code : \(r.statusCode)")
            }
            // 3) Decoding the result of that data into a Response struct.
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
        } catch {
            print("Invalid data")
        }
    }
}

struct SendReceiveDataView_Previews: PreviewProvider {
    static var previews: some View {
        SendReceiveDataView()
    }
}
