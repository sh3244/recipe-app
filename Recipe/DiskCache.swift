import UIKit
import Foundation

open class DiskCache {
    open lazy var cacheQueue: DispatchQueue = {
        let queueName = "diskcache." + (directory.path as NSString).lastPathComponent
        return DispatchQueue(label: queueName, attributes: [])
    }()

    let directory: URL

    open var size: UInt64 = 0
    open var capacity: UInt64 = 0 {
        didSet {
            self.cacheQueue.async {
                self.controlCapacity()
            }
        }
    }

    public init(directory: URL, capacity: UInt64 = UINT64_MAX) {
        self.directory = directory
        self.capacity = capacity
        self.cacheQueue.async {
            self.calculateSize()
            self.controlCapacity()
        }
    }

    open func addURL(_ url: URL) {
        guard urlInPath(url) else {
            return
        }
        cacheQueue.async {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: url.path) {
                self.addFileURLSync(url)
            }
        }
    }

    open func removeURL(_ url: URL) {
        guard urlInPath(url) else {
            return
        }
        cacheQueue.async {
            self.removeFile(atPath: url.path)
        }
    }

    open func removeAllURLs(_ completion: (() -> Void)? = nil) {
        let fileManager = FileManager.default
        cacheQueue.async {
            do {
                let contents = try fileManager.contentsOfDirectory(atPath: self.directory.path)
                for pathComponent in contents {
                    let path = self.directory.appendingPathComponent(pathComponent).path
                    do {
                        try fileManager.removeItem(atPath: path)
                    } catch {
                    }
                }
                self.calculateSize()
            } catch {
            }
            if let completion = completion {
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }

    open func updateAccessDate(_ url: URL) {
        guard urlInPath(url) else {
            return
        }
        cacheQueue.async {
            self.updateDiskAccessDate(atPath: url.path)
        }
    }

    // MARK: - Private

    fileprivate func urlInPath(_ url: URL) -> Bool {
        return url.path.hasPrefix(url.path)
    }

    fileprivate func calculateSize() {
        let fileManager = FileManager.default
        size = 0

        if let contents = try? fileManager.contentsOfDirectory(atPath: directory.path) {
            for pathComponent in contents {
                let path = directory.appendingPathComponent(pathComponent).path
                if let attributes: [FileAttributeKey: Any] = try? fileManager.attributesOfItem(atPath: path), let fileSize = attributes[FileAttributeKey.size] as? UInt64 {
                    size += fileSize
                }
            }
        }
    }

    fileprivate func controlCapacity() {
        if self.size <= self.capacity { return }
        FileManager.default.enumerateContentsOfDirectory(atPath: directory.path, orderedByProperty: URLResourceKey.contentModificationDateKey.rawValue, ascending: true) { (url, _, _) in
            self.removeFile(atPath: url.path)
        }
    }

    fileprivate func subtract(size: UInt64) {
        if self.size >= size {
            self.size -= size
        } else {
            self.size = 0
        }
    }

    fileprivate func addFileURLSync(_ url: URL) {
        let fileManager = FileManager.default
        let attributes: [FileAttributeKey: Any]? = try? fileManager.attributesOfItem(atPath: url.path)

        if let attributes = attributes, let size = attributes[FileAttributeKey.size] as? UInt64 {
            self.size += size
        }

        self.updateDiskAccessDate(atPath: url.path)
        self.controlCapacity()
    }

    fileprivate func removeFile(atPath path: String) {
        let fileManager = FileManager.default
        do {
            let attributes: [FileAttributeKey: Any] = try fileManager.attributesOfItem(atPath: path)
            do {
                try fileManager.removeItem(atPath: path)
                if let fileSize = attributes[FileAttributeKey.size] as? UInt64 {
                    subtract(size: fileSize)
                }
            } catch {
            }
        } catch {
        }
    }

    @discardableResult fileprivate func updateDiskAccessDate(atPath path: String) -> Bool {
        let fileManager = FileManager.default
        let now = Date()
        do {
            try fileManager.setAttributes([FileAttributeKey.modificationDate: now], ofItemAtPath: path)
            return true
        } catch {
            return false
        }
    }
}

private func isNoSuchFileError(_ error: Error?) -> Bool {
    if let error = error {
        return NSCocoaErrorDomain == (error as NSError).domain && (error as NSError).code == NSFileReadNoSuchFileError
    }
    return false
}
