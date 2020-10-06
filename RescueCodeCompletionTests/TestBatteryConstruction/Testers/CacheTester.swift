// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import XCTest

class CacheTester {
    init(test: Battery) {
        self.test = test
    }
    private let test: Battery
}

extension CacheTester: Tester {
    func run(completion: @escaping (Test) -> Void) {
        try! writeMockDirsToCacheLocation(mock: test) { mockURL in
            completion(Test(mockDataURL: mockURL!, test: self.test))
        }
    }
}

extension CacheTester {
    func writeMockDirsToCacheLocation(mock: Battery, completion: @escaping (URL?) -> Void) throws {
        guard let cacheURL = try? getCacheURL() else { return }

        writeDirectory(appending: mock.name,
                       in: cacheURL) { rootMockDirURL in
            guard let rootURL = rootMockDirURL else { return }

            mock.tempDirectories.forEach { tempDir in
                self.writeDirectory(appending: tempDir.tempFolderName, in: rootURL)
                { tempDirURL in

                    guard let url = tempDirURL else { return }
                    self.writePlist(tempDir.infoPlist,
                                    to: url) { plistURL in

                        if let last = mock.tempDirectories.last,
                           last.test == tempDir.test {
                            completion(rootMockDirURL)
                        }
                    }
                }
            }
        }
    }

    func writeDirectory(appending name: String, in base: URL, completion: @escaping (URL?) -> Void) {
        let url = base.appendingPathComponent(name, isDirectory: true)
        do {
            if FileManager.default.fileExists(atPath: url.path, isDirectory: nil) {
                try FileManager.default.removeItem(at: url)
            }
            try FileManager.default.createDirectory(at: url,
                                                    withIntermediateDirectories: false,
                                                    attributes: nil)
            completion(url)
        } catch let error {
            XCTFail(error.localizedDescription)
            completion(nil)
        }
    }

    func writePlist(_ contents: String, to base: URL, completion: @escaping (URL?) -> Void) {
        let url = base.appendingPathComponent("Info", conformingTo: .propertyList)
        let plist = contents.data(using: .utf16)
        do {
            try plist?.write(to: url, options: .atomicWrite)
            completion(url)
        } catch {
            XCTFail()
            completion(nil)
        }
    }

    func getCacheURL() throws -> URL {
        let caches = FileManager.default.urls(for: .cachesDirectory,
                                              in: .userDomainMask)
        let cache = try XCTUnwrap(caches.first)
        XCTAssertNoThrow(try cache.checkResourceIsReachable(), "Cache unreachable for unit testing")
        return cache
    }
}
