//
//  AboutColumnView.swift
//  Rescue Code Completion
//
//  Created by Ryan on 11/4/20.
//

import SwiftUI

struct AboutColumnView: View {
    let vm: AboutColumnVM
    var body: some View {
        VStack(alignment: .leading, spacing: .feedbackViewSpacing) {
            Image(nsImage: NSImage(named: vm.appIconBundleName) ?? NSImage())
                .resizable()
                .scaledToFit()
                .frame(width: .feedbackAboutColumnWidth)
            Text(vm.appName)
                .font(.sectionTitle)
                .fontWeight(.medium)
            Text(vm.copyright)
            Spacer()
            Group {
                Text(vm.automationJoke)
                    .padding(.trailing)
                Link(destination: vm.xkcdLink) {
                    Text(vm.xkcdLinkLabel)
                        .foregroundColor(.linkColor)
                }
            }.opacity(0.8)
            Spacer()
            Text(vm.outsideCopyrights)
        }
        .font(.aboutColumnText)
    }
}
