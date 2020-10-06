//
//  PreferencesSectionTitle.swift
 
//
//  Created by Ryan on 10/19/20.
//

import SwiftUI

struct PreferencesSectionTitle<Content: View>: View {
    init(title: String, extraPadding: Bool, @ViewBuilder button: () -> Content) {
        self.button = button()
        self.title = title
        self.extraPadding = extraPadding
    }

    let title: String
    let button: Content
    let cornerRadius: CGFloat = 6
    let extraPadding: Bool

    var body: some View {
        HStack {
            Text(title)
                .font(.sectionTitle)
                .foregroundColor(.textSoftened)
                .padding(.leading)
                .padding(.vertical, extraPadding ? 6 : 6)
            Spacer()
            button
        }
        .drawingGroup() // Confines animation on the button to the section title bar background bounds
        .background(
            Color.preferencesSectionTitleBackground
                .cornerRadius(cornerRadius)
        )
    }
}

