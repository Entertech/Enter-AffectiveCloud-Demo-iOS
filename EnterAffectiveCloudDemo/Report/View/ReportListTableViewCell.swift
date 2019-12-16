//
//  ReportListTableViewCell.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/17.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

class ReportListTableViewCell: UITableViewCell {

    init(reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .default
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = .white
        setup()
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        layout()
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
    }

    let imageview = UIImageView()

    let weekLabel = UILabel()
    

    let minuteLabel = UILabel()

    let fromToLabel = UILabel()

    var isMeditationRecord = false {
        didSet {
            self.meditationTagView.isHidden = !isMeditationRecord
        }
    }
    
    var isSample = false {
        didSet {
            self.meditationTagView.isHidden = false
        }
    }

    var cellColor: UIColor = .randomColor() {
        didSet {
            self.cardView.backgroundColor = cellColor
        }
    }

    var literalColor: UIColor = .randomColor() {
        didSet {
            self.weekLabel.textColor = literalColor
            self.minuteLabel.textColor = literalColor
            self.fromToLabel.textColor = literalColor
        }
    }

    private let cardView = UIView()

    private let meditationTagView = UIButton()

    func setup() {
        weekLabel.font = UIFont.systemFont(ofSize: 12)
        minuteLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        fromToLabel.font = UIFont.systemFont(ofSize: 14)
        
        meditationTagView.setImage(#imageLiteral(resourceName: "icon_record_meditation_flag"), for: .normal)
        meditationTagView.setTitle("Biodata", for: .normal)
        meditationTagView.setTitleColor(#colorLiteral(red: 1, green: 0.8941176471, blue: 0.7333333333, alpha: 1), for: .normal)
        meditationTagView.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        meditationTagView.layer.cornerRadius = 11
        meditationTagView.backgroundColor = #colorLiteral(red: 0.07450980392, green: 0.06666666667, blue: 0.05098039216, alpha: 0.8)
        
        meditationTagView.imageView?.contentMode = .center
        cardView.layer.cornerRadius = 8
        cardView.clipsToBounds = true
        cardView.addSubview(imageview)
        cardView.addSubview(weekLabel)
        cardView.addSubview(minuteLabel)
        cardView.addSubview(fromToLabel)
        cardView.addSubview(meditationTagView)
        self.contentView.addSubview(cardView)
    }

    func layout() {
        imageview.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }

        cardView.snp.makeConstraints {
            $0.left.equalTo(16)
            $0.right.equalTo(-16)
            $0.top.equalTo(8)
            $0.bottom.equalTo(-8)
        }

        weekLabel.snp.makeConstraints {
            $0.left.top.equalToSuperview().offset(16)
        }

        minuteLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalTo(weekLabel.snp.bottom).offset(4)
        }

        fromToLabel.snp.makeConstraints {
            $0.bottom.equalTo(-16)
            $0.left.equalToSuperview().offset(16)
        }

        meditationTagView.snp.makeConstraints {
            $0.top.equalTo(8)
            $0.right.equalTo(-8)
            $0.height.equalTo(24)
            $0.width.equalTo(95)
        }
    }

}
