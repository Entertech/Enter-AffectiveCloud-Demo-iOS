//
//  RecordViewCell.swift
//  Flowtime
//
//  Created by Anonymous on 2019/6/21.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import Then

class RecordViewCell: UITableViewCell {

    init(reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .default
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = Colors.bgZ1
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

    let timeLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = #colorLiteral(red: 0.3882352941, green: 0.4980392157, blue: 0.4470588235, alpha: 1)
        $0.textAlignment = .left
    }

    let lessonLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textColor = #colorLiteral(red: 0.3333333333, green: 0.3568627451, blue: 0.4980392157, alpha: 1)
        $0.textAlignment = .left
    }

//    let courseLabel = UILabel().then {
//        $0.font = UIFont.systemFont(ofSize: 14)
//        $0.textColor = #colorLiteral(red: 0.4980392157, green: 0.4470588235, blue: 0.368627451, alpha: 1)
//        $0.textAlignment = .left
//    }
    
    let sampleLabel = UILabel().then { (label) in
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = Colors.textLv1
        label.text = "(Sample data)"
        label.textAlignment = .left
    }

    var isMeditationRecord = false {
        didSet {
//            self.meditationTagView.isHidden = !isMeditationRecord
            self.sampleLabel.isHidden = true
        }
    }
      
    var isSample = false {
        didSet {
//            self.meditationTagView.isHidden = false
            self.sampleLabel.isHidden = false
        }
    }

    var cellColor: UIColor = .random() {
        didSet {
            self.cardView.backgroundColor = cellColor
        }
    }

    var literalColor: UIColor = .random() {
        didSet {
            self.timeLabel.textColor = literalColor
            self.lessonLabel.textColor = literalColor
            //self.courseLabel.textColor = literalColor
        }
    }

    private let cardView = UIView().then {
        $0.layer.cornerRadius = 8
    }

//    private let meditationTagView = UIButton().then {
//        $0.setImage(#imageLiteral(resourceName: "icon_record_meditation_flag"), for: .normal)
//        $0.setTitle("Biodata", for: .normal)
//        $0.setTitleColor(#colorLiteral(red: 1, green: 0.8941176471, blue: 0.7333333333, alpha: 1), for: .normal)
//        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
//        $0.backgroundColor = #colorLiteral(red: 0.07450980392, green: 0.06666666667, blue: 0.05098039216, alpha: 0.8)
//        $0.layer.cornerRadius = 11
//    }

    func setup() {
        cardView.clipsToBounds = true
        cardView.addSubview(imageview)
        cardView.addSubview(timeLabel)
        cardView.addSubview(lessonLabel)
        //cardView.addSubview(courseLabel)
        cardView.addSubview(sampleLabel)
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

        timeLabel.snp.makeConstraints {
            $0.left.top.equalTo(16)
            $0.height.equalTo(18)
            $0.width.equalTo(160)
        }

        lessonLabel.snp.makeConstraints {
            $0.left.equalTo(timeLabel.snp.left)
            $0.top.equalTo(timeLabel.snp.bottom).offset(4)
            $0.height.equalTo(21)
            $0.width.equalTo(287)
        }

//        courseLabel.snp.makeConstraints {
//            $0.bottom.equalTo(-16)
//            $0.left.equalTo(timeLabel.snp.left)
//        }

//        meditationTagView.snp.makeConstraints {
//            $0.top.equalTo(8)
//            $0.right.equalTo(-8)
//            $0.height.equalTo(24)
//            $0.width.equalTo(95)
//        }
        
        sampleLabel.snp.makeConstraints {
            $0.bottom.equalTo(-16)
            $0.left.equalTo(timeLabel.snp.left)
        }
    }
}
