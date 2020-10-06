// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import XCTest
@testable import Rescue_Code_Completion


class UseCaseIntegrationTests: XCTestCase {

    func test_removesTargetDir_RestartsDefaultIDEAndProject() throws {
        let stubs = makeStubs()
        let sut = makeSubbedSUT(stubs)

        let temp = UUID()
        let root = UUID()
        let mockPath1 = "MockPath1"
        let mockPath2 = "MockPath2"
        let exp1 = expectation(description: "wait")
        let exp2 = expectation(description: "wait again")
        sut.removeDirectoryAndRestartDefaultIDE(temp: temp,
                                                in: root,
                                                projectPath: mockPath1) { didDelete in

            XCTAssertTrue(didDelete)
            exp1.fulfill()
        }
        sut.removeDirectoryAndRestartDefaultIDE(temp: temp,
                                                in: root,
                                                projectPath: mockPath2) { didDelete in
            XCTAssertTrue(didDelete)
            exp2.fulfill()
        }
        wait(for: [exp1, exp2], timeout: 1)

        XCTAssertTrue(stubs.deletor.deletes.contains(where: { (delTemp, delRoot) in
            delTemp == temp && delRoot == root
        }))
        XCTAssertEqual(stubs.deletor.deletes.count, 2)

        XCTAssertTrue(stubs.opener.openedPaths.contains(mockPath1))
        XCTAssertTrue(stubs.opener.openedPaths.contains(mockPath2))
        XCTAssertEqual(stubs.opener.openedPaths.count, 2)
    }

    func test_removesTargetDir_WithoutRestarting() throws {
        let prefs = StubbedPreferencesRepo()
        prefs.reopenXcode = false
        let stubs = makeStubs(overriding: prefs)
        let sut = makeSubbedSUT(stubs)

        let temp = UUID()
        let root = UUID()
        let mockPath = "MockPath"
        let exp = expectation(description: "wait")
        sut.removeDirectoryAndRestartDefaultIDE(temp: temp,
                                                in: root,
                                                projectPath: mockPath) { didDelete in
            XCTAssertTrue(didDelete)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)

        XCTAssertTrue(stubs.deletor.deletes.contains(where: { (delTemp, delRoot) in
            delTemp == temp && delRoot == root
        }))
        XCTAssertEqual(stubs.deletor.deletes.count, 1)

        XCTAssertFalse(stubs.opener.openedPaths.contains(mockPath))
        XCTAssertEqual(stubs.opener.openedPaths.count, 0)
    }

    func test_removesTargetDir_WithoutReopeningProject() throws {
        let prefs = StubbedPreferencesRepo()
        prefs.reopenProject = false
        let stubs = makeStubs(overriding: prefs)
        let sut = makeSubbedSUT(stubs)

        let temp = UUID()
        let root = UUID()
        let mockPath = "MockPath"
        let exp = expectation(description: "wait")
        sut.removeDirectoryAndRestartDefaultIDE(temp: temp,
                                                in: root,
                                                projectPath: mockPath) { didDelete in
            XCTAssertTrue(didDelete)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)

        XCTAssertTrue(stubs.deletor.deletes.contains(where: { (delTemp, delRoot) in
            delTemp == temp && delRoot == root
        }))
        XCTAssertEqual(stubs.deletor.deletes.count, 1)

        XCTAssertFalse(stubs.opener.openedPaths.contains(mockPath))
        XCTAssertEqual(stubs.opener.openedPaths.count, 1)
    }
}

extension UseCaseIntegrationTests {
    func makeSubbedSUT(_ stubs: Stubs) -> RestoreCodeCompletionUseCase {
        CodeCompletionRestorer(opener: stubs.opener,
                               deletor: stubs.deletor,
                               preferences: stubs.prefs)
    }

    func makeStubs(overriding prefs: StubbedPreferencesRepo? = nil) ->
    (opener: StubbedAppInteractor, deletor: StubbedDirectoryInteractor, prefs: StubbedPreferencesRepo)
    {
        guard let prefs = prefs else {
            return (StubbedAppInteractor(), StubbedDirectoryInteractor(), StubbedPreferencesRepo())
        }
        return (StubbedAppInteractor(), StubbedDirectoryInteractor(), prefs)
    }
}

typealias Stubs = (opener: AppInteractor,
                   deletor: DirectoryInteractor,
                   prefs: PreferencesRepo)
