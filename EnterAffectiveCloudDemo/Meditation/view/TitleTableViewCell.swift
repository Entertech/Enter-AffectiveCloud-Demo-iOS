//
//  TitleTableViewCell.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/14.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    var titleLabel:UILabel?
    var switchKit: UISwitch?
    public var showSwitch = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel()
        self.contentView.addSubview(titleLabel!)
        
        if showSwitch {
            switchKit = UISwitch()
            self.contentView.addSubview(switchKit!)
        }
        
        
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.separatorInset = .init(top: 0, left: 0, bottom: 0, right: self.bounds.width)
        setupViews()
    }
    
    func setupViews(){
        self.titleLabel?.snp.makeConstraints{
            $0.left.equalTo(self).offset(16)
            $0.centerY.equalToSuperview()
        }
        self.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        if showSwitch {
            self.switchKit?.snp.makeConstraints{
                $0.right.equalTo(self).offset(-16)
                $0.centerY.equalToSuperview()
            }
        }
        
    }

}
