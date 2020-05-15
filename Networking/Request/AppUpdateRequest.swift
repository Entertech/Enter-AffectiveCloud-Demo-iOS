//
//  AppUpdateRequest.swift
//  Networking
//
//  Created by Enter on 2019/9/5.
//  Copyright © 2019 Enter. All rights reserved.
//


import HandyJSON
import Moya
import RxSwift

final public class AppUpdateRequest {
    let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<AppUpdateApi>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 10
            done(.success(request))
        } catch {
            return
        }
    }
    lazy var provider = MoyaProvider<AppUpdateApi>(requestClosure: requestTimeoutClosure)
    
    /// app版本
    public lazy var appVersion = provider.rx.request(.version).filterSuccessfulStatusCodes()
        .asObservable().mapHandyJsonModelList(AppUpdateModel.self)
    
    public required init() {
        
    }
}
