//
//  PrefsProjectListVM.swift
//  Rescue Code Completion
//
//  Created by Ryan on 11/4/20.
//

import Foundation

class PrefsProjectListVM: VM {
    init(projects: ProjectDirectoriesRepo) {
        self.projectsRepo = projects
        super.init(subscribe: projects)
    }

    @Published var projectsRepo: ProjectDirectoriesRepo

    var projectDirectories: [ProjectDirectory] {
        projectsRepo.liveProjectDirectories.sorted { (first, second) -> Bool in
            first.name > second.name
        }
    }

    var showProjectsTipText: Bool { projectDirectories.isEmpty }

    let projectsListEmptyTipHeaderText = NSLocalizedString("setup_projects_header", comment: "header")
    let projectsListEmptyTipHelpText1 = NSLocalizedString("setup_projects_tip1", comment: "header")

    func remove(_ id: UUID) {
        projectsRepo.unwatch(id: id)
    }

    func noPin(_ id: UUID) {}
}
