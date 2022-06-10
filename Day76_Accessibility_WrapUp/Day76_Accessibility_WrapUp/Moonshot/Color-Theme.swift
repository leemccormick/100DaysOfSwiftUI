//
//  Color-Theme.swift
//  Day76_Accessibility_WrapUp
//
//  Created by Lee McCormick on 6/9/22.
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
