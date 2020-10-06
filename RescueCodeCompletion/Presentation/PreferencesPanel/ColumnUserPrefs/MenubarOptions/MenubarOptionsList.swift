//
//  MenubarOptionsList.swift
//  Rescue Code Completion
//
//  Created by Ryan on 11/4/20.
//

import SwiftUI

struct MenuBarOptionsList: View {
    @ObservedObject var vm: MenuBarOptionsListVM

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                PreferencesCheckmarkGroup(optionText: vm.showRecentsOnlyText,
                                          captionText: nil,
                                          isSelected: showRecentsOnly)
                PreferencesCheckmarkGroup(optionText: vm.reopenIDEText,
                                          captionText: nil,
                                          isSelected: reopenXcode)
                PreferencesCheckmarkGroup(optionText: vm.reopenProjectText,
                                          captionText: vm.reopenProjectCaption,
                                          isSelected: reopenProject)
                PreferencesCheckmarkGroup(optionText: vm.startsAtLoginText,
                                          captionText: nil,
                                          isSelected: startsAtLogin)
                menubarIcons
                    .padding(.top)
                    .padding(.top)
                HStack { Spacer() }
            }.padding(.horizontal)
        }
        .padding(.top, 8)
    }

    var menubarIcons: some View {
        HStack(alignment: .center, spacing: 2) {
            Text(vm.iconLabel)
                .font(.prefsMenubarIconsLabel)
                .fontWeight(.medium)
                .foregroundColor(.textMoreFaded)
                .padding(.trailing)
            ForEach(MenubarIcon.allCases) { icon in
                PreferenceIconChoiceRow(icon: icon,
                                        choose: vm.setMenubarIconTo(_:),
                                        current: vm.currentMenubarIcon)
            }
            Spacer()
        }
    }

    var showRecentsOnly: Binding<Bool> {
        Binding<Bool>(
            get: { vm.showRecentsOnly },
            set: { newValue in withAnimation { vm.setShowRecentsOnly(to: newValue) } }
        )
    }
    var reopenXcode: Binding<Bool> {
        Binding<Bool>(
            get: { vm.reopenXcode },
            set: { newValue in withAnimation { vm.setShouldOpenDefaultIDEAfterDelete(to: newValue) } }
        )
    }
    var reopenProject: Binding<Bool> {
        Binding<Bool>(
            get: { vm.reopenProject },
            set: { newValue in withAnimation { vm.setShouldOpenProjectAfterDelete(to: newValue) } }
        )
    }
    var startsAtLogin: Binding<Bool> {
        Binding<Bool>(
            get: { vm.startsAtLogin },
            set: { newValue in withAnimation { vm.setStartsAtLogin(to: newValue) } }
        )
    }
}
