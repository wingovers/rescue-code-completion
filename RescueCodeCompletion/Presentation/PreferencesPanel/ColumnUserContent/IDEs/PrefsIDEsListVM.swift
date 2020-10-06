//
//  PrefsIDEsListVM.swift
//  Rescue Code Completion
//
//  Created by Ryan on 11/4/20.
//

import Foundation

class PrefsIDEsListVM: VM {
    init(appsRepo: AppsRepo) {
        self.appsRepo = appsRepo
        super.init(subscribe: appsRepo)
    }

    @Published var appsRepo: AppsRepo

    var apps: [Xcode] {
        appsRepo.liveXcodeApps.sorted { (first, second) -> Bool in
            first.name < second.name
        }
    }

    var showAppsTipText: Bool { apps.isEmpty }
    let appsListEmptyTipHeaderText = NSLocalizedString("setup_ides_tip1", comment: "tutorial")
    let appsListEmptyTipHelpText1 = NSLocalizedString("setup_ides_tip2", comment: "tutorial")
    let appsListEmptyTipHelpText2 = NSLocalizedString("setup_ides_tip3", comment: "tutorial")

    func remove(_ id: UUID) {
        appsRepo.unwatch(id: id)
    }

    func setDefault(_ id: UUID) {
        appsRepo.setDefault(to: id)
    }
}
