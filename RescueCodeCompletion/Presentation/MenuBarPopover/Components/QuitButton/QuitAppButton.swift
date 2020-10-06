// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import SwiftUI

struct QuitAppButton: View {
    let vm: QuitButtonVM

    @State var isHoveringOnQuit = false

    var body: some View {
        HStack(alignment: .center) {
            moon
                .overlay(sleepAnimation, alignment: .center)
                .overlay(labelOverlay.offset(x: 3, y: 21),
                         alignment: .bottomTrailing)
        }
        .offset(y: 2)
        .frame(minWidth: 15, alignment: .trailing)
        .padding(.vertical)
        .contentShape(Rectangle())
        .onHover { isHoveringOnQuit = $0 }
        .onTapGesture { vm.tap() }
        .focusable()
    }

    var labelOverlay: some View {
        Text(vm.label)
            .font(.iconSubtitle)
            .foregroundColor(.hoverOnGrayscale)
            .opacity(isHoveringOnQuit ? 1 : 0)
            .offset(y: -2)
            .animation(.none)
            .frame(minWidth: 100, alignment: .trailing)
    }

    var moon: some View {
        Image(systemName: vm.moon)
            .imageScale(.large)
            .foregroundColor(isHoveringOnQuit
                                ? .hoverOnGrayscale
                                : .hoverOffGrayscale
            )
            .rotationEffect(Angle(degrees: isHoveringOnQuit ? -23 : 0), anchor: .center)
            .animation(.easeInOut(duration: 0.6), value: isHoveringOnQuit)
    }

    var zzz: some View {
        VStack(spacing: 0) {
            Text("Z")
                .offset(y: 3)
            Text("z")
                .offset(x: 8, y: -5)
            Text("z")
                .offset(x: 0, y: -13)
        }
        .offset(x: 1, y: -28)
        .font(.system(size: 10, weight: .regular, design: .rounded))
        .foregroundColor(.hoverOffGrayscale)
    }

    var sleepAnimation: some View {
        zzz
            .scaleEffect(isHoveringOnQuit ? 0.73 : 0.45,
                         anchor: .bottomLeading)
            .animation(isHoveringOnQuit
                        ? loopingScaling
                        : killLoopingAnimationWorkaround,
                       value: isHoveringOnQuit)
            .opacity(isHoveringOnQuit ? 1 : 0)
            .animation(isHoveringOnQuit
                        ? loopingVisibility
                        : killLoopingAnimationWorkaround,
                       value: isHoveringOnQuit)
            .opacity(isHoveringOnQuit ? 1 : 0)
            .animation(nonloopingShowAnimation, value: isHoveringOnQuit)
    }

    let loopingVisibility = Animation
        .linear(duration: 1.5)
        .repeatForever(autoreverses: true)

    let loopingScaling = Animation
        .linear(duration: 3)
        .repeatForever(autoreverses: false)

    let nonloopingShowAnimation = Animation.default

    let killLoopingAnimationWorkaround = Animation.default
}
