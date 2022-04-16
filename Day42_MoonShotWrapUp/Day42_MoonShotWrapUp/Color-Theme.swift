//
//  Color-Theme.swift
//  Day42_MoonShotWrapUp
//
//  Created by Lee McCormick on 4/11/22.
//

import Foundation
import SwiftUI

extension ShapeStyle where Self == Color {
    static var darkBackground : Color {
        Color(red: 0.1, green: 0.1, blue: 0.2)
    }
    
    static var lightBackground : Color {
        Color(red: 0.2, green: 0.2, blue: 0.3)
    }
}
