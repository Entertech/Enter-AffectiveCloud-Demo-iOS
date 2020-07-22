//
//  UserCourses.swift
//  Networking
//
//  Created by Enter on 2019/4/11.
//  Copyright © 2019 Enter. All rights reserved.
//

import Moya

enum UserCourseApi {
    case list(Int, Int)
    case read(Int)
}

extension UserCourseApi: TargetType{
    var baseURL: URL {
        return URL.init(string: BaseAPI.host)!
    }
    
    var path: String {
        switch self {
        case .list:
            return "/user/courses/"
        case .read(let id):
            return "/user/courses/\(id)/"

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
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case let .list(limit, offset):
            return .requestParameters(parameters: ["limit":limit, "offset":offset], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        if let accessToken = TokenManager.instance.accessToken {
            return ["Accpet" : "application/json; version=v1", "Authorization" : "Bearer "+accessToken]
        }
        return nil
    }
    
    
}
