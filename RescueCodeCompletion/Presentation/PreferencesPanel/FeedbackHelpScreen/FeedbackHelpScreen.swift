//
//  FeedbackView.swift
 
//
//  Created by Ryan on 10/27/20.
//

import SwiftUI

struct FeedbackHelpScreen: View {
    @Binding var showFeedback: Bool
    let vm: FeedbackHelpScreenVM
    let factory: ViewControllerFactory

    var body: some View {
        VStack {
            returnToPreferences
                .padding(.leading)
            HStack(alignment: .top, spacing: .feedbackViewSpacing) {
                about
                    .frame(maxWidth: .feedbackAboutColumnMaxWidth)
                Divider()
                    .padding(.horizontal)
                ScrollView {
                    feedback
                    faqs
                        .padding(.top)
                        .padding(.top)
                }
            }
            .padding()
        }
        .padding()
        .foregroundColor(.textSoftened)
        .background(background)
        .frame(minWidth: .preferencesMinWidth,
               minHeight: .preferencesMinHeight)
    }

    var about: some View {
        AboutColumnView(vm: factory.makeAboutColumnVM())
    }

    var feedback: some View {
        FeedbackSectionView(vm: factory.makeFeedbackSectionVM())
    }

    var faqs: some View {
        FAQsView(vm: factory.makeFAQsVM())
    }

    var background: some View {
        Color.feedbackScreenBackground
            .opacity(0.7)
            .edgesIgnoringSafeArea(.top)
    }

    @State var hoverBack = false
    var returnToPreferences: some View {
        HStack {
            Button { withAnimation { showFeedback.toggle() } }
                label: {
                    Text(vm.backLabel)
                        .font(.standardTipText)
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(hoverBack
                                        ? .hoverBlue
                                        : .textMoreFaded
                )
                .onHover { state in withAnimation { hoverBack = state } }
            Spacer()
        }
    }
}



