//
//  BMStatusToolView.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/5/28.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit

class BMStatusToolView: UIView {

    lazy var repostButton = UIButton()
    lazy var commentButton = UIButton()
    lazy var likeButton = UIButton()
    
    var viewModel: BMStatusViewModel?{
        didSet{
            repostButton.setTitle(viewModel?.repostTile, for: .normal)
            commentButton.setTitle(viewModel?.commentTitle, for: .normal)
            likeButton.setTitle(viewModel?.likeTitle, for: .normal)
        }
    }
    
    init(parentView: UIView?) {
        super.init(frame: CGRect())
        if parentView == nil {
            return
        }
        
        parentView?.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(BMLayout.Layout(35))
        }
        
        let bottomToolView = UIStackView()
        self.addSubview(bottomToolView)
        bottomToolView.translatesAutoresizingMaskIntoConstraints = false
        bottomToolView.alignment = .fill
        bottomToolView.distribution = .fillEqually
        bottomToolView.spacing = 0
        bottomToolView.axis = .horizontal
        NSLayoutConstraint.activate([
            bottomToolView.leftAnchor.constraint(equalTo: self.leftAnchor),
            bottomToolView.rightAnchor.constraint(equalTo: self.rightAnchor),
            bottomToolView.topAnchor.constraint(equalTo: self.topAnchor),
            bottomToolView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        repostButton.bm_toolButton(type: .repost)
        bottomToolView.addArrangedSubview(repostButton)
        
        commentButton.bm_toolButton(type: .comments)
        bottomToolView.addArrangedSubview(commentButton)
        
        likeButton.bm_toolButton(type: .like)
        bottomToolView.addArrangedSubview(likeButton)
        
        //line
        let line = UIView()
        line.backgroundColor = UIColor.init(rgb: 0xf2f2f2)
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(BMDefaultMargin)
            make.right.equalTo(-BMDefaultMargin)
            make.top.equalToSuperview()
            make.height.equalTo(BMLayout.Layout(1))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
