//
//  LogTokenProtocol.swift
//  Networking
//
//  Created by Enter on 2019/12/19.
//  Copyright © 2019 Enter. All rights reserved.
//

import Moya

enum LogTokenProtocol {
    case requestToken(String, String)
}

extension LogTokenProtocol: TargetType {
    var baseURL: URL {
        return URL(string: "https://log.entertech.cn")!
    }
    
    var path: String {
        return "/auth/token/"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case let .requestToken(username, password):
            return .requestParameters(parameters: ["username":username, "password":password], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    

}
