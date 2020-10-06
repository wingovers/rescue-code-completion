// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import SwiftUI

struct TempDirectoryBox: View {
    var vm: TempDirectoryVM

    @State var isHovering = false

    var body: some View {
        if vm.shouldExist {
            directoryButton
                .onHover { hovering in
                    withAnimation { isHovering = hovering }
                }
                .onTapGesture {
                    withAnimation { vm.eradicate() }
                }
        }
    }

    var directoryButton: some View {
        HStack(alignment: .firstTextBaseline, spacing: 1) {
            Text(vm.name)
                .font(.directoryStandard)
            Spacer()
            Image(systemName: vm.directorySymbol)
                .opacity(isHovering ? 1 : 0)
        }
        .flipsForRightToLeftLayoutDirection(true)
        .padding(.horizontal)
        .padding(.vertical, 7)
        .animation(.easeInOut(duration: .animatePrefsButton / 2))
        .foregroundColor(vm.hasError ? .error : .textNormal)
        .animation(.none)
        .background(background)
    }

    @ViewBuilder
    var background: some View {
        (vm.shouldExist ? Color.hoverMenubar : Color.hoverMenubarDeleted)
            .cornerRadius(8)
            .opacity(isHovering ? 0.5 : 0)
            .animation(.easeInOut(duration: .animatePrefsButton / 2))
    }
}
