// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import SwiftUI

struct IDEButton: View {
    let vm: IDEButtonVM

    @State var isHovering = false

    var body: some View {
        if vm.showIcon {
            dynamicIcon
                .frame(width: .ideIconDiameter, height: .ideIconDiameter)
                .scaleEffect(isHovering ? .ideIconHoverScaleEffect: 1)
                .onHover { hovering in
                    withAnimation { isHovering = hovering }
                }
        } else {
            Image(systemName: vm.substituteIconSymbol)
                .foregroundColor(foregroundColor)
                .scaleEffect(isHovering ? .ideIconHoverScaleEffect: 1)
                .onHover { hovering in
                    withAnimation { isHovering = hovering }
                }
        }
    }

    var foregroundColor: Color {
        if isHovering { return .hoverOnGrayscale }
        return vm.isDefault ? .defaultIDEsansIcon : .hoverOffGrayscale
    }

    @ViewBuilder
    var dynamicIcon: some View {
        if vm.isDefault {
            Image(nsImage: vm.icon!)
                .resizable()
                .scaledToFit()
        } else {
            Image(nsImage: vm.icon!)
                .resizable()
                .scaledToFit()
                .grayscale(isHovering ? 0 : 0.99)
        }
    }
}


