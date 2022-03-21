//
//  ContentView.swift
//  Day20_ GuessTheFlagPart1
//
//  Created by Lee McCormick on 3/20/22.
//

import SwiftUI

// VStack HStack ZStack
struct ContentView1: View {
    var body: some View {
        VStack {
            VStack {
                Spacer()
                Text("Hello, world VStack!")
                Text("Hello, Lee VStack!")
                Text("Hello, iOS Dev VStack!")
                Spacer()
            }
            HStack(spacing: 5)  {
                Text("1")
                Text("2")
                Text("3")
            }
            HStack(spacing: 5)   {
                Text("4")
                Text("5")
                Text("6")
            }
            HStack(spacing: 20)   {
                Text("7")
                Text("8")
                Text("9")
            }
        }
        ZStack { // We also have ZStack for arranging things by depth – it makes views that overlap. In the case of our two text views, this will make things rather hard to read:
            Text("Hello, world ZStack!")
            Text("Hello, Lee ZStack!")
            Text("Hello, iOS Dev ZStack!")
            Text("This is inside a stack")
        }
    }
}


struct ContentView2: View {
    var body: some View {
        ZStack {
            Color.red
                .frame(minWidth: 200, maxWidth:  .infinity, maxHeight: 200)
            Text("Your content.")
            // Color.primary
            // Color.blue
            // Color.secondary
            // Color(red: 1, green: 0.8, blue: 0)
            VStack(spacing: 0) {
                Color.red
                Color.blue
            }
            Text("Your content")
            // .foregroundColor(.secondary)
                .foregroundStyle(.secondary)
                .padding(50)
                .background(.ultraThinMaterial)
        }
        .ignoresSafeArea()
        
    }
}

// Gradient Color
struct ContentView3: View {
    var body: some View {
        // LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom)
        /* LinearGradient(gradient: Gradient(stops: [
         .init(color: .white, location: 0.45),
         .init(color: .red, location: 0.55)
         ]), startPoint: .top, endPoint: .bottom)
         */
        // RadialGradient(gradient: Gradient(colors: [.blue, .black]), center: .center, startRadius: 20, endRadius: 200)
        AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .orange]), center: .center)
    }
}

// Button
struct ContentView4: View {
    var body: some View {
        Button {
            print("Edit button is tapped")
        } label : {
            Label("Edit", systemImage: "pencil")
            // Image(systemName: "pencil")
            // Text("Tap me!")
            //               .padding()
            //               .foregroundColor(.white)
            //               .background(.red)
        }
        //  .renderingMode(.original)
        //       Button("Delete Selection", role: .destructive ,action: executeDelete)
        //       VStack {
        //           Button("Button 1") { }
        //           .buttonStyle(.bordered)
        //           Button("Button 2", role: .destructive) { }
        //           .buttonStyle(.bordered)
        //           Button("Button 3") { }
        //           .buttonStyle(.borderedProminent)
        //           .tint(.mint)
        //           Button("Button 4", role: .destructive) { }
        //           .buttonStyle(.borderedProminent)
        //
        //       }
    }
    
    func executeDelete() {
        print("Now deleting")
    }
}

// Alert
struct ContentView: View {
    @State private var showingAlert = false
    var body: some View {
        Button("Show Alert") {
            showingAlert = true
        }
        .alert("Important Message", isPresented: $showingAlert) {
            // Button("OK") {}
            Button("Delete", role: .destructive) { }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please read this")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
