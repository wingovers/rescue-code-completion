// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import SwiftUI

struct RootDirectorySection: View {
    let factory: ViewControllerFactory
    var vm: RootDirectorySectionVM

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if vm.showSectionNames {
                sectionHeader
                    .padding(.top, 5)
            }
            todaysDirectories
            if vm.showOlderDirectories {
                olderDirectories
                    .padding(.top, 5)
            }
        }
    }

    var sectionHeader: some View {
        Text(vm.name)
            .font(.directoryStandard)
            .foregroundColor(.textFaded)
    }

    var todaysDirectories: some View {
        ForEach(vm.todaysTempDirectories) { directory in
            TempDirectoryBox(vm: factory.makeTempDirectoryVM(dir: directory, root: vm.id))
        }
    }

    @State var expandOlderDirectories = false
    @ViewBuilder
    var olderDirectories: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(vm.olderTempDirectoriesLabel)
                    .padding(.trailing, 5)
                Image(systemName: vm.directoriesExpansionIcon)
                    .rotationEffect(Angle(degrees: expandOlderDirectories ? 90 : 0))
                    .offset(y: expandOlderDirectories ? -1 : 0)
                Spacer()
            }.padding(.bottom, 3)
            .padding(.leading)
            .font(.olderDirectoriesTextImage)
            .foregroundColor(.textFaded)
            .contentShape(Rectangle())
            .onTapGesture { withAnimation {
                expandOlderDirectories.toggle()
            } }
            if expandOlderDirectories {
                olderDirectoriesList
                    .id(vm.id)
                    .transition(.opacity)
            }
        }
    }

    var olderDirectoriesList: some View {
        ForEach(vm.olderTempDirectories) { directory in
            TempDirectoryBox(vm: factory.makeTempDirectoryVM(dir: directory, root: vm.id))

        }
    }
}
