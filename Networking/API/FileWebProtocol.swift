//
//  FileWebProtocol.swift
//  Networking
//
//  Created by Enter on 2020/5/19.
//  Copyright © 2020 Enter. All rights reserved.
//

import Moya

enum FileWebService {
    case download(url: String, fileName: String?)
    
    var localLocation: URL {
        switch self {
        case .download(let url, let fileName):
            let directory: URL = FileSystem.downloadDirectory
            let filePath: URL = directory.appendingPathComponent(fileName!)
            return filePath
        }
    }
    
    var downloadDestination: DownloadDestination {
        // `createIntermediateDirectories` will create directories in file path
        return { _, _ in return (self.localLocation, [.removePreviousFile, .createIntermediateDirectories]) }
    }
}

extension FileWebService: TargetType {
    var baseURL: URL {
        switch self {
        case .download(let url, _):
            return URL(string: url)!
        }
    }
    var path: String {
        switch self {
        case .download(_, _):
            return ""
        }
    }
    var method: Moya.Method {
        switch self {
        case .download(_, _):
            return .get
        }
    }
    var parameters: [String: Any]? {
        switch self {
        case .download:
            return nil
        }
    }
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    var task: Task {
        switch self {
        case .download(_, _):
            return .downloadDestination(downloadDestination)
        }
    }
    var sampleData: Data {
        return Data()
    }
    var headers: [String: String]? {
        return nil
    }
}


public class FileSystem {
    static let documentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()
    
    static let cacheDirectory: URL = {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()

    static let downloadDirectory: URL = {
        let directory: URL = FileSystem.cacheDirectory.appendingPathComponent("firmware/")
        return directory
    }()
    
}
