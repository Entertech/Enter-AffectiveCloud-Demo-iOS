//
//  User.swift
//  Networking
//
//  Created by Enter on 2019/3/27.
//  Copyright © 2019 Enter. All rights reserved.
//

import Moya

enum UserApi {
    case read
    case update(String, String)
    case partialUpdate(String, String)
}

extension UserApi : TargetType {
    var baseURL: URL {
        return URL.init(string: BaseAPI.host)!
    }
    
    var path: String {
        switch self {
        case .read:
            return "/user/"
        case .update:
            return "/user/"
        case .partialUpdate:
            return "/user/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .read:
            return .get
        case .update:
            return .put
        case .partialUpdate:
            return .patch
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .read:
            return .requestPlain
        case let .update(name, email):
            return .requestParameters(parameters: ["name":name, "email":email], encoding: URLEncoding.default)
        case let .partialUpdate(name, email):
            return .requestParameters(parameters: ["name":name, "email":email], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        if let accessToken = TokenManager.instance.accessToken {
            return ["Accpet" : "application/json; version=v1", "Authorization" : "Bearer "+accessToken]
        }
        return nil
    }
    
    
}
