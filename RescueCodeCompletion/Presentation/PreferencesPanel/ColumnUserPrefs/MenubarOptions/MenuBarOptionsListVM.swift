//
//  MenuBarOptionsListVM.swift
//  Rescue Code Completion
//
//  Created by Ryan on 11/4/20.
//

import Foundation

class MenuBarOptionsListVM: VM {
    init(prefs: PreferencesRepo, login: LoginItemService) {
        self.prefsRepo = prefs
        self.login = login
        super.init(subscribe: prefs)
    }

    @Published private var prefsRepo: PreferencesRepo
    private let login: LoginItemService

    let showRecentsOnlyText = NSLocalizedString("option_show_today",
                                                comment: "option bullet")
    let reopenIDEText = NSLocalizedString("option_reopen_ide",
                                          comment: "option bullet")
    let reopenProjectText = NSLocalizedString("option_reopen_project",
                                              comment: "option bullet")
    let reopenProjectCaption = NSLocalizedString("option_reopen_project_caption",
                                                 comment: "option bullet caption")

    let startsAtLoginText = NSLocalizedString("option_start_login",
                                              comment: "option bullet")
    let iconLabel = NSLocalizedString("icon_header",
                                      comment: "header")


    var showRecentsOnly: Bool {
        prefsRepo.showRecentsOnly
    }

    var reopenXcode: Bool {
        prefsRepo.reopenXcode
    }

    var reopenProject: Bool {
        prefsRepo.reopenProject
    }

    var startsAtLogin: Bool {
        prefsRepo.startsAtLogin
    }

    var currentMenubarIcon: MenubarIcon {
        prefsRepo.menubarIcon
    }

    func setShowRecentsOnly(to newState: Bool) {
        prefsRepo.setShowRecentsOnly(to: newState)
    }

    func setShouldOpenDefaultIDEAfterDelete(to newState: Bool) {
        prefsRepo.setShouldOpenDefaultIDEAfterDelete(to: newState)
    }

    func setShouldOpenProjectAfterDelete(to newState: Bool) {
        prefsRepo.setShouldOpenProjectAfterDelete(to: newState)
    }

    func setStartsAtLogin(to newState: Bool) {
        prefsRepo.setStartsAtLogin(to: newState)
        login.setStartAtLoginTo(newState)
    }

    func setMenubarIconTo(_ icon: MenubarIcon) {
        prefsRepo.setMenubarIcon(to: icon)
    }
}
