//
//  SwiftResultView.swift
//  Day80_HotProspects_Part2
//
//  Created by Lee McCormick on 6/28/22.
//

import SwiftUI

struct SwiftResultView: View {
    let info =
    """
    Swift provides a special type called Result that allows us to encapsulate either a successful value or some kind of error type, all in a single piece of data. So, in the same way that an optional might hold a string or might hold nothing at all, for example, Result might hold a string or might hold an error. The syntax for using it is a little odd at first, but it does have an important part to play in our projects.
    
    To see Result in action, we could start by writing a method that downloads an array of data readings from a server, like this:
    
    struct ContentView: View {
        @State private var output = ""
    
        var body: some View {
            Text(output)
                .task {
                    await fetchReadings()
                }
        }
    
        func fetchReadings() async {
            do {
                let url = URL(string: "https://hws.dev/readings.json")!
                let (data, _) = try await URLSession.shared.data(from: url)
                let readings = try JSONDecoder().decode([Double].self, from: data)
                output = "Found readings.count readings"
            } catch {
                print("Download error")
            }
        }
    }
    That code works just fine, but it doesn’t give us a lot of flexibility – what if we want to stash the work away somewhere and do something else while it’s running? What if we want to read its result at some point in the future, perhaps handling any errors somewhere else entirely? Or what if we just want to cancel the work because it’s no longer needed?
    
    Well, we can get all that by using Result, and it’s actually available through an API you’ve met previously: Task. We could rewrite the above code to this:
    
    func fetchReadings() async {
        let fetchTask = Task { () -> String in
            let url = URL(string: "https://hws.dev/readings.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let readings = try JSONDecoder().decode([Double].self, from: data)
            return "Found readings.count readings"
        }
    }
    We’ve used Task before to launch pieces of work, but here we’ve given the Task object the name of fetchTask – that’s what gives us the extra flexibility to pass it around, or cancel it if needed. And notice how our Task closure returns a value now? That value gets stored in our Task instance so that we can read it in the future when we’re ready.
    
    More importantly, that Task might have thrown an error if the network fetch failed, or if the data decoding failed, and that’s where Result comes in: the result of our task might be a string saying “Found 10000 readings”, but it might also contain an error. The only way to find out is to look inside – it’s very similar to optionals.
    
    To read the result from a Task, read its result property like this:
    
    let result = await fetchTask.result
    Notice how we haven’t used try to read the Result out? That’s because Result holds it inside itself – an error might have been thrown, but we don’t have to worry about it now unless we want to.
    
    If you look at the type of result, you’ll see it’s a Result<String, Error> – if it succeeded it will contain a string, but it might also have failed and will contain an error.
    
    You can read the successful value directly from the Result if you want, but you’ll need to make sure and handle errors appropriately, like this:
    
    do {
        output = try result.get()
    } catch {
        output = "Error: error.localizedDescription"
    }
    Alternatively, you can switch on the Result, and write code to check for both the success and failure cases. Each of those cases have their values inside (the string for success, and an error for failure), so Swift lets us read those values out using a specially crafted case match:
    
    switch result {
        case .success(let str):
            output = str
        case .failure(let error):
            output = "Error: error.localizedDescription"
    }
    Regardless of how you handle it, the advantage of Result is that it lets us store the whole success or failure of some work in a single value, pass that around wherever we need, and read the error only when we’re ready.
    """
    
    @State private var output = ""
    
    var body: some View {
        ScrollView {
            Text(output)
                .task {
                    await fetchReadings()
                }
                .font(.largeTitle)
                .padding()
            Text(info)
                .padding()
        }
        .navigationTitle("Understanding Swift’s Result type")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func fetchReadings() async {
        let fetchTask = Task { () -> String in
            let url = URL(string: "https://hws.dev/readings.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let readings = try JSONDecoder().decode([Double].self, from: data)
            return "Found \(readings.count) readings"
        }
        let result = await fetchTask.result
        switch result {
        case .success(let str):
            output = str
        case .failure(let error):
            output = "Error: \(error.localizedDescription)"
        }
        // You can read the successful value directly from the Result if you want, but you’ll need to make sure and handle errors appropriately, like this:
        /*
         do {
         output = try result.get()
         } catch {
         output = "Error: \(error.localizedDescription)"
         }
         */
    }
}

/* That code works just fine, but it doesn’t give us a lot of flexibility – what if we want to stash the work away somewhere and do something else while it’s running? What if we want to read its result at some point in the future, perhaps handling any errors somewhere else entirely? Or what if we just want to cancel the work because it’s no longer needed?
 func fetchReadings() async {
 do {
 let url = URL(string: "https://hws.dev/readings.json")!
 let (data, _) = try await URLSession.shared.data(from: url)
 let readings = try JSONDecoder().decode([Double].self, from: data)
 output = "Found \(readings.count) readings."
 } catch {
 print("Download error")
 }
 }*/

struct SwiftResultView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftResultView()
    }
}
