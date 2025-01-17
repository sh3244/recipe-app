import UIKit
import SwiftUI

extension FileManager {
    static func logFolder() -> String {
        let folder = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/logs"
        try? FileManager.default.createDirectory(atPath: folder, withIntermediateDirectories: true, attributes: nil)
        return folder
    }

    /// Saves an image to the specified path within the cache directory.
    func saveImage(_ image: UIImage, to directory: String, withFileName fileName: String) -> Bool {
        let path = (directory as NSString).appendingPathComponent(fileName)

        // Check and create directory if needed
        if !fileExists(atPath: directory) {
            do {
                try createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating directory: \(error)")
                return false
            }
        }

        // Convert image to data and save it
        if let data = image.jpegData(compressionQuality: 1.0) { // or .pngData() if you prefer PNG
            return createFile(atPath: path, contents: data, attributes: nil)
        }

        return false
    }

    static func createCacheDirectories() {
        [cacheDirectoryPath].forEach {
            do {
                try FileManager.default.createDirectory(atPath: $0, withIntermediateDirectories: true, attributes: nil)
            } catch _ { }
        }
    }

    static func clearCacheDirectories() {
        [cacheDirectoryPath].forEach {
            do {
                if FileManager.default.fileExists(atPath: $0) {
                    try FileManager.default.removeItem(atPath: $0)
                }
            } catch _ { }
        }
    }

    func data(atPath path: String) -> Data? {
        if fileExists(atPath: path) {
            return contents(atPath: path)
        }
        return nil
    }

    func save(data: Data, atPath path: String) {
        createFile(atPath: path, contents: data, attributes: nil)
    }

    // static func removeMedia(urls: [URL]) {
    //     urls.forEach { url in
    //         delete(url: url)
    //     }
    // }
    func clearContentsOfDirectory(atPath: String) throws {
        if fileExists(atPath: atPath) {
            try removeItem(atPath: "\(atPath)")
        }

    }
}

extension FileManager {
    /// Used with DiskCache
    func enumerateContentsOfDirectory(atPath path: String, orderedByProperty property: String, ascending: Bool, usingBlock block: (URL, Int, inout Bool) -> Void ) {
        let directoryURL = URL(fileURLWithPath: path)
        do {
            let contents = try self.contentsOfDirectory(at: directoryURL,
                                                        includingPropertiesForKeys: [URLResourceKey(rawValue: property)],
                                                        options: FileManager.DirectoryEnumerationOptions())
            let sortedContents = contents.sorted(by: {(URL1: URL, URL2: URL) -> Bool  in
                // Maybe there's a better way to do this. See: http://stackoverflow.com/questions/25502914/comparing-anyobject-in-swift

                var value1: AnyObject?
                do {
                    try (URL1 as NSURL).getResourceValue(&value1, forKey: URLResourceKey(rawValue: property))
                } catch {
                    return true
                }
                var value2: AnyObject?
                do {
                    try (URL2 as NSURL).getResourceValue(&value2, forKey: URLResourceKey(rawValue: property))
                } catch {
                    return false
                }

                if let string1 = value1 as? String, let string2 = value2 as? String {
                    return ascending ? string1 < string2: string2 < string1
                }

                if let date1 = value1 as? Date, let date2 = value2 as? Date {
                    return ascending ? date1 < date2: date2 < date1
                }

                if let number1 = value1 as? NSNumber, let number2 = value2 as? NSNumber {
                    return ascending ? number1.intValue < number2.intValue: number2.intValue < number1.intValue
                }

                return false
            })

            for (idx, value) in sortedContents.enumerated() {
                var stop: Bool = false
                block(value, idx, &stop)
                if stop { break }
            }

        } catch {
        }
    }
}
