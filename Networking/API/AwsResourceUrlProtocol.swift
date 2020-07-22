//
//  AwsSourceUrlProtocol.swift
//  Networking
//
//  Created by Enter on 2019/6/18.
//  Copyright © 2019 Enter. All rights reserved.
//

import Moya

enum AwsResourceUrlApi {
    case get(String)
    case post(String)
}

extension AwsResourceUrlApi: TargetType {
    var baseURL: URL {
        return URL.init(string: BaseAPI.host)!
    }
    
    var path: String {
        switch self {
            //https://api-test.myflowtime.cn/api/v0.1/aliyun_presigned_url
        case .get(let path):
            return "/api/v0.1/aliyun_presigned_url"
        case .post(let path):
            return "/api/v0.1/aliyun_presigned_url"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .get(_):
            return .get
        case .post(_):
            return .get
        }
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case let .get(path):
            return .requestParameters(parameters: ["method": "get", "objpath": path], encoding: URLEncoding.default)
        case let .post(path):
            return .requestParameters(parameters: ["method": "put", "objpath": path], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
