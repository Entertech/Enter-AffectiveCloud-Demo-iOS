//
//  AuthorRequest.swift
//  Networking
//
//  Created by Enter on 2019/3/29.
//  Copyright © 2019 Enter. All rights reserved.
//

import RxSwift
import HandyJSON
import Moya

final public class AuthorRequest {
    //public static let instance = AuthorRequest()
    let disposeBag = DisposeBag()
    //var provider = MoyaProvider<AuthorsApi>()
    let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<AuthorsApi>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 15
            done(.success(request))
        } catch {
            return
        }
    }
    lazy var provider = MoyaProvider<AuthorsApi>(requestClosure: requestTimeoutClosure)
    

    /// 作者列表
    public lazy var authorList = provider.rx.request(.list).filterSuccessfulStatusCodes()
        .asObservable().mapHandyJsonModelList(AuthorModel.self)
    
    
    /// 通过id检索作者
    public lazy var authorById = {
        (id:Int) -> Observable<AuthorModel> in
        return self.provider.rx.request(.read(id)).filterSuccessfulStatusCodes()
            .asObservable().mapHandyJsonModel(AuthorModel.self)
    }
    
   
    public func authorsFunc() {
        
        authorList.subscribe(onNext: { (data) in
            print(data)
        }, onError: {
            (err) in
            let moyaError = err as! MoyaError
            if let response = moyaError.response{
                print(response.statusCode)
            }
        }, onCompleted: {
            print("end")
        }, onDisposed: nil).disposed(by: disposeBag)
        
    }
    
    private func authorFunc(id: Int) {
        
        authorById(id).subscribe(onNext :{
                (model) in
                print(model)
            }, onError :{
                (error) in
                let err = error as! Moya.MoyaError
                if let response = err.response{
                    print(response.statusCode)
                }
            }, onCompleted :{
                print("client complete")
            }, onDisposed : nil).disposed(by: disposeBag)
        
    }
    
    required init() {
        
    }
}
