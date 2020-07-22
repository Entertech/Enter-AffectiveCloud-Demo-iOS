//
//  UserMeditationRequest.swift
//  Networking
//
//  Created by Enter on 2019/6/5.
//  Copyright © 2019 Enter. All rights reserved.
//

import RxSwift
import HandyJSON
import Moya

final public class UserMeditationRequest {
    let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<UserMeditationsApi>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 5
            done(.success(request))
        } catch {
            return
        }
    }
    lazy var provider = MoyaProvider<UserMeditationsApi>(requestClosure: requestTimeoutClosure)
    
    public lazy var userMeditation = {
        (id: Int) -> Observable<UserMeditationModel> in
        return self.provider.rx.request(.read(id)).filterSuccessfulStatusCodes()
            .asObservable().mapHandyJsonModel(UserMeditationModel.self)
    }
    
    public lazy var userMeditationAdd = {
        (dic: [String: Any]) -> Observable<UserMeditationModel> in
        return self.provider.rx.request(.add(dic)).filterSuccessfulStatusCodes()
            .asObservable().mapHandyJsonModel(UserMeditationModel.self)
    }
    
    public lazy var userMeditationPut = {
        (dic: [String: Any], id: Int) -> Observable<UserMeditationModel> in
        return self.provider.rx.request(.update(dic, id)).filterSuccessfulStatusCodes()
            .asObservable().mapHandyJsonModel(UserMeditationModel.self)
    }
    
    public lazy var userMeditationDelete = {
        (id: Int) -> Observable<Response> in
        self.provider.rx.request(.delete(id)).filterSuccessfulStatusCodes().asObservable()
    }

    public required init() {
        
    }
}
