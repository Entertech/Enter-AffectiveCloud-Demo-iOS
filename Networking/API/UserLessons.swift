//
//  UserLessons.swift
//  Networking
//
//  Created by Enter on 2019/4/2.
//  Copyright © 2019 Enter. All rights reserved.
//

import Moya

enum UserLessonApi {
    case list
    case create(String, String, Int, Int, Int, Int)
    case read(Int)              //放弃
    case delete(Int)            //放弃
}

extension UserLessonApi: TargetType {
    var baseURL: URL {
        return URL.init(string: BaseAPI.host)!
    }
    
    var path: String {
        switch self {
        case .list:
            return "/api/v0.1/userLesson/"
        case .create:
            return "/api/v0.1/userLesson/"
        case .read(let id):
            return "/api/v0.1/userLesson/\(id)/"
        case .delete(let id):
            return "/api/v0.1/userLesson/\(id)/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .list:
            return .get
        case .create:
            return .post
        case .read:
            return .get
        case .delete:
            return .delete
        }
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case let .create(startTime, finishTime, user, lesson, course, meditation):
            var dic: [String : Any] = ["start_time":startTime,
                                       "finish_time":finishTime,
                                       "user":user,
                                       "lesson":lesson,
                                       "course": course,
                                       "meditation": meditation]
            if meditation == 0 { dic["meditation"] = nil }
            return .requestParameters(parameters: dic,encoding: URLEncoding.default)
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
