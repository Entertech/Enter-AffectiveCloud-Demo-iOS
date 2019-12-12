//
//  PersonalViewController.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/12/9.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class PersonalViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var userIdTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    var picker = UIPickerView()
    var barButtonItem: UIBarButtonItem?
    let disposeBag = DisposeBag()
    var bgView: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "个人信息"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        barButtonItem = UIBarButtonItem(title: "下一步", style: .plain, target: self, action: #selector(nextStep))
        self.navigationItem.rightBarButtonItem = barButtonItem
        
        setUI()
    }
    
    func setUI() {
        let idEnable = userIdTF.rx.text.orEmpty.map { (value) -> Bool in
            return value.count > 0
        }

        idEnable.bind(to: barButtonItem!.rx.isEnabled).disposed(by: disposeBag)
        
        userIdTF.delegate = self
        genderTF.delegate = self
        ageTF.delegate = self
        
    }
    
    @objc
    func nextStep() {
        PersonalInfo.age = ageTF.text
        PersonalInfo.userId = userIdTF.text
        
        let experiment = ExperimentCenterViewController()
        let vc = UINavigationController(rootViewController: experiment)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    // MARK: - picker
    private func setTimerPickerView() {
        if let bgView = self.bgView {
            genderTF.resignFirstResponder()
            bgView.isHidden = false
        } else {
            genderTF.resignFirstResponder()
            bgView = UIView()
            // 黑色背景
            bgView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            self.view.addSubview(bgView!)
            bgView?.snp.makeConstraints{
                $0.left.right.top.bottom.equalToSuperview()
            }
            
            // 时间选择器
            picker.delegate = self
            picker.dataSource = self
            picker.backgroundColor = .white
            bgView?.addSubview(picker)
            picker.snp.makeConstraints{
                $0.left.right.bottom.equalToSuperview()
                $0.height.equalTo(160)
            }
            
            // 菜单栏
            let menu = UIView()
            bgView?.addSubview(menu)
            menu.backgroundColor = .white
            menu.snp.makeConstraints{
                $0.left.right.equalToSuperview()
                $0.bottom.equalTo(picker.snp.top)
                $0.height.equalTo(44)
            }
            
            let cancelBtn = UIButton()
            cancelBtn.setTitle("取消", for: .normal)
            cancelBtn.setTitleColor(.systemBlue, for: .normal)
            cancelBtn.addTarget(self, action: #selector(cancelTouchupInside), for: .touchUpInside)
            menu.addSubview(cancelBtn)
            cancelBtn.snp.makeConstraints {
                $0.left.equalToSuperview().offset(16)
                $0.centerY.equalToSuperview()
            }
            
            let okBtn = UIButton()
            okBtn.setTitle("完成", for: .normal)
            okBtn.setTitleColor(.systemBlue, for: .normal)
            okBtn.addTarget(self, action: #selector(okTouchupInside), for: .touchUpInside)
            menu.addSubview(okBtn)
            okBtn.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-16)
                $0.centerY.equalToSuperview()
            }

        }
        
    }
    
    @objc
    private func cancelTouchupInside() {
        self.bgView?.isHidden = true
    }
    
    @objc
    private func okTouchupInside() {
        genderTF.text = gender[picker.selectedRow(inComponent: 0)]
        PersonalInfo.sex = picker.selectedRow(inComponent: 0)
        self.bgView?.isHidden = true
    }
    
    //MARK:- textfield delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == genderTF {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: {
                self.setTimerPickerView()
            })
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let len = textField.text!.count + string.count - range.length
        
        if textField == userIdTF {
            return len<=32
        } else if textField == genderTF {
            return len==0
        } else if textField == ageTF {
            return len<=2
        }
        return true
    }
    
    //MARK:- picker Delegate
    
    var gender = ["男", "女"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }

}
