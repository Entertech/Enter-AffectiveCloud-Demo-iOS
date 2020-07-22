//
//  UserRequest.swift
//  Networking
//
//  Created by Enter on 2019/4/2.
//  Copyright © 2019 Enter. All rights reserved.
//

import RxSwift
import HandyJSON
import Moya

final public class UserRequest {
    
    //public static let instance = UserRequest()
    let disposeBag = DisposeBag()
    //let provider = MoyaProvider<UserApi>()
    let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<UserApi>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 15
            done(.success(request))
        } catch {
            return
        }
    }
    lazy var provider = MoyaProvider<UserApi>(requestClosure: requestTimeoutClosure)
    
    /// 获取用户信息
    public lazy var userInfo = provider.rx.request(.read).filterSuccessfulStatusCodes()
        .asObservable().mapHandyJsonModel(UserModel.self)
    
    
    
    /// 用户信息更新
    public lazy var updateUserInfo = {
        (name: String, email: String) -> Observable<UserModel> in
        
        return self.provider.rx.request(.update(name, email)).filterSuccessfulStatusCodes()
            .asObservable().mapHandyJsonModel(UserModel.self)
    }
    
    
    /// 更新部分用户信息
    public lazy var partialUpdateUserInfo = {
        (name: String, email: String) -> Observable<UserModel> in
        let provider = MoyaProvider<UserApi>()
        return provider.rx.request(.update(name, email)).filterSuccessfulStatusCodes()
            .asObservable().mapHandyJsonModel(UserModel.self)
    }
    
    
    private func UserLessonList() {
        userInfo.subscribe(onNext :{
            (model) in
            print(model.toJSONString()!)
        }, onError :{
            (error) in
            print(error.localizedDescription)
        }, onCompleted :{
            print("client complete")
        }, onDisposed : nil).disposed(by: disposeBag)
        
    }
    
    public required init() {
    }
    
    
}
