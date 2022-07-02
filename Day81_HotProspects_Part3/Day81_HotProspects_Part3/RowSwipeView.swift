//
//  RowSwipeView.swift
//  Day81_HotProspects_Part3
//
//  Created by Lee McCormick on 6/29/22.
//

import SwiftUI

struct RowSwipeView: View {
    let info =
    """
    iOS apps have had “swipe to delete” functionality for as long as I can remember, but in more recent years they’ve grown in power so that list rows can have multiple buttons, often on either side of the row. We get this full functionality in SwiftUI using the swipeActions() modifier, which lets us register one or more buttons on one or both sides of a list row.

    By default buttons will be placed on the right edge of the row, and won’t have any color, so this will show a single gray button when you swipe from right to left:

    List {
        Text("Taylor Swift")
            .swipeActions {
                Button {
                    print("Hi")
                } label: {
                    Label("Send message", systemImage: "message")
                }
            }
    }
    You can customize the edge where your buttons are placed by providing an edge parameter to your swipeActions() modifier, and you can customize the color of your buttons either by adding a tint() modifier to them with a color of your choosing, or by attaching a button role.

    So, this will display one button on either side of our row:

    List {
        Text("Taylor Swift")
            .swipeActions {
                Button(role: .destructive) {
                    print("Hi")
                } label: {
                    Label("Delete", systemImage: "minus.circle")
                }
            }
            .swipeActions(edge: .leading) {
                Button {
                    print("Hi")
                } label: {
                    Label("Pin", systemImage: "pin")
                }
                .tint(.orange)
            }
    }
    Like context menus, swipe actions are by their very nature hidden to the user by default, so it’s important not to hide important functionality in them. We’ll be using them both in this app, which should hopefully give you the chance to compare and contrast them directly!
    """
    
    var body: some View {
        List {
            Text("Taylor Swift")
                .swipeActions {
                    Button(role: .destructive) {
                        print("Hi ! Delete...")
                    } label: {
                        Label("Delete", systemImage: "minus.circle")
                    }
                }
                .swipeActions(edge: .leading) {
                    Button {
                        print("Hi ! Pin..")
                    } label: {
                        Label("Pin", systemImage: "pin")
                    }
                    .tint(.orange)
                }
            ScrollView {
                Text(info)
            }
            /*
             .swipeActions {
             Button {
             print("Hi")
             } label: {
             Label("Send message", systemImage: "message")
             }
             }
             */
        }
        .navigationTitle("Adding custom row swipe actions to a List")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RowSwipeView_Previews: PreviewProvider {
    static var previews: some View {
        RowSwipeView()
    }
}
