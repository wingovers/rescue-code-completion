//
//  PreferencesCheckmarkGroup.swift
 
//
//  Created by Ryan on 10/19/20.
//

import SwiftUI

struct PreferencesCheckmarkGroup: View {
    let optionText: String
    let captionText: String?

    @Binding var isSelected: Bool
    @State var isHovering = false
    var body: some View {
        VStack(alignment: .leading) {
            Toggle(isOn: $isSelected, label: {
                Text(optionText)
                    .padding(.leading, 5)
                    .brightness(isHovering ? .brightenOnHover : 0)
            })
            if let caption = captionText {
                Text(caption)
                    .font(.prefsItemCaption)
                    .foregroundColor(.textMoreFaded)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.leading).padding(.leading, 8)
                    .brightness(isHovering ? .brightenOnHover : 0)
            }
        }

        .onHover { isHovering = $0 }
    }
}
