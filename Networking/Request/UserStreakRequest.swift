//
//  UserStreakRequest.swift
//  Networking
//
//  Created by Enter on 2019/6/18.
//  Copyright © 2019 Enter. All rights reserved.
//

import RxSwift
import HandyJSON
import Moya

final public class UserStreakRequest {
    let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<StreakApi>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 6
            done(.success(request))
        } catch {
            return
        }
    }
    lazy var provider = MoyaProvider<StreakApi>(requestClosure: requestTimeoutClosure)
    
    /// 用户统计
    public lazy var userStreak = provider.rx.request(.read).filterSuccessfulStatusCodes()
        .asObservable().mapHandyJsonModelList(StreakModel.self)
    
    public required init() {
        
    }
}

