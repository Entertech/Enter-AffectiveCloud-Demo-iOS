//
//  AskforStartsView.swift
//  Flowtime
//
//  Created by Enter on 2020/3/2.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit

class AskforStartsView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
//    override func didMoveToSuperview() {
//        super.didMoveToSuperview()
//        guard let superview = self.superview else {
//            return
//        }
//
//    }
    
    let laterBtn = UIButton(type: .custom)
    let likeBtn = UIButton(type: .custom)
    
    private func setUI() {
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        let bgIV = UIImageView()
        var image = UIImage(named: "img_beg_bg")
        self.addSubview(bgIV)
        let insets = UIEdgeInsets(top: 0, left: 220, bottom: 0, right: 120)
        image = image?.resizableImage(withCapInsets: insets, resizingMode: .stretch)
        bgIV.image = image
        bgIV.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let titleLabel = UILabel()
        self.addSubview(titleLabel)
        titleLabel.text = "给心流打个五星吧！"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = UIColor.white
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(18)
            $0.top.equalToSuperview().offset(20)
        }
        
        let contentLabel = UILabel()
        self.addSubview(contentLabel)
        let attributedText = NSMutableAttributedString(string:"如果您喜欢心流，请给我们的应用打个五星吧，谢谢您！")
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineSpacing = 4
        attributedText.addAttribute(
            kCTParagraphStyleAttributeName as NSAttributedString.Key,
            value: style,
            range: NSMakeRange(0, attributedText.length))
        contentLabel.attributedText = attributedText
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.textColor = .white
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(18)
            $0.right.equalToSuperview().offset(-85)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        let laterColor = UIColor(white: 1, alpha: 0.8)
        self.addSubview(laterBtn)
        laterBtn.setTitle("下次", for: .normal)
        laterBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        laterBtn.setTitleColor(laterColor, for: .normal)
        laterBtn.layer.cornerRadius = 16
        laterBtn.layer.borderColor = laterColor.cgColor
        laterBtn.layer.borderWidth = 2
        laterBtn.backgroundColor = .clear
        laterBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.left.equalToSuperview().offset(18)
            $0.width.equalTo(64)
            $0.height.equalTo(32)
        }
        
        self.addSubview(likeBtn)
        likeBtn.setTitle("喜欢", for: .normal)
        likeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        likeBtn.setTitleColor(.white, for: .normal)
        likeBtn.backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.6117647059, blue: 0.5960784314, alpha: 1)
        likeBtn.layer.cornerRadius = 16
        likeBtn.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.left.equalTo(laterBtn.snp.right).offset(18)
            $0.width.equalTo(64)
            $0.height.equalTo(32)
        }
    }
}
