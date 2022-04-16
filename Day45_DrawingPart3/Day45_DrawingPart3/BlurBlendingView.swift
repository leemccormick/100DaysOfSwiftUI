//
//  BlurBlendingView.swift
//  Day45_DrawingPart3
//
//  Created by Lee McCormick on 4/14/22.
//

import SwiftUI

struct BlurBlendingView: View {
    @State private var amount = 0.0
    var body: some View {
        VStack {
            Text("Special effects in SwiftUI: blurs, blending, and more")
                .font(.title.bold())
            HStack(alignment: .center, spacing: 10) {
                VStack {
                    Text("Fill Ractangle")
                    ZStack {
                        Image("aldrin")
                            .resizable()
                            .scaledToFit()
                            .colorMultiply(.blue)
                        Rectangle()
                            .fill(.blue)
                            .blendMode(.multiply)
                    }
                    .frame(width: 80, height: 80)
                    .clipped()
                    .padding(10)
                }
                VStack {
                    Text("ColorMultiply")
                    Image("aldrin")
                        .resizable()
                        .scaledToFill()
                        .colorMultiply(.red)
                        .frame(width: 80, height: 80)
                        .padding(10)
                }
                VStack {
                    Text("SaturationBlur")
                    Image("aldrin")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .padding(10)
                        .saturation(amount)
                        .blur(radius: (1 - amount) * 20)
                }
            }
            VStack {
                ZStack {
                    Circle()
                    // .fill(.red)
                        .fill(Color(red: 1, green: 0, blue: 0))
                        .frame(width: 150 * amount)
                        .offset(x: -50, y: -80)
                        .blendMode(.screen)
                    
                    Circle()
                    //.fill(.green)
                        .fill(Color(red: 0, green: 1, blue: 0))
                        .frame(width: 150 * amount)
                        .offset(x: 50, y: -80)
                        .blendMode(.screen)
                    
                    Circle()
                    // .fill(.blue)
                        .fill(Color(red: 0, green: 0, blue: 1))
                    
                        .frame(width: 150 * amount)
                        .blendMode(.screen)
                }
                .frame(width: 150, height: 150)
                Text("BlendMode")
                    .foregroundColor(.white)
                Slider(value: $amount)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
            .ignoresSafeArea()
        }
    }
}

struct BlurBlendingView_Previews: PreviewProvider {
    static var previews: some View {
        BlurBlendingView()
    }
}

