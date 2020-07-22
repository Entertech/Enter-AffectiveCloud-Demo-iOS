//
//  AuthRequest.swift
//  Networking
//
//  Created by Enter on 2020/6/28.
//  Copyright © 2020 Enter. All rights reserved.
//

import RxSwift
import HandyJSON
import Moya
import Alamofire


@objc public protocol AuthDelegate {
    func showAuth(strMessgage:String) -> ()
}

final public class AuthRequest {
    
    weak var delegate:AuthDelegate?
    public init() {
        //Session.default.setManager()
    }
    let disposeBag = DisposeBag()
    
    let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<AuthApi>.RequestResultClosure) in
        do {
            var request = try endpoint.urlRequest()
            request.timeoutInterval = 15
            done(.success(request))
        } catch {
            return
        }
    }
    lazy var provider = MoyaProvider<AuthApi>(requestClosure: requestTimeoutClosure)
    
    public lazy var client = {
        (clientId: String) -> Observable<ClientModel> in
        
        return self.provider.rx.request(.client(clientId: clientId)).filterSuccessfulStatusCodes()
            .asObservable().mapHandyJsonModel(ClientModel.self)
    }
    
    public lazy var refreshToken = {
        (clientId: String, refreshToken: String) -> Observable<RefreshTokenModel> in
        return self.provider.rx.request(.refreshToken(clientId: clientId, refreshToken: refreshToken)).filterSuccessfulStatusCodes()
            .asObservable().mapHandyJsonModel(RefreshTokenModel.self)
    }
    
    public lazy var social = {
        (clientId: String, socialId: String, socialType: String, socialToken: String, name: String) -> Observable<SocialModel> in
        return self.provider.rx.request(.social(clientId: clientId, socialId: socialId, socialType: socialType, socialToken: socialToken, name: name)).filterSuccessfulStatusCodes()
            .asObservable().mapHandyJsonModel(SocialModel.self)
    }
    
    
    private func clientFunc(clientId: String) {
        client(clientId).subscribe(onNext :{
                (model) in
                TokenManager.instance.accessToken = model.accessToken
                ArchiveToken.archive(fileName: "accessToken", object: TokenManager.instance)
            }, onError :{
                (error) in
                print(error.localizedDescription)
            },onCompleted :{
                print("client complete")
            }, onDisposed : nil)
            .disposed(by: disposeBag)
    }
    
    private func refreshTokenFunc(clientId: String, refreshToken: String) {
        let provider = MoyaProvider<AuthApi>()
        provider.rx.request(.refreshToken(clientId: clientId, refreshToken: refreshToken)).filterSuccessfulStatusCodes()
            .asObservable().mapHandyJsonModel(RefreshTokenModel.self).subscribe(onNext :{
                (model) in
                TokenManager.instance.accessToken = model.accessToken
                TokenManager.instance.refreshToken = model.refreshToken
                ArchiveToken.archive(fileName: "accessToken", object: TokenManager.instance)
            }, onError :{
                (error) in
                print(error.localizedDescription)
            }, onCompleted :{
                print("client complete")
            }, onDisposed : nil).disposed(by: disposeBag)
        
    }
    
    private func socialFunc(clientId: String, socialId: String, socialType: String, socialToken: String, name: String){
        let provider = MoyaProvider<AuthApi>()
        provider.rx.request(.social(clientId: clientId, socialId: socialId, socialType: socialType, socialToken: socialToken, name: name)).filterSuccessfulStatusCodes()
            .asObservable().mapHandyJsonModel(SocialModel.self).subscribe(onNext :{
                (model) in
                TokenManager.instance.accessToken = model.accessToken
                TokenManager.instance.refreshToken = model.refreshToken
                ArchiveToken.archive(fileName: "accessToken", object: TokenManager.instance)
            }, onError :{
                (error) in
                print(error.localizedDescription)
            }, onCompleted :{
                print("client complete")
            }, onDisposed : nil).disposed(by: disposeBag)
        
    }

}
