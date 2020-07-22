//
//  LogiinViewController.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/6/30.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import SVProgressHUD
import SafariServices
import Alamofire
import Networking
import RxSwift
import AuthenticationServices

class LoginViewController: UIViewController, ASAuthorizationControllerDelegate,
ASAuthorizationControllerPresentationContextProviding {

    @IBOutlet weak var wechatBtn: UIButton!
    @IBOutlet weak var weChartBtnTop: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        wechatBtn.layer.cornerRadius = 22
        wechatBtn.layer.masksToBounds = true
        
        if #available(iOS 13.0, *) {

            let appleBtns: ASAuthorizationAppleIDButton?
            if traitCollection.userInterfaceStyle == .dark {
                appleBtns = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
            } else {
                appleBtns = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
            }
            appleBtns?.layer.cornerRadius = 24
            appleBtns?.layer.masksToBounds = true
            appleBtns?.addTarget(self, action: #selector(appleAuth), for: .touchUpInside)
            self.view.addSubview(appleBtns!)
            weChartBtnTop.constant = 90

            appleBtns?.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.left.equalToSuperview().offset(36)
                $0.right.equalToSuperview().offset(-36)
                $0.height.equalTo(44)
                $0.bottom.equalTo(self.wechatBtn.snp.top).offset(-16)
            }
        }
        
        wechatBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -10, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationName.kAuthorizationTokenResponse.observe(sender: self, selector: #selector(self.responseAuthorizationToken(_:)))
        
        if let refreshToken = Preference.refreshToken {
            SVProgressHUD.show()
            
            TokenHandle.shared.refresh(successed: {
                SVProgressHUD.dismiss()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
                viewController.modalTransitionStyle = .crossDissolve
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            }) {
                SVProgressHUD.showError(withStatus: "刷新登录信息失败")
            }
        }
//        TokenHandle.shared.refresh(successed: {
//            self.setupLoginin()
//        }) {
//            SVProgressHUD.showError(withStatus: "refresh token failed!")
//            let controller = FaceBookViewController()
//            controller.modalPresentationStyle = .fullScreen
//            controller.modalTransitionStyle = .flipHorizontal
//            self.present(controller, animated: true, completion: nil)
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        hw_openEventServiceWithBolck(action: { (flag) in
            if !flag {
                let noti = UIAlertController(title: "网络设置", message: "请在 设置->心流 里找到无线数据，打开心流的网络权限。", preferredStyle: .alert)
                let okBtn = UIAlertAction(title: "好的", style: .default, handler: nil)
                noti.addAction(okBtn)
                self.present(noti, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func wechatLogin(_ sender: Any) {
        if WXApi.isWXAppInstalled() {
            SVProgressHUD.show()
            SVProgressHUD.dismiss(withDelay: 10)
            let req = SendAuthReq()
            req.scope = "snsapi_userinfo"
            req.state = "send_code"
            
            WXApi.send(req) { (success) in
                if !success {
                    SVProgressHUD.showError(withStatus: "微信授权失败!")
                }
            }
        } else {
            let action = UIAlertAction(title: "好的", style: .cancel, handler: nil)
            let alertVC = UIAlertController.init(title: "提示", message: "未在您设备上找到微信", preferredStyle: .alert)
            alertVC.addAction(action)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    
    /// 检测是否开启联网
    func hw_openEventServiceWithBolck(action :@escaping ((Bool)->())) {
        if let wifi = NetworkReachabilityManager.default?.isReachableOnEthernetOrWiFi, let cell = NetworkReachabilityManager.default?.isReachableOnCellular, wifi || cell {
            NetworkReachabilityManager.default?.startListening(onUpdatePerforming: { (status) in
                switch(status) {
                case .unknown:
                    action(false)
                case .notReachable:
                    action(false)
                case .reachable(_):
                    action(true)
                }
            })
        } else {
            action(false)
        }
    }
    
    @objc
    private func responseAuthorizationToken(_ notification: Notification) {
        if let info = notification.userInfo,
            let token = info[NotificationKey.kResponseAuthTokenKey.rawValue] as? String,
            let userID = info[NotificationKey.kResponseAuthUserIDKey.rawValue] as? String,
            let name = info[NotificationKey.kResponseAuthUserNameKey.rawValue] as? String,
            let socialType = info[NotificationKey.KResponseAuthSocialType.rawValue] as? String {
            DispatchQueue.main.async {
                SVProgressHUD.show()
            }
            self.login(with: token, userID: userID, socialType: socialType, nickName: name)
        } else {
            SVProgressHUD.showError(withStatus: "授权失败!")
        }
    }
    
    private let _disposeBag = DisposeBag()
    private let authRequest = AuthRequest()
    private func login(with token: String, userID: String, socialType: String, nickName: String) {
        TokenHandle.shared.login(token: token, socialID: userID, socialType: socialType, nickName: nickName, successBlock: {
            DispatchQueue.main.async {
                //SVProgressHUD.showSuccess(withStatus: "登录成功!")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController")
                viewController.modalTransitionStyle = .crossDissolve
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            }
        })  {
            DispatchQueue.main.async {
                SVProgressHUD.showError(withStatus: "登录失败!")
            }
        }
    }
    
    @available(iOS 13.0, *)
    @objc func appleAuth() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email, .fullName]
        let vc = ASAuthorizationController.init(authorizationRequests: [request])
        vc.delegate = self
        vc.presentationContextProvider = self
        vc.performRequests()
    }
    
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {

        SVProgressHUD.showError(withStatus: "授权失败！")
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        LoginService.shared.appleAuthSuccess(authorization: authorization)
    }

    @IBAction func privacyAction(_ sender: Any) {
        presentSafari(FTRemoteConfig.shared.getConfig(key: .privacy)!)
    }
    @IBAction func termsAction(_ sender: Any) {
         presentSafari(FTRemoteConfig.shared.getConfig(key: .items)!)
    }
    
    /// Safari 显示网页
    private func presentSafari(_ defaultKey: String) {
        if let url = URL(string: defaultKey) {
            let sf = SFSafariViewController(url: url)
            present(sf, animated: true, completion: nil)
        }
    }

}
