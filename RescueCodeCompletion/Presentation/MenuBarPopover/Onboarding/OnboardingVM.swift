// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

struct OnboardingVM {
    init(actions: WindowManagement) {
        self.actions = actions
    }

    private let actions: WindowManagement


    let onboardingHeader = NSLocalizedString("onboarding_header",
                                             comment: "headline")

    let bullet1Text = NSLocalizedString("quit_xcode",
                                        comment: "step by step bullets")
    let bullet2Text = NSLocalizedString("tap_project_here",
                                        comment: "step by step bullets")
    let bullet3Text = NSLocalizedString("xcode_will_relaunch_sans_corrupted_indexes",
                                        comment: "step by step bullets")
    let buttonText = NSLocalizedString("setup_button",
                                       comment: "button")

    let bullet1Symbol = Symbols.close.name
    let bullet2Symbol = Symbols.cursor.name
    let bullet3Symbol = Symbols.bolt.name

    func buttonTap() {
        actions.openPreferences()
        actions.closeMenuBarPopover()
    }
}
