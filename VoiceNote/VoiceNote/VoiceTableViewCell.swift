//
//  VoiceTableViewCell.swift
//  VoiceNote
//
//  Created by HideOnBush on 2017/8/4.
//  Copyright © 2017年 HideOnBush. All rights reserved.
//

import UIKit

class VoiceTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    //MARK: - 添加控件
    private func setUpUI() {
        voiceNameLable.frame = CGRect(x: 0, y: 10, width: 200, height: 80)
        voiceTimeLable.frame = CGRect(x: self.frame.size.width - 60, y: 20, width: 60, height: 60)
        addSubview(voiceNameLable)
        addSubview(voiceTimeLable)
    }
    
    //MARK: - 控件
    lazy var voiceNameLable: UILabel = {
        let lable = UILabel()
        lable.text = "name"
        lable.textColor = .orange
        lable.font = UIFont.systemFont(ofSize: 25)
        lable.adjustsFontSizeToFitWidth = true
        return lable
    }()
    
    
    lazy var voiceTimeLable: UILabel = {
        let lable = UILabel()
        lable.text = "10"
        lable.adjustsFontSizeToFitWidth = true
        lable.textAlignment = .center
        lable.textColor = .black
        lable.backgroundColor = UIColor(displayP3Red: 97/255, green: 211/255, blue: 158/255, alpha: 1.0)
        lable.layer.masksToBounds = true
        lable.layer.cornerRadius = 30
        lable.layer.borderWidth = 1
        return lable
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
