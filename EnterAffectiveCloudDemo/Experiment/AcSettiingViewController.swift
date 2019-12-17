//
//  acSettiingViewController.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/12/5.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import EnterAffectiveCloud
import RxSwift
import RxCocoa
import Moya

class AcSettiingViewController: UIViewController, UITextFieldDelegate {

    private let titleLabel = UILabel()
    private let confirmBtn = UIButton()
    private let appIdTF = UITextField()
    private let appSecretTF = UITextField()
    private let appIdLB = UILabel()
    private let appSecretLB = UILabel()
    private let tipLB = UILabel()
    private let disposeBag = DisposeBag()
    
    private let keySkey = "keySkey"
    private let secretSkey = "secretSkey"
    
    private var key: String? {
        get {
            return UserDefaults.standard.string(forKey: keySkey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: keySkey)
        }
    }
    
    private var secret: String? {
        get {
            return UserDefaults.standard.string(forKey: secretSkey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: secretSkey)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        PersonalInfo.age = nil
        PersonalInfo.sex = nil
        PersonalInfo.userId = nil
        setUI()
        setLayout()
    }
    
    private func setUI() {
        self.view.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.9764705882, alpha: 1)
        //self.navigationItem.title = "实验设置"
//        let barButtonItem = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(confirm))
//        self.navigationItem.rightBarButtonItem = barButtonItem
        titleLabel.text = "实验设置"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        self.view.addSubview(titleLabel)
        
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.setTitleColor(.systemBlue, for: .normal)
        confirmBtn.setTitleColor(.gray, for: .disabled)
        confirmBtn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        self.view.addSubview(confirmBtn)
        
        //textfield
        appIdTF.text = key
        appIdTF.delegate = self
        appIdTF.keyboardType = .default
        appIdTF.borderStyle = .roundedRect
        appIdTF.clearButtonMode = .whileEditing
        appIdTF.returnKeyType = .next
        appIdTF.autocapitalizationType = .none
        appIdTF.autocorrectionType = .no
        self.view.addSubview(appIdTF)
        
        appSecretTF.text = secret
        appSecretTF.delegate = self
        appSecretTF.keyboardType = .default
        appSecretTF.borderStyle = .roundedRect
        appSecretTF.clearButtonMode = .whileEditing
        appSecretTF.returnKeyType = .done
        appSecretTF.autocapitalizationType = .none
        appSecretTF.autocorrectionType = .no
        self.view.addSubview(appSecretTF)
        
        appIdLB.text = "APP ID"
        appIdLB.font = UIFont.systemFont(ofSize: 13)
        appIdLB.textColor = UIColor.hexStringToUIColor(hex: "7B7B81")
        self.view.addSubview(appIdLB)
        
        appSecretLB.text = "APP SECRET"
        appSecretLB.font = UIFont.systemFont(ofSize: 13)
        appSecretLB.textColor = UIColor.hexStringToUIColor(hex: "7B7B81")
        self.view.addSubview(appSecretLB)
        
        let attributedText = NSMutableAttributedString(string:"复制管理员发送的 App ID 和 App Secret 来同步实验信息。")
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineSpacing = 5
        attributedText.addAttribute(
            kCTParagraphStyleAttributeName as NSAttributedString.Key,
            value: style,
            range: NSMakeRange(0, attributedText.length))
        
        tipLB.attributedText = attributedText
        tipLB.font = UIFont.systemFont(ofSize: 13)
        self.view.addSubview(tipLB)
        
        
        let idEnable = appIdTF.rx.text.orEmpty.map { (value) -> Bool in
            return value.count > 10
        }
        let secretEnable = appSecretTF.rx.text.orEmpty.map{ (value) -> Bool in
            return value.count > 10
        }
        
        let loginObserver = Observable.combineLatest(secretEnable, idEnable){(account,password) in
            account && password
        }
        loginObserver.bind(to: confirmBtn.rx.isEnabled).disposed(by: disposeBag)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        confirmBtn.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.right.equalToSuperview().offset(-20)
        }
        
        appIdLB.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(80)
            $0.left.equalToSuperview().offset(20)
        }
        
        appIdTF.snp.makeConstraints {
            $0.top.equalTo(appIdLB.snp.bottom).offset(4)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(44)
        }
        
        appSecretLB.snp.makeConstraints {
            $0.top.equalTo(appIdTF.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(16)
        }
        
        appSecretTF.snp.makeConstraints {
            $0.top.equalTo(appSecretLB.snp.bottom).offset(4)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(44)
        }
        
        tipLB.snp.makeConstraints {
            $0.left.equalTo(24)
            $0.right.equalTo(-24)
            $0.height.equalTo(44)
            $0.top.equalTo(appSecretTF.snp.bottom).offset(8)
        }
    }
    
    
    @objc
    private func confirm() {
        appSecretTF.resignFirstResponder()
        appIdTF.resignFirstResponder()

        let tokenRequest = TokenRequest()
        if let key = appIdTF.text, let secret = appSecretTF.text {
            SVProgressHUD.show()
            tokenRequest.token(appKey: key, appSecret: secret, userId: "\(Preference.clientId)", version: "v1")
            DispatchQueue.global().async {
                var count = 0
                let timers = DispatchSource.makeTimerSource()
                timers.setEventHandler {
                    if tokenRequest.state != 0 {
                        print("start \(Date())")
                        DispatchQueue.main.async {
                            if tokenRequest.state == 1 && TagService.shared.token != nil {
                                self.readTag()
                                self.key = self.appIdTF.text
                                self.secret = self.appSecretTF.text
                            } else if tokenRequest.state == -1 {
                                SVProgressHUD.showError(withStatus: "设置失败")
                            }
                        }
                        timers.suspend()
                        timers.cancel()
                    }
                    count += 1
                    if count > 10 {
                        timers.suspend()
                        timers.cancel()
                        DispatchQueue.main.async {
                            if SVProgressHUD.isVisible() {
                                SVProgressHUD.dismiss(withDelay: 2)
                            }
                        }
                    }
                }
                
                timers.schedule(deadline: DispatchTime.now(), repeating: 2)
                timers.resume()

            }
        }
    }
    
    func readTag() {
        let tagRequest = TagRequest()
        tagRequest.list("v1").subscribe(onNext: { (models) in
            ACTagModel.shared.tagModels = models
        }, onError: {(error) in
            let err = error as! MoyaError
            if let errMsg = err.response?.data {
                print(String(data: errMsg, encoding: .utf8) as Any)
            }
        }, onCompleted: {
            print("finish \(Date())")
            SVProgressHUD.showSuccess(withStatus: "设置成功")
            SVProgressHUD.dismiss(withDelay: 1, completion: {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "tabBarcontroller") as! UITabBarController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            })
        }, onDisposed: nil).disposed(by: disposeBag)
    }
    
    //MARK:- TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == appIdTF {
            appSecretTF.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

}
