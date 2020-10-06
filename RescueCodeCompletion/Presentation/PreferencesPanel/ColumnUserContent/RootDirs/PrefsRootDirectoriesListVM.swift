//
//  PrefsRootDirectoriesListVM.swift
//  Rescue Code Completion
//
//  Created by Ryan on 11/4/20.
//

import Foundation

class PrefsRootDirectoriesListVM: VM {
    init(dirs: RootDirectoriesRepo) {
        self.dirsRepo = dirs
        super.init(subscribe: dirs)
    }

    @Published private var dirsRepo: RootDirectoriesRepo

    var rootDirectories: [DerivedDataRootDirectory] {
        dirsRepo.liveRootDirectories.sorted { (first, second) -> Bool in
            first.tempDirectories.count > second.tempDirectories.count
        }
    }

    var showDirectoriesTipText: Bool { rootDirectories.isEmpty }
    let directoriesListEmptyTipHeaderText = NSLocalizedString("setup_directories_tip1", comment: "empty list tutorial")
    let directoriesListEmptyTipHelpText1 = NSLocalizedString("setup_directories_tipQ", comment: "empty list tutorial")
    let directoriesListEmptyTipHelpText2 = NSLocalizedString("setup_directories_tipA", comment: "empty list tutorial")

    func remove(_ id: UUID) {
        dirsRepo.unwatch(id: id)
    }

    func setDefault(_ id: UUID) {
        dirsRepo.setDefault(to: id)
    }
}
