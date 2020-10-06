// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import SwiftUI

struct OnboardingView: View {
    let vm: OnboardingVM

    var body: some View {
        VStack(alignment: .leading,
               spacing: .onboardingSpacing) {
            Text(vm.onboardingHeader)
                .font(.onboardingHeader)
                .fontWeight(.onboardingHeader)
                .fixedSize(horizontal: false, vertical: true)
            checklist
            Spacer()
            Button { vm.buttonTap() }
                label: { setupButton }
                .buttonStyle(PlainButtonStyle())
                .focusable()
        }
        .multilineTextAlignment(.leading)
        .lineLimit(nil)
        .padding(.onboardingSpacing)
        .frame(maxWidth: .infinity, maxHeight: .infinity)

    }

    var checklist: some View {
        VStack(alignment: .leading,
               spacing: .onboardingSpacing) {
            HStack(alignment: .firstTextBaseline,
                   spacing: .onboardingSpacing) {
                Text(Image(systemName: vm.bullet1Symbol))
                    .font(.onboardingChecklistImage)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(.systemRed))
                Text(vm.bullet1Text)
                    .fontWeight(.onboardingChecklist)
            }
            HStack(alignment: .firstTextBaseline,
                   spacing: .onboardingSpacing) {
                Image(systemName: vm.bullet2Symbol)
                    .foregroundColor(Color(.systemYellow))
                Text(vm.bullet2Text)
                    .fontWeight(.onboardingChecklist)
                    .fixedSize(horizontal: false, vertical: true)
            }
            HStack(alignment: .firstTextBaseline,
                   spacing: .onboardingSpacing) {
                Image(systemName: vm.bullet3Symbol)
                    .foregroundColor(Color(.systemGreen))
                Text(vm.bullet3Text)
                    .fontWeight(.onboardingChecklist)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.leading, .onboardingSpacing/2)
        .font(.onboardingChecklist)
        .foregroundColor(.onboardingText)
    }

    @State var isHoveringOnButton = false
    var setupButton: some View {
        HStack {
            Spacer()
            Text(vm.buttonText)
                .font(.onboardingButtonLabel)
            Spacer()
        }
        .padding(.vertical, .onboardingSpacing/2)
        .contentShape(Rectangle())
        .background(Color.hoverBlue
                        .cornerRadius(.onboardingButtonCornerRadius)
                        .opacity(isHoveringOnButton ? 1 : 0.65))
        .onHover { hovering in withAnimation { isHoveringOnButton = hovering } }
    }
}
