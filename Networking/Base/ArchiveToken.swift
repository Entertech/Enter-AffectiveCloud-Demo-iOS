//
//  ArchiveToken.swift
//  Networking
//
//  Created by Enter on 2020/6/28.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit

public class ArchiveToken: NSObject {
    static func getFilePath(filePath: String) -> String? {
        var paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        if paths.count > 0 {
            return "\(paths[0])/"+filePath
        }
        
        return nil
    }
    
    //MARK: 归档的方法
    public static func archive(fileName: String, object: NSObject) -> Bool {
        let name = getFilePath(filePath: fileName)!
        return NSKeyedArchiver.archiveRootObject(object, toFile: name )
    }
    
    //MARK: 解档的方法
    public static func unarchive(fileName: String) -> NSObject? {
        return NSKeyedUnarchiver.unarchiveObject(withFile:getFilePath(filePath: fileName)!) as? NSObject
    }
}

