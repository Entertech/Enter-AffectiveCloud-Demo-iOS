//
//  FTFileManager.swift
//  Flowtime
//
//  Created by Anonymous on 2019/5/8.
//  Copyright © 2019 Enter. All rights reserved.
//

import Foundation

fileprivate let FTDATABASE_REALM_NAME = "flowtime.realm"
fileprivate let FTDB_DIR_NAME = "Database"
fileprivate let FTUSER_DIR_NAME = "Users"
fileprivate let FTAUDIO_DIR_NAME = "Audio"
fileprivate let FTFIRMWARE_DIR_NAME = "firmware"

class FTFileManager {
    private init() {}
    static let shared = FTFileManager()

    // cache handle
    func deleteAllCache() {
        try! FileManager.default.removeItem(at: audioDirectory())
    }

    // size of audio file
    func sizeOfAudioFile() -> Double? {
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: audioDirectory().path)
            let size = attribute[FileAttributeKey.size] as? Double
            return size
        } catch {
            return nil
        }
    }

    //MARK: loop through Audio directory
    /* 当缓存 > 500M 时，自动删除最老的音频文件
     * 1. check file size
     * 2. find oldest file
     * 3. delete file
     */
    func autoDeleteFile() {
        while sizeOfAudioFile()! > 500 {
            let filePath = filesListWithTime().last!
            if FileManager.default.fileExists(atPath: filePath) {
                try! FileManager.default.removeItem(atPath: filePath)
            }
        }
    }

    /// sort audio files with time. (the first file is the latest creation)
    ///
    /// - Returns: audio file path list
    private func filesListWithTime() -> [String] {
        let files = try! FileManager.default.subpathsOfDirectory(atPath: audioDirectory().path)

        return [String]()
    }

    //    private func fileSize(_ path: String) -> Double {
    //        do {
    //            let attribute = try FileManager.default.attributesOfItem(atPath: path)
    //            let size = attribute[FileAttributeKey.size]! as? Int
    //
    //            return Double(size!)
    //        } catch {
    //            DLog(error)
    //        }
    //    }

    func lessonDirectory(courseID: Int, lessonID: Int, lessonName: String)-> URL {
        let lessonFileURL = courseDirectory(courseID).appendingPathComponent("\(lessonID)_\(lessonName)")
        return lessonFileURL
    }

    func courseDirectory(_ courseID: Int) -> URL {
        let path = audioDirectory().appendingPathComponent("\(courseID)")
        makeDirIfNeed(dir: path.path)
        return URL(fileURLWithPath: path.path, isDirectory: true)
    }

    func userDirectory(_ userID: Int) -> URL {
        let path = userFileDirectroy().appendingPathComponent("\(userID)")
        makeDirIfNeed(dir: path.path)
        return URL(fileURLWithPath: path.path, isDirectory: true)
    }

    func userReportURL(_ reportPath: String) -> URL {
        let url = self.userFileDirectroy().appendingPathComponent(reportPath)
        var tempURL = url
        tempURL.deleteLastPathComponent()
        makeDirIfNeed(dir: tempURL.path)
        return url
    }
    
    func firmwareTempDirectory(_ version: String) -> URL {
        let url = self.firmwareDirectory().appendingPathComponent(version)
        var tempURL = url
        tempURL.deleteLastPathComponent()
        makeDirIfNeed(dir: tempURL.path)
        return url
    }

    func realmURL() -> URL {
        // 允许数据目录下的文件无读写限制
        try! FileManager.default.setAttributes([FileAttributeKey.protectionKey: FileProtectionType.none],
                                               ofItemAtPath: databaseDirectory().path)
        let realmURL = databaseDirectory().appendingPathComponent("\(FTDATABASE_REALM_NAME)")
        return realmURL
    }
    
    private func databaseDirectory() -> URL {
        let path = self.documentDirectory + "/\(FTDB_DIR_NAME)"
        makeDirIfNeed(dir: path)
        return URL(fileURLWithPath: path, isDirectory: true)
    }

    private func userFileDirectroy() -> URL {
        let path = self.documentDirectory + "/\(FTUSER_DIR_NAME)"
        makeDirIfNeed(dir: path)
        return URL(fileURLWithPath: path, isDirectory: true)
    }

    private func audioDirectory() -> URL {
        let path = self.documentDirectory + "/\(FTAUDIO_DIR_NAME)"
        makeDirIfNeed(dir: path)
        return URL(fileURLWithPath: path, isDirectory: true)
    }
    
    private func firmwareDirectory() -> URL {
        let path = self.cacheDirectory + "/\(FTFIRMWARE_DIR_NAME)"
        makeDirIfNeed(dir: path)
        return URL(fileURLWithPath: path, isDirectory: true)
    }

    private func makeDirIfNeed(dir: String) {
        if !FileManager.default.fileExists(atPath: dir) {
            try! FileManager.default.createDirectory(atPath: dir,
                                                     withIntermediateDirectories: true,
                                                     attributes: nil)
        }
    }
    //MARK: directory
    func homeDirectory() -> String {
        let path = NSHomeDirectory()
        return path
    }

    var documentDirectory: String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return path
    }

    var cacheDirectory: String {
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        return path
    }

    var tempDirectory: String {
        let path = NSTemporaryDirectory()
        return path
    }
}


struct FTURLManager {
    static let helpCenter = "https://docs.myflowtime.cn/"
}
