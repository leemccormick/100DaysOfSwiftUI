//
//  View-NavigationViewStyle.swift
//  Day98_SnowSeeker_Part3
//
//  Created by Lee McCormick on 7/15/22.
//

import SwiftUI

// MARK: - Extension View
extension View {
    @ViewBuilder func phoneOnlyNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        }
    }
}
