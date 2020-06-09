//
//  BMCompostTypeButton.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/6/8.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit

class BMCompostTypeButton: UIButton {
    let buttonWH = BMLayout.Layout(100)
    var clsName: String?
    
    init(imageName: String, title: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: buttonWH, height: buttonWH))
        setupUI(imageName: imageName, title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(imageName: String, title: String){
        let imageView = UIImageView(image: UIImage(named: imageName))
        addSubview(imageView)
        imageView.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(BMLayout.Layout(71))
        })
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = UIColor.darkGray
        titleLabel.font = UIFont.systemFont(ofSize: BMLayout.Layout(13))
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.centerX.equalToSuperview()
        }
    }

}
