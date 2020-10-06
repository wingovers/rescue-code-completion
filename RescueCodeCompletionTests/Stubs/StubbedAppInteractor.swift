// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation
@testable import Rescue_Code_Completion

typealias OpenedPaths = String
class StubbedAppInteractor: AppInteractor {
    var openedPaths = [OpenedPaths]()

    func openDefaultIDE(with projectPath: String) {
        openedPaths.append(projectPath)
    }
}
