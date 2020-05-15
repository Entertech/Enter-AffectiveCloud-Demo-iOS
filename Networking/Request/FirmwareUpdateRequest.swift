//
//  FirmwareUpdateRequest.swift
//  Networking
//
//  Created by Enter on 2019/9/5.
//  Copyright © 2019 Enter. All rights reserved.
//


import HandyJSON
import Moya
import RxSwift

final public class FirmwareUpdateRequest {
    let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<FirmwareUpdateApi>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 15
            done(.success(request))
        } catch {
            return
        }
    }
    lazy var provider = MoyaProvider<FirmwareUpdateApi>(requestClosure: requestTimeoutClosure)
    
    /// 硬件版本
    public lazy var firmwareVersion = provider.rx.request(.version).filterSuccessfulStatusCodes()
        .asObservable().mapHandyJsonModelList(FirmwareUpdateModel.self)
    
    public required init() {}
}
