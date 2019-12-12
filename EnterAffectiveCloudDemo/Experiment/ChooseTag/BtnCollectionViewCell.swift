//
//  BtnCollectionViewCell.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/12/10.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloud

class BtnCollectionViewCell: UICollectionViewCell {
    
    
    
    var btn = UILabel()
    
    func setSelect() {
        btn.textColor = .white
        btn.backgroundColor = UIColor.hexStringToUIColor(hex: "4B5DCC")
        btn.layer.borderColor = UIColor.clear.cgColor
    }
    
    func setNormal() {
        btn.textColor = .black
        btn.backgroundColor = .white
        btn.layer.borderColor = UIColor.black.cgColor
    }
    
    func setModel(dim: DimModel) {
        self.contentView.addSubview(btn)
        btn.text = dim.name_cn!
        btn.textAlignment = .center
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 14
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.black.cgColor
        btn.textColor = .black
        btn.tag = dim.id!
        btn.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let att = super.preferredLayoutAttributesFitting(layoutAttributes);
        
        let string:NSString = btn.text! as NSString
        
        var newFram = string.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: btn.bounds.size.height), options: .usesLineFragmentOrigin, attributes: [
            NSAttributedString.Key.font : btn.font
            ], context: nil)
        newFram.size.height += 10;
        newFram.size.width += 30;
        att.frame = newFram;

        
        return att;
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
