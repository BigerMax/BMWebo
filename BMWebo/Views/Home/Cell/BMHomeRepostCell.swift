//
//  BMHomeRepostCell.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/6/7.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit

class BMHomeRepostCell: BMHomeBaseCell {

    override var viewModel: BMStatusViewModel?{
        didSet{
            repostLabel.attributedText = viewModel?.repostAttrText
        }
    }
    
    override func setupSubViews() {
        super.setupSubViews()
        
        let repostButton = UIButton()
        repostButton.backgroundColor = UIColor.init(rgb: 0xf7f7f7)
        addSubview(repostButton)
        repostButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(contentLabel.snp.bottom).offset(BMDefaultMargin)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        repostLabel.numberOfLines = 0
        repostLabel.textAlignment = .left
        repostLabel.font = UIFont.systemFont(ofSize: BMLayout.Layout(14))
        repostLabel.textColor = UIColor.darkGray
        repostLabel.text = "repostLabel"
        repostButton.addSubview(repostLabel)
        repostLabel.snp.makeConstraints { (make) in
            make.left.equalTo(BMDefaultMargin)
            make.top.equalToSuperview().offset(BMDefaultMargin)
            make.right.equalToSuperview().offset(-BMLayout.Layout(BMStatusPictureOutterMargin))
        }
        
        contentPictureView = BMStatusPictureView(parentView: repostButton,
                                                 topView: repostLabel,
                                                 bottomView: nil)
    }

}
