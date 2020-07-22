//
//  LoginService.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/7/9.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import SDWebImage
import HandyJSON
import Alamofire
import Networking
import RxSwift
import Moya
import AuthenticationServices

class LoginService: NSObject, WXApiDelegate {
    
    static let shared = LoginService()
    private override init() {}
    
    func openURLHandle(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool  {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func openSourceApp(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func handleSceneOpenUniversalLink(userActivity: NSUserActivity) {
        WXApi.handleOpenUniversalLink(userActivity, delegate: self)
    }
    
    func handleOpenUniversalLink(userActivity: NSUserActivity) -> Bool {
        return WXApi.handleOpenUniversalLink(userActivity, delegate: self)
    }
    
    func openSenceApp(open url: URL) {
        WXApi.handleOpen(url, delegate: self)
    }
    
    // 保存用户信息
    public func saveProfile(_ socialType: String, name: String, userID: String, iconURL: URL?) {
        User.default.socialType = socialType
        User.default.name = name
        User.default.userId = userID
        if let url = iconURL {
            DispatchQueue.global().async {
                SDWebImageDownloader.shared.downloadImage(with: url, completed: { (receiveImage, data, error, finish) in
                    if finish {
                        if let image = receiveImage {
                            let imageName = "\(name)_\(userID)"
                            let _ = image.saveImage(imageName: imageName)
                        }
                    }
                })
            }
        }
    }
    
    func onReq(_ req: BaseReq) {
        print("auth: wechat req:\(req)")
    }
    
    func onResp(_ resp: BaseResp) {
        if let resp = resp as? SendAuthResp, let code = resp.code {
            let urlString = AuthAPIKey.refreshTokenKey +  "appid=\(Preference.wxAppID)&secret=\(Preference.wxSecret)&code=\(code)&grant_type=authorization_code"
            AuthWechatHandle.shared.reqeustToken(urlstring: urlString) { (model) in
                if let access_token = model.accessToken,
                    let openid = model.openid {
                    let profileURLStr = AuthAPIKey.profileKey + "access_token=\(access_token)&openid=\(openid)"
                    AuthWechatHandle.shared.requestProfile(urlstring: profileURLStr) { (profile) in
                        if let iconImgStr = profile.headimgurl,
                            let url = URL(string: iconImgStr),
                            let name = profile.nickname {
                            self.saveProfile("wechat",
                                             name: name,
                                             userID: openid,
                                             iconURL: url)
                            NotificationName.kAuthorizationTokenResponse.emit([NotificationKey.kResponseAuthTokenKey.rawValue: access_token,
                                                                               NotificationKey.kResponseAuthUserIDKey.rawValue: openid,
                                                                               NotificationKey.kResponseAuthUserNameKey.rawValue: name,
                                                                               NotificationKey.KResponseAuthSocialType.rawValue: SocialType.wechat])
                            return
                        }

                        if let _ = profile.errcode {
                            // wechat auth failed
                            NotificationName.kAuthorizationTokenResponse.emit()
                            return
                        }
                    }
                } else {
                    // wechat auth failed
                    NotificationName.kAuthorizationTokenResponse.emit()
                }
            }
        } else {
            // wechat auth failed
            NotificationName.kAuthorizationTokenResponse.emit()
        }
    }
}

extension LoginService  {
    @available(iOS 13.0, *)
    public func appleAuthSuccess(authorization: ASAuthorization) {
        let credential = authorization.credential as! ASAuthorizationAppleIDCredential

        let model = User.default

        model.userId = credential.user
        
        if let fullName = credential.fullName {
            if let _ = fullName.givenName, let _ = fullName.familyName {
                model.name = fullName.givenName! + " " + fullName.familyName!
                User.default.appleName = model.name
            } else {
                model.name = User.default.appleName
            }
        }
        //let appleName = model.name == "" ? model.userId.hashed(.md5)! : model.name
        if let token = credential.identityToken, let code = credential.authorizationCode {
            //let tokenString = token.base64EncodedString()
            let codeString = code.base64EncodedString()
            self.saveProfile(SocialType.apple,
                             name: model.name,
                             userID: model.userId,
                             iconURL: nil)
            NotificationName.kAuthorizationTokenResponse.emit([NotificationKey.kResponseAuthTokenKey.rawValue: codeString,
            NotificationKey.kResponseAuthUserIDKey.rawValue: model.userId,
            NotificationKey.kResponseAuthUserNameKey.rawValue: model.name,
            NotificationKey.KResponseAuthSocialType.rawValue: SocialType.apple])
        }
        
        
    }
}


class User {
    static let `default` = User()

    var socialType: String {
        get {
            if let value = UserDefaults.standard.string(forKey: "social_type_key") {
                return value
            }
            return ""
        }
        set {
            let id = newValue
            UserDefaults.standard.set(id, forKey: "social_type_key")
        }
    }

    var userId: String {
        get {
            if let value = UserDefaults.standard.string(forKey: "login_user_id") {
                return value
            }
            return ""
        }
        set {
            let id = newValue
            UserDefaults.standard.set(id, forKey: "login_user_id")
        }
    }
    var name: String {
        get {
            if let value = UserDefaults.standard.string(forKey: "login_user_name") {
                return value
            }
            return "Unknow"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "login_user_name")
        }
    }
    
    var appleName: String {
        get {
            if let value = UserDefaults.standard.string(forKey: "login_apple_name") {
                return value
            }
            return "iPhone用户"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "login_apple_name")
        }
    }
}


enum AuthAPIKey {
    static let refreshTokenKey = "https://api.weixin.qq.com/sns/oauth2/access_token?"
    static let profileKey = "https://api.weixin.qq.com/sns/userinfo?"
}

class AuthWechatHandle {
    static let shared = AuthWechatHandle()
    private init() {}

