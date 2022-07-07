//
//  MeView.swift
//  Day84_HotProspects_Part6
//
//  Created by Lee McCormick on 7/6/22.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct MeView: View {
    @State private var name = "Anonymous"
    @State private var emailAddress = "you@yoursite.com"
    @State private var qrCode = UIImage() // We could save a little work by caching the generated QR code, however a more important side effect of that is that we wouldn’t have to pass in the name and email address each time – duplicating that data means if we change one copy in the future we need to change the other too. To add this change, first add a new @State property that will store the code we generate.
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("name", text: $name)
                    .textContentType(.name)
                TextField("Email Address", text: $emailAddress)
                    .textContentType(.name)
                Image(uiImage: qrCode)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                // Start by opening MeView.swift, and adding the contextMenu() modifier to the QR code image, like this:
                    .contextMenu {
                        Button {
                            // Save my code
                            // let image = generateQRCode(from: "\(name)\n\(emailAddress)")
                            let imageSaver = ImageSaver()
                            imageSaver.writeToPhotoAlbum(image: qrCode) // That code will compile cleanly, but I want you to run it and see what happens. If everything has gone to plan, Xcode should show a purple warning over your code, saying that we modified our view’s state during a view update, which causes undefined behavior. “Undefined behavior” is a fancy way of saying “this could behave in any number of weird ways, so don’t do it.”
                        } label: {
                            Label("Save to Photos", systemImage: "square.and.arrow.down")
                        }
                    }
            }
            .navigationTitle("Your Code")
            // Finally, add these new modifiers after navigationTitle():
            .onAppear(perform: updateCode)
            .onChange(of: name) { _ in updateCode() }
            .onChange(of: emailAddress) { _ in updateCode() }
            // That will ensure the QR code is updated as soon as the view is shown, or whenever name or emailAddress get changed – perfect for our needs, and much safer than trying to change some state while SwiftUI is updating our view.
            
        }
        
    }
    
    // You see, we’re telling Swift it can load our image by calling the generateQRCode() method, so when SwiftUI calls the body property it will run generateQRCode() as requested. However, while it’s running that method, we then change our new @State property, even though SwiftUI hasn’t actually finished updating the body property yet. This is A Very Bad Idea, which is why Xcode is flagging up a large warning. Think about it: if drawing the QR code changes our @State cache property, that will cause body to loaded again, which will cause the QR code to be drawn again, which will change our cache property again, and so on – it’s really messy.
    func updateCode() {
        qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
    }
    
    
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                // Now modify generateQRCode() so that it quietly stores the new code in our cache before sending it back:
                qrCode = UIImage(cgImage: cgimg)
                return qrCode
                //  return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
