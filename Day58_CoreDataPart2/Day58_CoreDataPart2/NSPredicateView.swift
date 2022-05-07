//
//  NSPredicateView.swift
//  Day58_CoreDataPart2
//
//  Created by Lee McCormick on 4/27/22.
//

import SwiftUI

struct NSPredicateView: View {
    var body: some View {
        Text("Filtering @FetchRequest using NSPredicate")
            .font(.title.bold())
    }
}

struct NSPredicateView_Previews: PreviewProvider {
    static var previews: some View {
        NSPredicateView()
    }
}