    func reqeustToken(urlstring: String, completion:@escaping ActionBlock<AuthWXTokenModel>) {
        if let url = URL(string: urlstring) {
            let manager = Alamofire.Session.default
            manager.session.configuration.timeoutIntervalForRequest = 8
            manager.request(url).responseString { (responseData) in
                switch responseData.result {
                case .success(_):
                    if let model = AuthWXTokenModel.deserialize(from: responseData.value) {
                        completion(model)
                    }
                case .failure(_):
                    if let model = AuthWXTokenModel.deserialize(from: responseData.value) {
                        completion(model)
                    }
                }
            }
        }
    }

    func requestProfile(urlstring: String, completion: @escaping ActionBlock<AuthWXProfileModel>) {
        if let url = URL(string: urlstring) {
            let manager = Alamofire.Session.default
            manager.session.configuration.timeoutIntervalForRequest = 8
            manager.request(url).responseString(encoding: .utf8, completionHandler: { (responseData) in
                if let model = AuthWXProfileModel.deserialize(from: responseData.value) {
                    completion(model)
                }
            })
        }
    }

}

class AuthWXTokenModel: HandyJSON {
    var accessToken: String?
    var expiresIn: Int?
    var refreshToken: String?
    var openid: String?
    var scope: String?
    var unionid: String?
    var errCode: Int?
    var errMessage: String?

    required init() {}

    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.accessToken <-- "access_token"
        mapper <<<
            self.expiresIn <-- "expires_in"
        mapper <<<
            self.refreshToken <-- "refresh_token"
        mapper <<<
            self.errCode <-- "errcode"
        mapper <<<
            self.errMessage <-- "errmsg"
    }
}

class AuthWXProfileModel: HandyJSON {
    var openid: String?
    var nickname: String?
    var sex: Int?
    var province: String?
    var city: String?
    var country: String?
    var headimgurl: String?
    var errcode: Int?
    var errmsg: String?

    required init() {}
}


enum SocialType {
    static let wechat = "wechat"
    static let apple = "apple"
}


class TokenHandle {
    static let shared = TokenHandle()
    private init() {}

    private let authRequest = AuthRequest()

    private var _loginDisposable: Disposable?
    func login(token: String, socialID: String, socialType: String, nickName: String, successBlock: @escaping EmptyBlock, failedBlock: @escaping EmptyBlock) {
        let clientId = TokenManager.instance.clientId
        self._loginDisposable = self.authRequest.social(clientId,
                                                        socialID,
                                                        socialType,
                                                        token,
                                                        nickName).subscribe(onNext: { (model) in
                                                            Preference.accessToken = model.accessToken
                                                            Preference.refreshToken = model.refreshToken
                                                            Preference.userID = model.uid
                                                            successBlock()
        }, onError: { (error) in
            //TODO: how can I get error code
            let err = error as! MoyaError
            let code = err.errorCode
            if let value = err.response?.data {
                print("login error, errCode: \(code): \(String(data: value, encoding: .utf8)!)")
                Logger.shared.upload(event: "Login", message: "ErrCode: \(code): \(String(data: value, encoding: .utf8)!)")
            }
            failedBlock()
        }, onCompleted: {
            self._loginDisposable?.dispose()
        }, onDisposed: nil)
    }


    private var _refreshDisposable: Disposable?
    func refresh(successed: @escaping EmptyBlock, failure: @escaping EmptyBlock) {
        if let refreshToken = Preference.refreshToken {
            self._refreshDisposable = self.authRequest.refreshToken(TokenManager.instance.clientId, refreshToken).subscribe(onNext: { (tokenModel) in
                Preference.accessToken = tokenModel.accessToken
                Preference.refreshToken = tokenModel.refreshToken
                Preference.userID = tokenModel.uid
                successed()
            }, onError: { (error) in
                let err = error as! MoyaError
                let code = err.errorCode
                if let value = err.response?.data {
                    print("login error, errCode: \(code): \(String(data: value, encoding: .utf8)!)")
                    Logger.shared.upload(event: "Login Refresh", message: "ErrCode: \(code): \(String(data: value, encoding: .utf8)!)")
                }
                failure()
                // handle error
            }, onCompleted: {
                print("login complete")
                self._refreshDisposable?.dispose()
            }, onDisposed: nil)

        } else {
            failure()
        }
    }

    func logout() {
        Preference.accessToken = nil
        Preference.refreshToken = nil
    }
}
