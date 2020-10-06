//
//  UserPreferencesColumn.swift
//  Rescue Code Completion
//
//  Created by Ryan on 11/4/20.
//

import SwiftUI

struct UserPreferencesColumn: View {
    let vm: UserPreferencesColumnVM
    let factory: ViewControllerFactory

    var body: some View {
        VStack {
            PreferencesSectionTitle(title: vm.menuBarTitle, extraPadding: true)
                { EmptyView() }
            MenuBarOptionsList(vm: factory.makeMenuBarOptionsListVM())

            PreferencesSectionTitle(title: vm.directoryRemovalTitle, extraPadding: true)
                { EmptyView() }
            DeleteOptionsListView(vm: factory.makeDeleteOptionsListVM())
        }
    }
}
