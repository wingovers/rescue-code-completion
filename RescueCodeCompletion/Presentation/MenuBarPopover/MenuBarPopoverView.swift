// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import SwiftUI

struct MenuBarPopoverView: View {
    init(factory: ViewControllerFactory) {
        self.factory = factory
        _vm = StateObject(wrappedValue: factory.makeMenuBarPopoverVM())
    }
    let factory: ViewControllerFactory
    @StateObject var vm: MenuBarPopoverVM
    @State var hoveredApp = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if vm.showOnboarding { onboarding }
            else { menu }
        }
        .padding()
        .frame(width: .menuBarPopoverWidth)
        .frame(maxHeight: .menuBarPopoverHeight)
    }

    var menu: some View {
        VStack(alignment: .leading, spacing: 0) {
            directoriesList
            Divider()
            HStack {
                ideList
                Spacer()
                preferencesButton
                quitButton
            }
            .padding(.top, 4)
            .padding(.horizontal, 4)
        }
    }

    var onboarding: some View {
        OnboardingView(vm: factory.makeOnboardingVM())
    }

    var directoriesList: some View {
        ScrollView(.vertical) {
            ForEach(vm.rootDirectories) { directory in
                RootDirectorySection(factory: factory, vm: factory.makeRootDirectoryVM(root: directory))
            }
        }
    }

    var ideList: some View {
        HStack(alignment: .top, spacing: .ideIconSpacing) {
            ForEach(vm.apps) { app in
                    Button { vm.setDefault(Xcode: app.id) }
                        label: {
                            IDEButton(vm: factory.makeIDEButtonVM(ide: app))
                                .onHover { isHovering in
                                    hoveredApp = isHovering
                                        ? app.name
                                        : ""
                                }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                .overlay(nameOverlay
                            .opacity(app.name == hoveredApp ? 1 : 0),
                         alignment: .bottomLeading)
            }
        }
    }

    var nameOverlay: some View {
        Text(hoveredApp)
            .font(.iconSubtitle)
            .foregroundColor(.hoverOnGrayscale)
            .fixedSize(horizontal: true, vertical: false)
            .offset(x: 3, y: 15)
    }

    var preferencesButton: some View {
        PreferencesButtonLabel(vm: factory.makePreferencesButtonVM())
    }

    var quitButton: some View {
        QuitAppButton(vm: factory.makeQuitButtonVM())
    }
}
