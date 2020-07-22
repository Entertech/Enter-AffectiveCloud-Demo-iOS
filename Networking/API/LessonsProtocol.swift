//
//  Lessons.swift
//  Networking
//
//  Created by Enter on 2019/3/27.
//  Copyright © 2019 Enter. All rights reserved.
//

import Moya

/// 课
///
/// - read: 
enum LessonsApi {
    case read(Int)
}

extension LessonsApi : TargetType {
    var baseURL: URL {
        return URL.init(string: BaseAPI.host)!
    }
    
    var path: String {
        switch self {
        case .read(let id):
            return "/lessons/\(id)/"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        if let accessToken = TokenManager.instance.accessToken {
            return ["Accpet" : "application/json; version=v1", "Authorization":"Bearer "+accessToken]
        }
        return nil
    }
    
    
}


