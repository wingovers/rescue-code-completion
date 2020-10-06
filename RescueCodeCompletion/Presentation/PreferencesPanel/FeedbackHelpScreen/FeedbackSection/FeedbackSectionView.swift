//
//  FeedbackSectionView.swift
//  Rescue Code Completion
//
//  Created by Ryan on 11/4/20.
//

import SwiftUI

struct FeedbackSectionView: View {
    @Environment(\.openURL) var openURL
    let vm: FeedbackSectionVM

    var body: some View {
        VStack(alignment: .leading, spacing: .feedbackViewSpacing) {
            PreferencesSectionTitle(title: vm.feedbackTitle, extraPadding: true) { }
            VStack(alignment: .leading, spacing: .feedbackViewSpacing) {
                Text(vm.feedbackLine1)
                Text(vm.feedbackLine2)
                    .padding(.bottom)
                Button { openURL(vm.emailURL) }
                    label: { emailLink }
                    .buttonStyle(PlainButtonStyle())
                Button { openURL(vm.githubURL) }
                    label: { githubLink }
                    .buttonStyle(PlainButtonStyle())
            }
            .padding([.horizontal, .top])
            HStack { Spacer() }
        }.font(.standardTipText)
    }

    @State var isHoveringGithub = false
    var githubLink: some View {
        HStack(alignment: .firstTextBaseline, spacing: .feedbackViewSpacing) {
            if isHoveringGithub {
                Image(systemName: vm.githubSymbolOn)
                    .transition(.opacity)
            } else {
                Image(systemName: vm.githubSymbolOff)
                    .transition(.opacity)
            }

            Text(vm.githubPrompt)
                .font(.standardTipText)
                .scaleEffect(isHoveringGithub
                                ? .feedbackLinkHoverScaleEffectSize
                                : 1,
                             anchor: .leading)

        }
        .imageScale(.large)
        .foregroundColor(.linkColor)
        .contentShape(Rectangle())
        .onHover { state in withAnimation { isHoveringGithub = state } }
        .animation(.linear)
    }

    @State var isHoveringEmail = false
    var emailLink: some View {
        HStack(alignment: .firstTextBaseline, spacing: .feedbackViewSpacing) {
            if isHoveringEmail {
                Text(Image(systemName: vm.emailSymbolOn))
                    .fontWeight(.medium)
                    .transition(.opacity)
            } else {
                Text(Image(systemName: vm.emailSymbolOff))
                    .fontWeight(.medium)
                    .transition(.opacity)
            }
            Text(vm.emailPrompt)
                .font(.standardTipText)
                .scaleEffect(isHoveringEmail
                                ? .feedbackLinkHoverScaleEffectSize
                                : 1,
                             anchor: .leading)
        }
        .imageScale(.large)
        .foregroundColor(.linkColor)
        .contentShape(Rectangle())
        .onHover { state in withAnimation { isHoveringEmail = state } }
        .animation(.linear)
    }
}
