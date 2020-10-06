// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import AppKit

class XcodeReopener {
    init(repo: AppsRepo) { self.repo = repo }
    private let repo: AppsRepo

    private var defaultIDE: URL? {
        repo.liveXcodeApps.first { $0.isDefault }?.restoredURL
    }
}

extension XcodeReopener: AppInteractor {
    func openDefaultIDE(with projectPath: String) {
        guard let ideURL = defaultIDE else { return }
        let config = NSWorkspace.OpenConfiguration()
        config.createsNewApplicationInstance = false

        if let projectURL = accessibleURL(projectPath) {
            NSWorkspace.shared.open([projectURL],
                                    withApplicationAt: ideURL,
                                    configuration: config) { (_, _) in }
        } else {
            NSWorkspace.shared.openApplication(at: ideURL,
                                               configuration: config) { (_, _) in }
        }
    }

    private func accessibleURL(_ path: String) -> URL? {
        let url = URL(fileURLWithPath: path)
        guard let isReachable = try? url.checkResourceIsReachable(),
              isReachable
        else { return nil }
        return url
    }
}
