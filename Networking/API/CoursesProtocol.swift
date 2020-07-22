//
//  Courses.swift
//  Networking
//
//  Created by Enter on 2019/3/27.
//  Copyright © 2019 Enter. All rights reserved.
//

import Moya

/// 课程
///
/// - list:
/// - read: 
enum CoursesApi {
    case list(Int, Int)
    case read(Int)
    case searchLesson(Int)
}

extension CoursesApi : TargetType {
    var baseURL: URL {
        return URL.init(string: BaseAPI.host)!
    }
    
    var path: String {
        switch self {
        case .list:
            return "/courses/"
        case .read(let id):
            return "/courses/\(id)/"
        case .searchLesson(let id):
            return "/courses/\(id)/lessons/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .list:
            return .get
        case .read:
            return .get
        case .searchLesson:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case let .list(limit, offset):
            return .requestParameters(parameters: ["limit": limit, "offset": offset], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        if let accessToken = TokenManager.instance.accessToken {
            return ["Accpet" : "application/json; version=v1", "Authorization":"Bearer "+accessToken]
        }
        return nil
        
    }
    
    
}
