//
//  StreakProtocol.swift
//  Networking
//
//  Created by Enter on 2019/6/18.
//  Copyright © 2019 Enter. All rights reserved.
//

import Moya

enum StreakApi {
    case read
}

extension StreakApi: TargetType {
    var baseURL: URL {
        return URL.init(string: BaseAPI.host)!
    }
    
    var path: String {
        switch self {
        case .read:
            return "/api/v0.1/statistics/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .read:
            return .get
        }
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {

        return .requestPlain
        
    }
    
    var headers: [String : String]? {
        if let accessToken = TokenManager.instance.accessToken {
            return ["Accpet" : "application/json; version=v1", "Authorization" : "Bearer "+accessToken]
        }
        return nil
    }
    
    
}
