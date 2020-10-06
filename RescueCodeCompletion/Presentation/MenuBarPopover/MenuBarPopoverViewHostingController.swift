// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import AppKit

class MenuBarPopoverViewHostingController: NSViewController {
    init(_ repo: RootDirectoriesRepo) {
        self.repo = repo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("No storyboard")
    }

    weak var repo: RootDirectoriesRepo?

    override func viewDidAppear() {
        super.viewDidAppear()
        guard let repo = repo else { return }
        repo.refreshTempDirectories()
    }
}
