//
//  LogProtocol.swift
//  Networking
//
//  Created by Enter on 2019/12/19.
//  Copyright © 2019 Enter. All rights reserved.
//

import Moya

enum LogProtocol {
    case sendLog(String, String, String, String)
}

extension LogProtocol: TargetType {

    
    var baseURL: URL {
        return URL(string: "https://log.entertech.cn")!
    }
    
    var path: String {
        return "/log/"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case let .sendLog(version, userId, event, message):
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateStr = formatter.string(from: Date())
            return .requestParameters(parameters: ["app": "heartflow", "platform": "ios", "version": version, "user_id": userId, "date": dateStr, "event": event, "message": message], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        if let token = TokenManager.instance.logToken {
            return ["Authorization":"JWT "+token]
        }
        return nil
    }
    
    
}
