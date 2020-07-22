//
//  FirmwareUpdateProtocol.swift
//  Networking
//
//  Created by Enter on 2019/9/5.
//  Copyright © 2019 Enter. All rights reserved.
//


import Moya

enum FirmwareUpdateApi {
    case version
}

extension FirmwareUpdateApi : TargetType {
    var baseURL: URL {
        return URL.init(string: BaseAPI.host)!
    }
    
    var path: String {
        switch self {
        case .version:
            return "/api/v0.1/firmware_version"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .version:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .version:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
