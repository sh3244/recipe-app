import Foundation

private var documentDirectory: NSString {
    let searchPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    return searchPath as NSString
}

/// For cache purposes
private var cachesDirectory: NSString {
    let searchPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
    return searchPath[searchPath.count - 1] as NSString
}

public let cacheDirectoryPath = cachesDirectory.appendingPathComponent("cache")
public let cacheDirectoryURL = URL(fileURLWithPath: cacheDirectoryPath)

class ImageCacheManager {
    static let shared = ImageCacheManager()

    init() {
        createCacheDirectory()
    }

    private func createCacheDirectory() {
        try? FileManager.default.createDirectory(at: cacheDirectoryURL, withIntermediateDirectories: true, attributes: nil)
    }

    func escape(string: String) -> String {
        let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    }

    func localURL(for url: URL) -> URL {
        let fileName = escape(string: url.absoluteString)
        return cacheDirectoryURL.appendingPathComponent(fileName)
    }

    func cachedImageURL(for url: URL) async -> URL? {
        let localURL = self.localURL(for: url)
        if FileManager.default.fileExists(atPath: localURL.path) {
            return localURL
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            try data.write(to: localURL)
            return localURL
        } catch {
            print("Error downloading or saving image: \(error)")
            return nil
        }
    }
}
