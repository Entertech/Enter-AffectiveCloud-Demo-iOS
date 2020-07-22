//
//  Meditations.swift
//  Networking
//
//  Created by Enter on 2019/3/28.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import Moya

enum UserMeditationsApi {
    case read(Int)
    case add([String: Any])
    case update([String: Any], Int)
    case delete(Int)
}


extension UserMeditationsApi: TargetType {
    var baseURL: URL {
        return URL.init(string: BaseAPI.host)!
    }
    
    var path: String {
        switch self {
        case .read(let id):
            return "/api/v0.1/meditation/\(id)/"
        case .add:
            return "/api/v0.1/meditation/"
        case .update(_, let id):
            return "/api/v0.1/meditation/\(id)/"
        case .delete(let id):
            return "/api/v0.1/meditation/\(id)/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .add:
            return .post
        case .read:
            return .get
        case .update(_, _):
            return .put
        case .delete(_):
            return .delete
        }
        
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case let .add(dic):
            return .requestParameters(parameters: dic, encoding: URLEncoding.default)
        case .read:
            return .requestPlain
        case let .update(dic, _):
            return .requestParameters(parameters: dic, encoding: URLEncoding.default)
        case .delete(_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        if let accessToken = TokenManager.instance.accessToken {
            return ["Authorization" : "Bearer "+accessToken]
        }
        return nil
    }
    
    
}
