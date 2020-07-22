//
//  AuthProtocol.swift
//  Networking
//
//  Created by Enter on 2020/6/28.
//  Copyright © 2020 Enter. All rights reserved.
//

import Moya

//授权
enum AuthApi {
    case client(clientId: String)
    case refreshToken(clientId: String, refreshToken: String)
    case social(clientId: String, socialId: String, socialType: String, socialToken: String, name: String)
}

extension AuthApi:TargetType{
    var baseURL: URL {
        return URL.init(string: BaseAPI.host)!
        
    }
    
    var path: String {
        switch self {
        case .client:
            return "/auth/client/"
        case .refreshToken:
            return "/auth/refresh-token/"
        case .social:
            return "/auth/social/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .client:
            return .post
        case .refreshToken:
            return .post
        case .social:
            return .post
        
        }
    }
    
    var sampleData: Data {
        //return "".data(using: String.Encoding.utf8)!
        switch self {
        case .client:
            return "{}".data(using: String.Encoding.utf8)!
        case .refreshToken:
            return "{}".data(using: String.Encoding.utf8)!
        case .social:
            return "{}".data(using: String.Encoding.utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case let .client(clientId):
            return .requestParameters(parameters: ["client_id":clientId], encoding: URLEncoding.default)
        case let .refreshToken(clientId, refreshToken):
            return .requestParameters(parameters: ["client_id":clientId, "refresh_token":refreshToken], encoding: URLEncoding.default)
        case let .social(clientId, socialId, socialType, socialToken, name):
            return .requestParameters(parameters: ["client_id":clientId, "social_id":socialId, "social_type":socialType, "social_token":socialToken, "social_name":name ], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Accpet" : "application/json; version=v1"]
    }
}
