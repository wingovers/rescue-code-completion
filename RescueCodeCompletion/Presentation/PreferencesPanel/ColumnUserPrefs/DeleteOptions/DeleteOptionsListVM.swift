//
//  DeleteOptionsListVM.swift
//  Rescue Code Completion
//
//  Created by Ryan on 11/4/20.
//

import Foundation

class DeleteOptionsListVM: VM {
    init(prefs: PreferencesRepo) {
        self.prefsRepo = prefs
        super.init(subscribe: prefs)
    }

    @Published private var prefsRepo: PreferencesRepo

    let deletePermanentlyText = NSLocalizedString("option_delete_permanently",
                                                  comment: "option bullet")
    let moveToTrashText = NSLocalizedString("option_move_trash",
                                            comment: "option bullet")

    var deletesPermanently: Bool {
        prefsRepo.deletesPermanently
    }

    func setShouldDeletePermanently(to newState: Bool) {
        prefsRepo.setShouldDeletePermanently(to: newState)
    }
}
