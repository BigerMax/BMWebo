//
//  BMWelcomeView.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/6/8.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit

class BMWelcomeView: UIView {

    lazy var avatarImageView = UIImageView(image: UIImage(named: "avatar_default_big"))
    lazy var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.orange
        setupSubViews()
        updateAvatar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        let backgroundImageView = UIImageView(image: UIImage(named: "ad_background"))
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
        let avatarImageViewH = BMLayout.Layout(85)
        avatarImageView.layer.cornerRadius = avatarImageViewH * 0.5
        avatarImageView.layer.masksToBounds = true
        backgroundImageView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.size.equalTo(avatarImageViewH)
            $0.bottom.equalTo(-BMLayout.Layout(160))
        }
        
        label.text = "欢迎归来"
        label.alpha = 0
        backgroundImageView.addSubview(label)
        label.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(avatarImageView.snp.bottom).offset(BMLayout.Layout(15))
        }
    }
    
    private func updateAvatar() {
        guard let urlString = BMNetworkManager.shared.userAccount.avatar_large,
        let url = URL(string: urlString) else { return  }
        
        avatarImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar_default_big"))
    }
    
    //表示视图已经显示
    override func didMoveToWindow() {
        super.didMoveToWindow()
        //按照挡墙约束 - 更新空间位置
        self.layoutIfNeeded()
        self.avatarImageView.snp.updateConstraints { (make) in
            make.bottom.equalTo(-BMLayout.Layout(360))
        }
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6,initialSpringVelocity: 0, options: [], animations:  {
            self.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 1, animations: {
                self.label.alpha = 1
            }) { (_) in
                self.removeFromSuperview()
            }
        }
    }

}
