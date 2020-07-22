//
//  Authors.swift
//  Networking
//
//  Created by Enter on 2019/3/27.
//  Copyright © 2019 Enter. All rights reserved.
//

import Moya

//作者
enum AuthorsApi {
    case list
    case read(Int)
}

extension AuthorsApi : TargetType {
    var baseURL: URL {
        return URL.init(string: BaseAPI.host)!
    }
    
    var path: String {
        switch self {
        case .list:
            return "/authors/"
        case .read(let id):
            return "/authors/\(id)/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .list:
            return .get
        case .read:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
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
