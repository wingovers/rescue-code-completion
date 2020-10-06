//
//  PrefsIDEListView.swift
//  Rescue Code Completion
//
//  Created by Ryan on 11/4/20.
//

import SwiftUI

struct PrefsIDEListView: View {
    @ObservedObject var vm: PrefsIDEsListVM

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.vertical, showsIndicators: true) {
                if vm.showAppsTipText {
                    appsTipText
                }
                ForEach(vm.apps) { app in
                    PreferencesListRow(name: app.name,
                                       displayURL: app.displayURL,
                                       removeAction: vm.remove(_:),
                                       pinAction: vm.setDefault(_:),
                                       id: app.id,
                                       isDefault: app.isDefault)
                }.padding(.horizontal)
                .padding(.bottom, 15)
            }
        }
    }

    var appsTipText: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(vm.appsListEmptyTipHeaderText)
                .font(.prefsItemHeader)
                .foregroundColor(.textNormal)
                .lineLimit(nil)
            Text(vm.appsListEmptyTipHelpText1)
                .font(.standardTipText)
                .foregroundColor(.textMoreFaded)
                .lineLimit(nil)
            Text(vm.appsListEmptyTipHelpText2)
                .font(.standardTipText)
                .foregroundColor(.textMoreFaded)
                .lineLimit(nil)
            HStack { Spacer() }
        }.padding()
    }

}


