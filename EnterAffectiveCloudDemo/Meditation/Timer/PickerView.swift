//
//  PickerView.swift
//  Flowtime
//
//  Created by Anonymous on 2019/4/25.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

class PickerView: UIView {

    var unit = "" {
        didSet {
            self.pickerView.reloadComponent(1)
        }
    }

    var items = [String]() {
        didSet {
            self.pickerView.reloadComponent(0)
        }
    }

    var selectedIndex: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.setup()
        self.layout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func poper(_ completion: EmptyBlock? = nil) {
        self.contentView.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: 268)
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut, animations: {
            self.contentView.frame = CGRect(x: 0, y: self.bounds.height - 268, width: self.bounds.width, height: 268)
            self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        }, completion: { flag in
            if flag  {
                completion?()
            }
        })
    }

    func dismiss(_ completion: EmptyBlock? = nil) {
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut, animations: {
            self.contentView.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: 268)
            self.backgroundColor = .clear
        }, completion: { flag in
            if flag {
                completion?()
            }
        })
    }

    let titleLabel = UILabel(frame: .zero)
    let pickerView = UIPickerView(frame: .zero)
    let cancelButton = UIButton()
    let okButton = UIButton()
    private let contentView = UIView()
    private func setup() {
        pickerView.showsSelectionIndicator = true
        pickerView.backgroundColor = Colors.bgZ1
        self.contentView.backgroundColor = Colors.bg1
        self.addSubview(contentView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(cancelButton)
        self.contentView.addSubview(okButton)
        self.contentView.addSubview(pickerView)
        titleLabel.textAlignment = .center
        titleLabel.textColor = Colors.textLv1
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(Colors.btn1, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        okButton.setTitle("OK", for: .normal)
        okButton.setTitleColor(Colors.btn1, for: .normal)
        okButton.setTitleColor(Colors.btnDisable, for: .disabled)
        okButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    }

    private func layout() {
        self.contentView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(268)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.greaterThanOrEqualTo(120)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(okButton.snp.centerY).offset(0)
        }

        self.cancelButton.snp.makeConstraints {
            $0.top.equalTo(5)
            $0.left.equalTo(12)
            $0.height.equalTo(44)
            $0.width.equalTo(60)
        }
        self.okButton.snp.makeConstraints {
            $0.top.equalTo(5)
            $0.right.equalTo(-12)
            $0.width.height.equalTo(44)
        }

        self.pickerView.snp.makeConstraints {
            $0.top.equalTo(self.cancelButton.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
