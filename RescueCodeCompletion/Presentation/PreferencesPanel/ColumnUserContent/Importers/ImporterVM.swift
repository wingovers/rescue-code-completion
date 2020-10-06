//
//  ImporterVM.swift
//  Rescue Code Completion
//
//  Created by Ryan on 11/4/20.
//

import Foundation


enum ImporterType {
    case Xcode, projects, directories
}

enum ImportError: Error {
    case failed
}


class ImporterVM: VM {
    private let appsRepo: AppsRepo
    private let dirsRepo: RootDirectoriesRepo
    private let projectsRepo: ProjectDirectoriesRepo

    init(apps: AppsRepo, dirs: RootDirectoriesRepo, projects: ProjectDirectoriesRepo) {
        self.appsRepo = apps
        self.dirsRepo = dirs
        self.projectsRepo = projects
        super.init(subscribe: apps, dirs, projects)
    }

    @Published private(set) var error: String? = nil
    let addButtonSymbol = Symbols.directoryAdd.name

    var rootDirectories: [DerivedDataRootDirectory] {
        dirsRepo.liveRootDirectories
    }
    var apps: [Xcode] {
        appsRepo.liveXcodeApps
    }
    var projectDirectories: [ProjectDirectory] {
        projectsRepo.liveProjectDirectories
    }

    var showAppsTipText: Bool { apps.isEmpty }
    var showDirectoriesTipText: Bool { rootDirectories.isEmpty }
    var showProjectsTipText: Bool { projectDirectories.isEmpty }

    let importError = NSLocalizedString("import_permissions_error", comment: "error")
    let fileTypeIdentifier = "public.file-url"

    func add(type: ImporterType, _ imported: Result<[URL], Error>) {
        guard let url = try? imported.get().first else {
            error = importError
            return
        }
        switch type {
            case .Xcode: appsRepo.add(app: url)
            case .projects: projectsRepo.add(url: url)
            case .directories: dirsRepo.add(url: url)
        }
    }

    func canImportFrom(_ providers: [NSItemProvider]) -> Bool {
        providers.map({
            $0.hasItemConformingToTypeIdentifier(fileTypeIdentifier)
        }).contains(true)
    }

    func importFrom(_ providers: [NSItemProvider], for type: ImporterType) {
        providers.forEach { [weak self] provider in
            DispatchQueue.global().async {
                self?.loadItemFrom(provider, for: type)
            }
        }
    }

    private func loadItemFrom(_ provider: NSItemProvider, for type: ImporterType) {
        provider.loadItem(forTypeIdentifier: fileTypeIdentifier, options: nil) { [weak self] (data, error) in
            self?.convertDataToImportResult(data, error) { [weak self] in
                self?.add(type: type, $0)
            }
        }
    }

    private func convertDataToImportResult(_ data: NSSecureCoding?, _ error: Error?, completion: @escaping (Result<[URL], Error>) -> Void) {

        if let data = data as? Data,
           let url = URL(dataRepresentation: data, relativeTo: nil) {
            completion(.success([url]))
        } else {
            completion(.failure(error ?? ImportError.failed))
        }
    }
}
