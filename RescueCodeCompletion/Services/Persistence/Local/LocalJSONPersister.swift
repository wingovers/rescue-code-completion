// Copyright 2020 by Ryan Ferrell. All rights reserved. Contact at github.com/wingovers

import Foundation

class LocalJSONPersister {}

extension LocalJSONPersister: LocalPersistence {

    func persist<T: Encodable>(_ data: T, _ file: Filename) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        guard let url = validURL(for: file),
              let data = try? encoder.encode(data),
              let json = String(data: data, encoding: .utf8) else {
            return
        }
        try? json.write(to: url, atomically: true, encoding: .utf8)
    }

    func load<T: Decodable>(_ type: T.Type, _ file: Filename) -> T? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let url = validURL(for: file),
              let dataString = try? String(contentsOf: url, encoding: .utf8),
              let data = dataString.data(using: String.Encoding.utf8),
              let loaded = try? decoder.decode(type.self, from: data)
        else { return nil }
        return loaded
    }

    private func validURL(for file: Filename) -> URL? {
        guard let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else { return nil }
        guard directoryIsPresentOrCreatedAt(url.path) else { return nil }
        let fileURL = url
            .appendingPathComponent(file.rawValue)
            .appendingPathExtension(for: .json)

        return fileURL
    }

    private func directoryIsPresentOrCreatedAt(_ path: String) -> Bool {
        var directoryBool = ObjCBool(true)
        if FileManager.default.fileExists(atPath: path, isDirectory: &directoryBool) { return true }
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
            return true
        } catch {
            return false
        }
    }
}
