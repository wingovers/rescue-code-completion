//
//  PrefsProjectListView.swift
//  Rescue Code Completion
//
//  Created by Ryan on 11/4/20.
//

import SwiftUI

struct PrefsProjectsListView: View {
    @StateObject var vm: PrefsProjectListVM

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            if vm.showProjectsTipText {
                projectsTipText
            }
            ForEach(vm.projectDirectories) { project in
                PreferencesListRow(name: project.name,
                                   displayURL: project.displayURL,
                                   removeAction: vm.remove(_:),
                                   pinAction: vm.noPin(_:),
                                   id: project.id,
                                   isDefault: true,
                                   showPin: false
                )
            }.padding(.horizontal)
            .padding(.bottom, 15)
        }
    }

    var projectsTipText: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(vm.projectsListEmptyTipHeaderText)
                .font(.prefsItemHeader)
                .foregroundColor(.textNormal)
                .lineLimit(nil)
            Text(vm.projectsListEmptyTipHelpText1)
                .font(.standardTipText)
                .foregroundColor(.textMoreFaded)
                .lineLimit(nil)
            HStack { Spacer() }
        }.padding()
    }
}
