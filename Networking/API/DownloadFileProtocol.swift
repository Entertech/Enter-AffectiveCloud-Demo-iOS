//
//  DownloadFileProtocol.swift
//  Networking
//
//  Created by Enter on 2019/5/9.
//  Copyright © 2019 Enter. All rights reserved.
//

import Moya

enum DownloadByMoyaApi {
    case download(String)
}

extension DownloadByMoyaApi: TargetType {
    var baseURL: URL {
        switch self {
        case .download(let url):
            return URL.init(string: url)!
        }
    }
    
    var path: String {
        switch self {
        case .download:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .download:
            return .get
        }
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .download:
            return .downloadDestination(DefaultDownloadDestination)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}


private let DefaultDownloadDestination: DownloadDestination = {
    temporaryURL, response in
    
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = documentsURL.appendingPathComponent(response.suggestedFilename!)
    return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
    
}
