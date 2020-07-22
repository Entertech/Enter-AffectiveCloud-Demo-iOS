//
//  Collections.swift
//  Networking
//
//  Created by Enter on 2019/3/27.
//  Copyright © 2019 Enter. All rights reserved.
//

import Moya

/// 专题
///
/// - list:
/// - read: 
enum CollectionsApi {
    case list(Int, Int)
    case read(Int)
    case searchCourse(Int)
    case topCourse(Int, Int)
    
}

extension CollectionsApi : TargetType {
    var baseURL: URL {
        return URL.init(string: BaseAPI.host)!
    }
    
    var path: String {
        switch self {
        case .list:
            return "/collections/"
        case .read(let id):
            return "/collections/\(id)/"
        case .searchCourse(let id):
            return "/collections/\(id)/courses/"
        case .topCourse:
            return "/top-courses/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .list:
            return .get
        case .read:
            return .get
        case .searchCourse:
            return .get
        case .topCourse:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case let .list(limit, offset):
            return .requestParameters(parameters: ["limit":limit, "offset":offset], encoding: URLEncoding.default)
        case let .topCourse(limit, offset):
            return .requestParameters(parameters: ["limit":limit, "offset":offset], encoding: URLEncoding.default)
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
