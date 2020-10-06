//
//  UserSelectedContentColumn.swift
//  Rescue Code Completion
//
//  Created by Ryan on 11/4/20.
//

import SwiftUI

struct UserSelectedContentColumn: View {
    let vm: UserSelectedContentColumnVM
    let factory: ViewControllerFactory
    @StateObject var importerVM: ImporterVM

    init(factory: ViewControllerFactory) {
        self.factory = factory
        self.vm = factory.makeUserSelectedContentColumnVM()
        _importerVM = StateObject(wrappedValue: factory.makeImporterVM())
    }

    var body: some View {
        VStack {
            rootDirs
            ides
            projects
        }
    }

    var rootDirs: some View {
        VStack {
            PreferencesSectionTitle(title: vm.directoriesTitle, extraPadding: false)
                { ImporterView(type: .directories, vm: importerVM) }

            PrefsRootDirectoriesListView(vm: factory.makePrefsRootDirectoriesListVM())
        }
        .overlay(DragDropImporterView(type: .directories, vm: importerVM)
                    .allowsHitTesting(false))
    }

    var ides: some View {
        VStack {
            PreferencesSectionTitle(title: vm.idesTitle, extraPadding: false)
                { ImporterView(type: .Xcode, vm: importerVM) }

            PrefsIDEListView(vm: factory.makePrefsIDEsListVM())
        }
        .overlay(DragDropImporterView(type: .Xcode, vm: importerVM)
                    .allowsHitTesting(false))
    }

    var projects: some View {
        VStack {
            PreferencesSectionTitle(title: vm.projectsTitle, extraPadding: false)
                { ImporterView(type: .projects, vm: importerVM) }
            PrefsProjectsListView(vm: factory.makePrefsProjectListVM())
        }
        .overlay(DragDropImporterView(type: .projects, vm: importerVM)
                    .allowsHitTesting(false))
    }
}
