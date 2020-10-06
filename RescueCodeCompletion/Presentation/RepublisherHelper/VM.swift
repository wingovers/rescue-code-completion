// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation
import Combine

class VM: ObservableObject {
    private var repoSubscriptions = Set<AnyCancellable>()

    init(subscribe repos: Republisher...) {
        repos.forEach { repo in
            repo.objectWillChange
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] _ in
                    self?.objectWillChange.send()
                })
                .store(in: &repoSubscriptions)
        }
    }
}
