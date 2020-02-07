//
//  ReportAboutView.swift
//  Flowtime
//
//  Created by Enter on 2019/12/31.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloudUI
import SafariServices

class ReportAboutView: BaseView {
    enum AboutIcon {
        case blue
        case red
        case yellow
    }
    enum AboutStyle {
        case brain
        case hrv
        case hr
        case relaxation
        case pressure
    }
    
    var icon: AboutIcon = .blue {
        willSet {
            switch newValue {
            case .blue:
                header.image = #imageLiteral(resourceName: "icon_report_help_blue")
            case .red:
                header.image = #imageLiteral(resourceName: "icon_report_help_red")
            case .yellow:
                header.image = #imageLiteral(resourceName: "icon_report_help_yellow")
            }
        }
    }
    
    var text: String = "" {
        willSet {
            let attributedText = NSMutableAttributedString(string: newValue)
            let style = NSMutableParagraphStyle()
            style.alignment = .left
            style.lineSpacing = 5
            attributedText.addAttribute(
                kCTParagraphStyleAttributeName as NSAttributedString.Key,
                value: style,
                range: NSMakeRange(0, attributedText.length))
            label.attributedText = attributedText
        }
    }
    
    var style: AboutStyle = .brain
    
    private let label = UILabel()
    let btn = UIButton()
    private let header = PrivateReportViewHead()
    override func didMoveToSuperview() {
        super.didMoveToSuperview()

    }
    
    override func setup() {
        self.setShadow()
        self.addSubview(label)
        self.addSubview(btn)
        self.addSubview(header)
        header.titleText = "关于"
        header.barButton.isHidden = true
        
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        btn.setTitle("了解更多", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitleColor(UIColor.colorWithHexString(hexColor: "#4B5DCC"), for: .normal)
        btn.addTarget(self, action: #selector(showWeb), for: .touchUpInside)
    }
    
    override func layout() {
        label.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        
        btn.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(4)
            $0.left.equalTo(0)
            $0.width.equalTo(116)
            $0.height.equalTo(21)
            $0.bottom.equalToSuperview().offset(-14)
        }
        
    }
    
    @objc private func showWeb() {
        switch self.style {
        case .brain:
            self.presentSafari(FTURLManager.helpCenter)
        case .hrv:
            self.presentSafari(FTURLManager.helpCenter)
        case .hr:
            self.presentSafari(FTURLManager.helpCenter)
        case .relaxation:
            self.presentSafari(FTURLManager.helpCenter)
        case .pressure:
            self.presentSafari(FTURLManager.helpCenter)
        @unknown default:
            break
        }
    }
    
    private func presentSafari(_ url: String) {

        let sf = SFSafariViewController(url: URL(string: url)!)
        self.paretViewController()?.present(sf, animated: true, completion: nil)
        
    }
}
