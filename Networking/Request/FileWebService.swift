//
//  FileWebService.swift
//  Networking
//
//  Created by Enter on 2020/5/19.
//  Copyright © 2020 Enter. All rights reserved.
//

import Moya
import HandyJSON
import RxSwift

final public class FileDownloadRequest {
    let disposeBag = DisposeBag()
    let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<FileWebService>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 15
            done(.success(request))
        } catch {
            return
        }
    }
    lazy var provider = MoyaProvider<FileWebService>(requestClosure: requestTimeoutClosure)
    public func downloadFirmware(url: String, fileName: String) -> Observable<Response> {
        return provider.rx.request(.download(url: url, fileName: fileName)).filterSuccessfulStatusCodes().asObservable()
    }
    
    
    public required init() {
        
    }
}


class WebService {
    
    // set false when release
    static var verbose: Bool = true
    
    // response result type
    enum Result {
        case success(String)
        case failure(String)
    }
}
