//
//  ImporterHelpTipAnimation.swift
 
//
//  Created by Ryan on 10/26/20.
//

import SwiftUI

struct ImporterHelpTipAnimation: View {
    init(animate: Binding<Bool>, hovering: Binding<Bool>) {
        _shouldAnimate = animate
        _isHovering = hovering
    }

    @Binding var shouldAnimate: Bool
    @Binding var isHovering: Bool

    @State var isFirstRepeat = true

    var body: some View {
        ZStack(alignment: .center) {
            animationCircle
                .scaleEffect(shouldAnimate ? 1.3 : 0.01, anchor: .center)
            animationCircle
                .scaleEffect(shouldAnimate ? 2 : 0.01, anchor: .center)

        }
        .blur(radius: shouldAnimate ? 15 : 8, opaque: false)
        .opacity(shouldAnimate ? 0 : 0.7)
        .animation(shouldAnimate
                    ? loopingAnimation
                    : killLoopingAnimationWorkaround,
                   value: shouldAnimate)
        .opacity(shouldAnimate ? 1 : 0)
        .animation(killLoopingAnimationWorkaround)
        .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isFirstRepeat = false
        } }
        .onChange(of: shouldAnimate) { newState in
            isFirstRepeat = newState
        }
    }

    var animationCircle: some View {
        Circle()
            .foregroundColor(
                isHovering
                    ? .hoverBlue
                    : .textMoreFaded
            )
    }

    var loopingAnimation: Animation {
        Animation
        .easeInOut(duration: 3)
        .delay(isFirstRepeat ? 0 : 1.5)
        .repeatForever(autoreverses: false)
    }

    let killLoopingAnimationWorkaround = Animation.default
}
