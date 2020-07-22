//
//  UserLessonRequest.swift
//  Networking
//
//  Created by Enter on 2019/4/2.
//  Copyright © 2019 Enter. All rights reserved.
//

import RxSwift
import HandyJSON
import Moya

final public class UserLessonRequest {
    
    //public static let instance = UserLessonRequest()
    //let provider = MoyaProvider<UserLessonApi>()
    let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<UserLessonApi>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 15
            done(.success(request))
        } catch {
            return
        }
    }
    lazy var provider = MoyaProvider<UserLessonApi>(requestClosure: requestTimeoutClosure)
    
    
    public lazy var userLessonList = provider.rx.request(.list).filterSuccessfulStatusCodes()
        .asObservable().mapHandyJsonModelList(UserLessonModel.self)
    
    /// 标记用户读过的课程
    public lazy var userLessonHaveRead = {
        (st:String, ft:String, user:Int, lesson:Int, course:Int, meditation:Int) -> Observable<UserLessonModel> in
        return self.provider.rx.request(.create(st, ft, user, lesson, course, meditation)).filterSuccessfulStatusCodes()
        .asObservable().mapHandyJsonModel(UserLessonModel.self)
    }
    
    public lazy var userLessonDelete = {
        (id: Int) -> Observable<Response> in
        self.provider.rx.request(.delete(id)).filterSuccessfulStatusCodes().asObservable()
    }
    
    public required init() {
    }
    
    
}
