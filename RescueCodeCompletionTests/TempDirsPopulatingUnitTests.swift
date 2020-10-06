// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import XCTest
@testable import Rescue_Code_Completion

class TempDirectoriesPopulatingTests: XCTestCase {

    let sut = makeSUT()

    static func makeSUT() -> TempDirectoriesPopulating {
        TempDirectoriesPopulator()
    }

    func runTest(_ test: Battery, completion: @escaping (Test) -> Void) {
        let tester: Tester = CacheTester(test: test)
        tester.run { completion($0) }
    }

    func testParsesAllDirsPresent() {
        runTest(FourFolderTestBattery()) { test in
            let results = self.sut.populateTemps(in: test.mockDataURL)
            XCTAssertEqual(results.count, test.test.tempDirectories.count)
        }
    }

    func testReturnsNothingIfNoDirsPresent() {
        runTest(NoFoldersTestBattery()) { test in
            let results = self.sut.populateTemps(in: test.mockDataURL)
            XCTAssertEqual(results.count, test.test.tempDirectories.count)
        }
    }

    func testParsesValidAndInvalidDirNamesPlistFieldsProperly() throws {
        runTest(FourFolderTestBattery())  { test in
            var results = self.sut.populateTemps(in: test.mockDataURL)
            results.sortAlphaForReadoutPurposes()

            test.test.tempDirectories.enumerated().forEach {
                let result = results[$0.offset]
                let answer = test.test.tempDirectories[$0.offset]
                let comment = "Test Scenario: \(answer.plist.rawValue)"

                switch answer.plist {
                    case .absent, .invalidKey:
                        XCTAssertEqual(result.name, answer.answerName, comment)
                        XCTAssertEqual(result.xcodeprojPath, answer.answerXcodeProjectPath, comment)
                        XCTAssertTrue(result.updated.distance(to: answer.answerDate) < 60, comment)
                    default:
                        XCTAssertEqual(result.name, answer.answerName, comment)
                        XCTAssertEqual(result.xcodeprojPath, answer.answerXcodeProjectPath, comment)
                        XCTAssertEqual(result.updated, answer.answerDate, comment)

                }
            }
        }
    }
}
