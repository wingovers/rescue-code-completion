//
//  FeedbackIcon.swift
 
//
//  Created by Ryan on 10/26/20.
//

import SwiftUI

struct FeedbackIcon: View {
    @Environment(\.openURL) var openURL
    @State var isHovering = false
    @Binding var showFeedback: Bool
    let vm: FeedbackIconVM
    
    var body: some View {
        Button {
            withAnimation {
                showFeedback.toggle()
                isHovering = false
            }
        }
        label: {
            label
        }
        .buttonStyle(PlainButtonStyle())
        .focusable()
    }
    
    var label: some View {
        HStack(alignment: .firstTextBaseline) {
            if showFeedback {
                EmptyView()
            } else {
                if isHovering { symbolsOn }
                else { symbolsOff }
            }
        }
        .transition(.opacity)
        .font(.feedbackHelpIcons)
        .opacity(0.8)
        .padding()
        .contentShape(Rectangle())
        .onHover { hovering in withAnimation { isHovering = hovering } }
    }
    
    var symbolsOn: some View {
        HStack(alignment: .bottom) {
            Text(vm.label)
                .font(.feedbackHelpCaption)
            Text(Image(systemName: vm.helpOnSymbol))
                .fontWeight(.medium)
            Text(Image(systemName: vm.feedbackOnSymbol))
                .fontWeight(.medium)
                .offset(y: feedbackSymbolYOffset)
        }
        .foregroundColor(.hoverBlue)
    }
    
    var symbolsOff: some View {
        HStack(alignment: .bottom) {
            Text(Image(systemName: vm.helpOffSymbol))
                .fontWeight(.medium)
            Text(Image(systemName: vm.feedbackOffSymbol))
                .fontWeight(.medium)
                .offset(y: feedbackSymbolYOffset)
        }
        .foregroundColor(.textMoreFaded)
    }

    let feedbackSymbolYOffset: CGFloat = -1
}
