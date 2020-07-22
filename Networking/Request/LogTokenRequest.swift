//
//  LogTokenRequest.swift
//  Networking
//
//  Created by Enter on 2019/12/19.
//  Copyright © 2019 Enter. All rights reserved.
//

import HandyJSON
import Moya
import RxSwift

final public class LogTokenRequest {
    let disposeBag = DisposeBag()
    let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<LogTokenProtocol>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 5
            done(.success(request))
        } catch {
            return
        }
    }
    lazy var provider = MoyaProvider<LogTokenProtocol>(requestClosure: requestTimeoutClosure)
    
    public func getLogToken(username: String, password: String) {
        provider.rx.request(.requestToken(username, password)).filterSuccessfulStatusCodes().asObservable().mapHandyJsonModel(LogTokenModel.self).subscribe(onNext: { (model) in
                if let code = model.code, code == 0 {
                    TokenManager.instance.logToken = model.token
                }
        }, onError: { (error) in
            let err = error as! MoyaError
            if let response = err.response {
               if let str = String(data: response.data, encoding: .utf8) {
                   print(str)
               }
            }
        }, onCompleted: {
            print("token completed")
            }, onDisposed: nil).disposed(by: disposeBag)
    }
    
    public required init() {
        
    }
}
