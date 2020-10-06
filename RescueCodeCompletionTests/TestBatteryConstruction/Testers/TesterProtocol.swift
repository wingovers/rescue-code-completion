// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import XCTest

protocol Tester {
    func run(completion: @escaping (Test) -> Void)
}


