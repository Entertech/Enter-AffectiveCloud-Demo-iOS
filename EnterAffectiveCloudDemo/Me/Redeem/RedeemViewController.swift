//
//  RedeemViewController.swift
//  Flowtime
//
//  Created by Enter on 2019/7/18.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Networking
import Moya
import SVProgressHUD
import Firebase

class RedeemViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var warnImage2: UIImageView!
    @IBOutlet weak var warnImage1: UIImageView!
    @IBOutlet weak var warnLabel1: UILabel!
    @IBOutlet weak var warnLabel2: UILabel!
    @IBOutlet weak var redeemTF: UITextField!
    @IBOutlet weak var redeemBtn: UIButton!
    private  let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        redeemBtn.setBackgroundImage(#imageLiteral(resourceName: "img_blue_btn"), for: .normal)
        redeemBtn.setBackgroundImage(#imageLiteral(resourceName: "img_disable_btn"), for: .disabled)
        redeemBtn.setTitle("Redeem", for: .normal)
        redeemBtn.setTitle("Redeem", for: .disabled)
        redeemTF.delegate = self
        warnImage1.image = #imageLiteral(resourceName: " icon_warn")
        warnImage2.image = #imageLiteral(resourceName: " icon_warn")
        warnLabel1.text = "Each code can be used only once"
        warnLabel2.text = "Please note case sensitive"
        Analytics.setScreenName("兑换界面", screenClass: "RedeemViewController")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let btnEnable = redeemTF.rx.text.orEmpty.map { (value) -> Bool in
            return value.count > 0
        }
        btnEnable.bind(to: redeemBtn.rx.isEnabled).disposed(by: disposeBag)
        self.view.backgroundColor = Colors.bg1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emptyNavigationBar()
        
        self.navigationController?.navigationBar.topItem?.title = "Redeem"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nonEmptyBar()
        if redeemTF.isFirstResponder {
            redeemTF.resignFirstResponder()
        }
    }
    
    @IBAction func redeemBtnPressed(_ sender: UIButton) {
        if redeemTF.isFirstResponder {
            redeemTF.resignFirstResponder()
        }
        Appearance.setRecord("1501", "兑换界面 兑换")
        uploadRedeem()
    }
    
    private func nonEmptyBar() {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    private func emptyNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    ///上传兑换码
    private func uploadRedeem() {
        let request = RedeemRequest()
        var isSuccess = false
        SVProgressHUD.show()
        self.redeemBtn.isEnabled = false
        //提交app id
        request.userRedeem(String(App.userID), redeemTF.text!).subscribe(onNext: { (model) in
            if model.code == 0 {
                isSuccess = true
                SVProgressHUD.showSuccess(withStatus: "Redeem success!")
                self.redeemTF.text = ""
            } else {
                SVProgressHUD.showError(withStatus: model.msg)
            }
        }, onError: { (err) in
            let error = err as! MoyaError
            self.redeemBtn.isEnabled = true
            //print(String(data: error.response!.data, encoding: String.Encoding.utf8) as Any)
            if let response = error.response {
                SVProgressHUD.showError(withStatus: "Network Error")
            } else {
                SVProgressHUD.showError(withStatus: "Failed")
            }
            
        }, onCompleted: {
            self.redeemBtn.isEnabled = true
            if isSuccess {
                //兑换成功后，刷新会员信息
                SubscriptionHandler.shared.fetchMemberInfo(successBlock: { (member) in
                    if member.isExpired {
                        Preference.memberMode = .normal
                    } else {
                        Preference.memberMode = member.memberMode
                    }
                    Preference.memberExpiredInterval = member.expiredIntervalTimeSince1970
                }, emptyMemberInfo: {Preference.memberMode = .normal}, failureBlock: {
                    
                })
            }
        }, onDisposed: nil).disposed(by: disposeBag)
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        uploadRedeem()
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let len = textField.text!.count + string.count - range.length
        return len<=10
    }

}
