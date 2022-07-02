//
//  PackageDependenciesView.swift
//  Day81_HotProspects_Part3
//
//  Created by Lee McCormick on 6/29/22.
//

import SamplePackage
import SwiftUI

struct PackageDependenciesView: View {
    let info =
    """
    Everything we’ve been coding so far is stuff we’ve built from scratch, so you can see exactly how it works and apply those skills to your own projects. Sometimes, though, writing something from scratch is risky: perhaps the code is complex, perhaps it’s easy to get wrong, perhaps it changes often, or any other myriad of reasons, which is why dependencies exist – the ability to fetch third-party code and use it in our projects.
    
    Xcode comes with a dependency manager built in, called Swift Package Manager (SPM). You can tell Xcode the URL of some code that’s stored online, and it will download it for you. You can even tell it what version to download, which means if the remote code changes sometime in the future you can be sure it won’t break your existing code.
    
    To try this out, I created a simple Swift package that you can import into any project. This adds a small extension to Swift’s Sequence type (which Array, Set, Dictionary, and even ranges all conform to) that pulls out a number of random items at the same time.
    
    Anyway, the first step is to add the package to our project: go to the File menu and choose Add Packages. For the URL enter https://github.com/twostraws/SamplePackage, which is where the code for my example package is stored. Xcode will fetch the package, read its configuration, and show you options asking which version you want to use. The default will be “Version – Up to Next Major”, which is the most common one to use and means if the author of the package updates it in the future then as long as they don’t introduce breaking changes Xcode will update the package to use the new versions.
    
    The reason this is possible is because most developers have agreed a system of semantic versioning (SemVer) for their code. If you look at a version like 1.5.3, then the 1 is considered the major number, the 5 is considered the minor number, and the 3 is considered the patch number. If developers follow SemVer correctly, then they should:
    
    Change the patch number when fixing a bug as long as it doesn’t break any APIs or add features.
    Change the minor number when they added features that don’t break any APIs.
    Change the major number when they do break APIs.
    This is why “Up to Next Major” works so well, because it should mean you get new bug fixes and features over time, but won’t accidentally switch to a version that breaks your code.
    
    Anyway, we’re done with our package, so click Finish to make Xcode add it to the project. You should see it appear in the project navigator, under “Swift Package Dependencies”.
    
    To try it out, open ContentView.swift and add this import to the top:
    
    import SamplePackage
    Yes, that external dependency is now a module we can import anywhere we need it.
    
    And now we can try it in our view. For example, we could simulate a simple lottery by making a range of numbers from 1 through 60, picking 7 of them, converting them to strings, then joining them into a single string. To be concise, this will need some code you haven’t seen before so I’m going to break it down.
    
    First, replace your current ContentView with this:
    
    struct ContentView: View {
        var body: some View {
            Text(results)
        }
    }
    Yes, that won’t work because it’s missing results, but we’re going to fill that in now.
    
    First, creating a range of numbers from 1 through 60 can be done by adding this property to ContentView:
    
    let possibleNumbers = Array(1...60)
    Second, we’re going to create a computed property called results that picks seven numbers from there and makes them into a single string, so add this property too:
    
    var results: String {
        // more code to come
    }
    Inside there we’re going to select seven random numbers from our range, which can be done using the extension you got from my SamplePackage framework. This provides a random() method that accepts an integer and will return up to that number of random elements from your sequence, in a random order. Lottery numbers are usually arranged from smallest to largest, so we’re going to sort them.
    
    So, add this line of code in place of // more code to come:
    
    let selected = possibleNumbers.random(7).sorted()
    Next, we need to convert that array of integers into strings. This only takes one line of code in Swift, because sequences have a map() method that lets us convert an array of one type into an array of another type by applying a function to each element. In our case, we want to initialize a new string from each integer, so we can use String.init as the function we want to call.
    
    So, add this line after the previous one:
    
    let strings = selected.map(String.init)
    At this point strings is an array of strings containing the seven random numbers from our range, so the last step is to join them all together with commas in between. Add this final line to the property now:
    
    return strings.joined(separator: ", ")
    And that completes our code: the text view will show the value inside results, which will go ahead and pick random numbers, sort them, stringify them, then join them with commas.
    
    PS: You can read the source code for my simple extension right inside Xcode – just open the Sources > SamplePackage group and look for SamplePackage.swift. You’ll see it doesn’t do much!
    
    That finishes our final technique required for this project, so please reset your code to its original state.
    """
    
    let possibleNumbers = Array(1...60)
    var results: String {
        let selected = possibleNumbers.random(7).sorted()
        let strings = selected.map(String.init)
        return strings.joined(separator: ", ")
    }
    var body: some View {
        ScrollView {
            Text("Result from SPD :  \(results)")
                .font(.largeTitle)
                .padding()
            Text(info)
        }
        .navigationTitle("Adding Swift package dependencies in Xcode")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PackageDependenciesView_Previews: PreviewProvider {
    static var previews: some View {
        PackageDependenciesView()
    }
}
