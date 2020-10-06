// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import XCTest
@testable import Rescue_Code_Completion

class PersistenceIntegrationTests: XCTestCase {

    let sut = makeSUT()

    static func makeSUT() -> PersistenceCoordinating {
        let local = LocalJSONPersister()
        clearTestDirectory()
        return PersistenceCoordinator(local: local)
    }

    func test_persistAndLoadFullPayload() throws {
        let testRequest = makeFilledOutTestRequest()

        sut.persist(testRequest)
        let loaded = sut.loadData()

        let loadedRoots = try XCTUnwrap(loaded.rootDirectories)
        let loadedXcodes = try XCTUnwrap(loaded.xcodes)
        let loadedPrefs = try XCTUnwrap(loaded.preferences)
        let loadedProjects = try XCTUnwrap(loaded.projectDirectories)

        XCTAssertEqual(loadedRoots, testRequest.rootDirectories)
        XCTAssertEqual(loadedXcodes, testRequest.xcodes)
        XCTAssertEqual(loadedPrefs.current.count, testRequest.preferences?.current.count)
        XCTAssertEqual(loadedProjects, testRequest.projectDirectories)
    }

    func test_persistAndLoadEmptyPayload() throws {
        let testRequest = makeNilTestRequest()

        sut.persist(testRequest)
        let loaded = sut.loadData()

        let loadedRoots = try XCTUnwrap(loaded.rootDirectories)
        let loadedXcodes = try XCTUnwrap(loaded.xcodes)
        let loadedPrefs = try XCTUnwrap(loaded.preferences)
        let loadedProjects = try XCTUnwrap(loaded.projectDirectories)

        XCTAssertEqual(loadedRoots, [])
        XCTAssertEqual(loadedXcodes, [])
        XCTAssertEqual(loadedPrefs.current.count, Preferences.Preference.allCases.count)
        XCTAssertEqual(loadedProjects, [])
    }
}

extension PersistenceIntegrationTests {
    func makeFilledOutTestRequest() -> PersistRequest {
        let roots = [DerivedDataRootDirectory(id: UUID(),
                                              name: "RootTest",
                                              ssBookmark: Data(),
                                              isDefault: true)]

        let xcodes = [Xcode(id: UUID(),
                            name: "XcodeTest",
                            ssBookmark: Data(),
                            isDefault: true)]

        let preferences = Preferences(current:[.deletesPermanently:false],
                                      menubarIcon: .filled)

        let projects = [ProjectDirectory(id: UUID(),
                                         name: "ProjectTest",
                                         ssBookmark: Data())]

        return PersistRequest(rootDirectories: roots,
                              xcodes: xcodes,
                              preferences: preferences,
                              projectDirectories: projects)
    }

    func makeNilTestRequest() -> PersistRequest {
        PersistRequest(rootDirectories: nil,
                       xcodes: nil,
                       preferences: nil,
                       projectDirectories: nil)
    }

    static func clearTestDirectory() {
        guard let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else { return }
        try? FileManager.default.removeItem(at: url)
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
    }
}
