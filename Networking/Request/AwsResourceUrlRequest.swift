//
//  AwsResourceUrlRequest.swift
//  Networking
//
//  Created by Enter on 2019/6/18.
//  Copyright © 2019 Enter. All rights reserved.
//

import RxSwift
import HandyJSON
import Moya

final public class AwsResourceUrlRequest {
    let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<AwsResourceUrlApi>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 15
            done(.success(request))
        } catch {
            return
        }
    }
    lazy var provider = MoyaProvider<AwsResourceUrlApi>(requestClosure: requestTimeoutClosure)
    /// aws资源
    public lazy var getResouceUrl = {
        (path: String) -> Observable<AwsResourceUrlModel> in
        return self.provider.rx.request(.get(path)).filterSuccessfulStatusCodes()
            .asObservable().mapHandyJsonModel(AwsResourceUrlModel.self)
    }
    
    public lazy var postResouceUrl = {
        (path: String) -> Observable<AwsResourceUrlModel> in
        return self.provider.rx.request(.post(path)).filterSuccessfulStatusCodes()
            .asObservable().mapHandyJsonModel(AwsResourceUrlModel.self)
    }
    
    public required init() {
        
    }
}
