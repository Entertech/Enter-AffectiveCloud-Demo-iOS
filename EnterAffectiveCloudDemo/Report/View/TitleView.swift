//
//  BoardView.swift
//  Flowtime
//
//  Created by Enter on 2019/6/3.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TitleView: BaseView {

    public var detailBlock: EmptyBlock?
    private let disposeBag = DisposeBag()
    private let iconImageView = UIImageView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let infoBtn = UIButton(frame: .zero)
    public var iconImage: UIImage? {
        willSet {
            iconImageView.image = newValue
        }
    }
    
    public var titleText: String? {
        willSet {
            titleLabel.text = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setup() {
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        self.addSubview(infoBtn)
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = Colors.textLv1
        infoBtn.setImage(UIImage(named: "icon_infoCircle"), for: .normal)
        infoBtn.rx.tap.bind { [weak self] in
            guard let self = self else {return}
            self.detailBlock?()
        }.disposed(by: disposeBag)
        
    }
    
    override func layout() {
        iconImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(16)
            $0.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints{
            $0.left.equalTo(iconImageView.snp.right).offset(16)
            $0.top.equalToSuperview().offset(18)
            $0.width.equalTo(200)
            $0.height.equalTo(19)
        }
        
        infoBtn.snp.makeConstraints{
            $0.top.equalToSuperview().offset(6)
            $0.right.equalToSuperview().offset(-6)
            $0.width.height.equalTo(44)
        }
    }
    
    public var isNeedBtn: Bool = false {
        willSet {
            self.infoBtn.isHidden = !newValue
        }
    }

}
