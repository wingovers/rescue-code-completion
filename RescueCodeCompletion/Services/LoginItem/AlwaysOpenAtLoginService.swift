// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import AppKit
import ServiceManagement

import OSLog

let logger = Logger.init(subsystem: "RescueLogin", category: "trouble")

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}

class AlwaysOpenOnLogin: LoginItemService {
    init(prefs: PreferencesRepo) {
        setStartAtLoginTo(prefs.startsAtLogin)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.closeLoginHelper()
        }
    }

    private let launchHelperName = "com.wingovers.RescueCodeCompletionLoginItem"

    func setStartAtLoginTo(_ state: Bool) {
        let _ = SMLoginItemSetEnabled(launchHelperName as CFString, false)
        let result = SMLoginItemSetEnabled(launchHelperName as CFString, state)
        logger.debug("\(#function) Main app set login item \(result), state: \(state)")
    }

    func closeLoginHelper() {
        let isRunning = NSWorkspace.shared.runningApplications.contains {
            $0.bundleIdentifier == launchHelperName
        }
        if isRunning {
            DistributedNotificationCenter.default()
                .post(name: .killLauncher,
                      object: Bundle.main.bundleIdentifier!)
        }
    }
}
