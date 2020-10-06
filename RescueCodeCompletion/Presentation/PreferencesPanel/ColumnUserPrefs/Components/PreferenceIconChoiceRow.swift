//
//  PreferenceIconChoiceRow.swift
 
//
//  Created by Ryan on 10/27/20.
//

import SwiftUI

typealias ChooseMenubarIconAction = (_ icon: MenubarIcon) -> Void

struct PreferenceIconChoiceRow: View {
    let icon: MenubarIcon
    let choose: ChooseMenubarIconAction
    let current: MenubarIcon
    @State var isHovering = false

    var body: some View {
        ZStack(alignment: .center) {
            hoverBox
            selectionBox
            image
                .frame(width: 17, height: 17)
        }
        .contentShape(Rectangle())
        .frame(width: 26, height: 26)
        .scaleEffect(isHovering ? 1.1 : 1)
        .animation(.easeInOut)
        .onTapGesture {
            withAnimation { choose(icon) }
        }
        .onHover { hovering in
            withAnimation {
                isHovering = hovering
            }
        }
    }

    var image: some View {
        Image(icon.xcasset)
            .renderingMode(.template)
            .resizable()
    }

    var selectionBox: some View {
        RoundedRectangle(cornerRadius: 5, style: .continuous)
            .foregroundColor(.accentColor)
            .opacity(current == icon ? 0.5 : 0)
    }

    var hoverBox: some View {
        RoundedRectangle(cornerRadius: 5, style: .continuous)
            .foregroundColor(.accentColor)
            .opacity(isHovering ? 0.2 : 0)
    }
}
