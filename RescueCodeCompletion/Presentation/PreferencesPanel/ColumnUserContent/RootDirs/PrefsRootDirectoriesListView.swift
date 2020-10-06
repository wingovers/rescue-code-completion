//
//  PrefsRootDirectoriesListView.swift
//  Rescue Code Completion
//
//  Created by Ryan on 11/4/20.
//

import SwiftUI

struct PrefsRootDirectoriesListView: View {
    @ObservedObject var vm: PrefsRootDirectoriesListVM

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.vertical, showsIndicators: true) {
                if vm.showDirectoriesTipText {
                    rootDirectoriesTipText
                }
                ForEach(vm.rootDirectories) { root in
                    PreferencesListRow(name: root.name,
                                       displayURL: root.displayURL,
                                       removeAction: vm.remove(_:),
                                       pinAction: vm.setDefault(_:),
                                       id: root.id,
                                       isDefault: root.isDefault
                    )
                }.padding(.horizontal)
                .padding(.bottom, 15)
            }
        }
    }

    var rootDirectoriesTipText: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(vm.directoriesListEmptyTipHeaderText)
                .font(.prefsItemHeader)
                .foregroundColor(.textNormal)
                .lineLimit(nil)
            Text(vm.directoriesListEmptyTipHelpText1)
                .font(.standardTipText)
                .foregroundColor(.textMoreFaded)
                .lineLimit(nil)
            Text(vm.directoriesListEmptyTipHelpText2)
                .font(.standardTipText)
                .foregroundColor(.textMoreFaded)
                .lineLimit(nil)
            HStack { Spacer() }
        }.padding()
    }

}

