// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

protocol LoginItemService {
    func setStartAtLoginTo(_ state: Bool)
    func closeLoginHelper()
}
