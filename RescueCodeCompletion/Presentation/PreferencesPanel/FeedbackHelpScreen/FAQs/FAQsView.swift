//
//  FAQsView.swift
//  Rescue Code Completion
//
//  Created by Ryan on 11/4/20.
//

import SwiftUI

struct FAQsView: View {
    let vm: FAQsVM

    var body: some View {
        VStack(alignment: .leading, spacing: .feedbackViewSpacing) {
            PreferencesSectionTitle(title: vm.faqsTitle, extraPadding: true) { }
            VStack(alignment: .leading, spacing: .feedbackViewSpacing) {
                Text(vm.faqsQ1)
                    .font(.faqHeadline)
                Text(vm.faqsA1)
                    .opacity(0.8)
            }
            .padding([.horizontal, .top])
            .padding(.trailing, .feedbackViewSpacing * 2)
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
            .lineSpacing(2)
            HStack { Spacer() }
        }
    }
}
