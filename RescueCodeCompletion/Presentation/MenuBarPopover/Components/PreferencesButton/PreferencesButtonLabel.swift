// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import SwiftUI

struct PreferencesButtonLabel: View {
    let vm: PreferencesButtonVM

    @State var isHoveringOnPrefs = false

    var body: some View {
        HStack(alignment: .center) {
            gearSet
                .overlay(labelOverlay.offset(x: 3, y: 21),
                         alignment: .bottomTrailing)
        }
        .offset(x: 0, y: 2)
        .frame(minWidth: .prefsButtonMinWidth, alignment: .trailing)
        .padding(.vertical)
        .contentShape(Rectangle())
        .onTapGesture {
            vm.tap()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                isHoveringOnPrefs = false
            }
        }
        .onHover { isHovering in
            withAnimation {
                isHoveringOnPrefs = isHovering
            }
        }
        .focusable()
    }

    var labelOverlay: some View {
        Text(vm.label)
            .font(.iconSubtitle)
            .foregroundColor(.hoverOnGrayscale)
            .opacity(isHoveringOnPrefs ? 1 : 0)
            .offset(y: 1)
            .animation(.none)
            .frame(minWidth: 100, alignment: .trailing)
    }

    var gearSet: some View {
        HStack(spacing: 0) {
            gear
                .scaleEffect(1.25)
                .rotationEffect(Angle(degrees: isHoveringOnPrefs ? 0 : -20), anchor: .center)
            gear
                .scaleEffect(1.1)
                .rotationEffect(Angle(degrees: isHoveringOnPrefs ? 120 : 0), anchor: .center)
        }
        .rotationEffect(Angle(degrees: 45), anchor: .center)
        .rotationEffect(Angle(degrees: isHoveringOnPrefs ? 150 : 0), anchor: .center)
        .rotationEffect(Angle(degrees: isHoveringOnPrefs ? 3 : 0), anchor: .bottom)
        .animation(Animation.easeInOut(duration: .animatePrefsButtonGears))
    }

    var gear: some View {
        Image(systemName: vm.gear)
            .imageScale(.small)
            .foregroundColor(isHoveringOnPrefs
                                ? .hoverOnGrayscale
                                : .hoverOffGrayscale
            )
            .animation(.easeInOut)
    }
}
