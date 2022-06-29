//
//  AddNameTagView.swift
//  Day78_NameTagOnTheMap
//
//  Created by Lee McCormick on 6/23/22.
//


import SwiftUI

struct AddNameTagView: View {
    // MARK: - Properties
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showImagePicker = false
    @State private var name: String = ""
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) private var dissmiss
    var nameTagDirectory = NameTagDirectory()
    let locationFetcher = LocationFetcher()
    
    // MARK: - Body
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Rectangle()
                    .fill(.black)
                    .frame(width: 280, height: 280, alignment: .center)
                    .clipShape(Circle())
                Text("SELECT IMAGE...")
                    .foregroundColor(.white)
                    .font(.headline)
                image?
                    .resizable()
                    .resizable()
                    .scaledToFill()
                    .frame(width: 280, height: 280, alignment: .center)
                    .clipShape(Circle())
            }
            .cornerRadius(4)
            .onTapGesture {
                showImagePicker = true
                self.locationFetcher.start()
            }
            HStack {
                TextField("Enter Name Tag Here...", text: $name)
                    .frame(width: 280, height: 50, alignment: .center)
                    .multilineTextAlignment(TextAlignment.center)
                    .background(RoundedRectangle(cornerRadius: 6).fill(Color.gray))
                    .foregroundColor(.white)
            }
            .padding()
            Button("Save Name Tag") {
                saveImage()
                dissmiss()
            }
            .disabled(image == nil ? true : false)
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .background(.tertiary)
            .cornerRadius(6)
            Spacer()
        }
        .padding(.all)
        .navigationTitle("Add Name Tag")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: inputImage, perform: { newValue in
            loadImage()
        })
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $inputImage)
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func saveImage() {
        let nameTag = NameTagOnMap(context: moc)
        guard let processedImage = inputImage else {return}
        let idForNameTag = UUID()
        nameTag.name = name
        nameTag.id = idForNameTag
        let pathOfImage = nameTagDirectory.save(image: processedImage, id: idForNameTag.uuidString) // Save image to filePath
        nameTag.path = pathOfImage
        if let location = self.locationFetcher.lastKnownLocation {
            print("Your location is \(location)")
            nameTag.latitude = location.latitude
            nameTag.longitude = location.longitude
        } else {
            print("Your location is unknown")
        }
        try? moc.save()
    }
}

// MARK: - PreviewProvider
struct AddNameTagView_Previews: PreviewProvider {
    static var previews: some View {
        AddNameTagView()
    }
}
