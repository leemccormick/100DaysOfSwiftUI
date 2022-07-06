//
//  MeView.swift
//  Day83_HotProspect_Part5
//
//  Created by Lee McCormick on 7/2/22.
//

import CoreImage
import CoreImage.CIFilterBuiltins // We’re going to use the name and email address fields to generate a QR code, which is a square collection of black and white pixels that can be scanned by phones and other devices. Core Image has a filter for this built in, and as you’ve learned how to use Core Image filters previously you’ll find this is very similar
import SwiftUI

struct MeView: View {
    @State private var name = "Anonymous"
    @State private var emailAddress = "you@yoursite.com"
    // Second, we need two properties to store an active Core Image context and an instance of Core Image’s QR code generator filter. So, add these two to MeView:
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                    .textContentType(.name) // When it comes to the body of the view we’re going to use two text fields with large fonts, but this time we’re going to attach a small but useful modifier to the text fields called textContentType() – it tells iOS what kind of information we’re asking the user for. This should allow iOS to provide autocomplete data on behalf of the user, which makes the app nicer to use.
                    .font(.title)
                TextField("Email address", text: $emailAddress)
                    .textContentType(.emailAddress)
                    .font(.title)
                // Isolating all that functionality in a method works really well in SwiftUI, because it means the code we put in the body property stays as simple as possible. In fact, we can just use Image(uiImage:) directly with a call to generateQRCode(from:), then scale it up to a sensible size onscreen – SwiftUI will make sure the method gets called every time name or emailAddress changes. In terms of the string to pass in to generateQRCode(from:), we’ll be using the name and email address entered by the user, separated by a line break. This is a nice and simple format, and it’s easy to reverse when it comes to scanning these codes later on.
                Image(uiImage: generateQRCode(from: "\(name)\n\(emailAddress)"))
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            .navigationTitle("Your code")
        }
    }
    /*
     Now for the interesting part: making the QR code itself. If you remember, working with Core Image filters requires us to provide some input data, then convert the output CIImage into a CGImage, then that CGImage into a UIImage. We’ll be following the same steps here, except:
     1) Our input for the filter will be a string, but the input for the filter is Data, so we need to convert that.
     2) If conversion fails for any reason we’ll send back the “xmark.circle” image from SF Symbols.
     3) If that can’t be read – which is theoretically possible because SF Symbols is stringly typed – then we’ll send back an empty UIImage.
     */
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
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
