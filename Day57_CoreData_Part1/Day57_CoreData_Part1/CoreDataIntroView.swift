//
//  CoreDataIntroView.swift
//  Day57_CoreData_Part1
//
//  Created by Lee McCormick on 5/7/22.
//

import SwiftUI

struct CoreDataIntroView: View {
    let coreDataIntro =
    """
    This technique project is going to explore Core Data in more detail, starting with a summary of some basic techniques then building up to tackling some more complex problems.

    When you’re working with Core Data, please try to keep in mind that it has been around for a long time – it was designed way before Swift existed, never mind SwiftUI, so occasionally you’ll meet parts that don’t work quite as well in Swift as we might hope. Hopefully we’ll see this improve over the years ahead, but in the meantime be patient!

    We have lots of Core Data to explore, so please create a fresh project where we can try it out. Call it “CoreDataProject” and not just “CoreData” because that will cause Xcode to get confused.

    Make sure you do not check the “Use Core Data” box. Instead, please copy DataController.swift from your Bookworm project, make a new, empty Data Model called CoreDataProject.xcdatamodeld, then update CoreDataProjectApp.swift to create a DataController instance and inject it into the SwiftUI environment. This will leave you where we started in the early stages of the Bookworm project.

    Important: As you’re copying DataController from Bookworm to this new project, the data model file has changed – make sure you change NSPersistentContainer initializer to refer to the new data model file rather than Bookworm.

    As you progress, you might sometimes find that Xcode will ignore changes made in the Core Data editor, so I like to drive the point home by pressing Cmd+S before going to another file. Failing that, restart Xcode!

    All set? Let’s go!

    Tip: Sometimes you’ll see a heading titled “Want to go further?” This contains some bonus examples that help take your knowledge further, but you don’t need to follow here unless you want to – think of it as extra credit.
    """
    var body: some View {
        ScrollView {
        Text("Core Data: Introduction")
            .font(.title.bold())
            Text(coreDataIntro)
                .font(.body)
        }
    }
}

struct CoreDataIntroView_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataIntroView()
    }
}
