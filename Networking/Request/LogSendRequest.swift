//
//  LogSendRequest.swift
//  Networking
//
//  Created by Enter on 2019/12/19.
//  Copyright © 2019 Enter. All rights reserved.
//


import HandyJSON
import Moya
import RxSwift

final public class LogUploadRequest {
    let dispose = DisposeBag()
    
    let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<LogProtocol>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 5
            done(.success(request))
        } catch {
            return
        }
    }
    lazy var provider = MoyaProvider<LogProtocol>(requestClosure: requestTimeoutClosure)
    
    public func uploadEvent(version:String, userId:String, event:String, message:String) {

        provider.rx.request(.sendLog(version, userId, event, message)).filterSuccessfulStatusCodes().asObservable().mapHandyJsonModel(LogModel.self).subscribe(onNext: { (model) in
        }, onError: { (error) in
            let err = error as! MoyaError
            if let response = err.response {
               if let str = String(data: response.data, encoding: .utf8) {
                   print(str)
               }
            }
            
            }, onCompleted: {
        }, onDisposed: {
        })
    }
    
    public required init() {
        
    }
    
}
