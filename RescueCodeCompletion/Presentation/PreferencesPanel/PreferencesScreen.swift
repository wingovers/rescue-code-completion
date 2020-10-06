//
//  PreferencesPanelComposerView.swift
//  Rescue Code Completion
//
//  Created by Ryan on 11/4/20.
//

import SwiftUI

struct PreferencesScreen: View {
    let factory: ViewControllerFactory

    var body: some View {
        VStack {
            HStack {
                userSelectedContentColumn
                    .padding(.horizontal)
                Divider()
                    .padding(.bottom)
                preferencesColumn
                    .padding(.horizontal)
                    .frame(maxWidth: .preferencesRightColumnMaxWidth)
            }
            .padding()
            .padding(.top)
        }
    }

    var userSelectedContentColumn: some View {
        UserSelectedContentColumn(factory: factory)
    }

    var preferencesColumn: some View {
        UserPreferencesColumn(vm: factory.makeUserPreferencesColumnVM(), factory: factory)
    }
}
