//
//  BMHomeBaseCell.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/5/28.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol BMHomeCellDelegate{
    @objc optional func homeCellDidClickUrlString(cell: BMHomeBaseCell, urlStr: String)
}

class BMHomeBaseCell: UITableViewCell {

    var avatarImage = UIImageView()
    var nameLabel = UILabel()
    var levelIconView = UIImageView(image: UIImage(named: "common_icon_membership"))
    var timeLabel = UILabel()
    var sourceLabel = UILabel()
    var vipIconView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    var contentLabel = BMLabel()
    var repostLabel = BMLabel()
    
    var bottomView:BMStatusToolView = BMStatusToolView(parentView: nil)
    
    var contentPictureView = BMStatusPictureView(parentView: nil, topView: nil, bottomView: nil)
    
    weak var delegate:BMHomeCellDelegate?
    
    var viewModel: BMStatusViewModel?{
        didSet{
            contentLabel.attributedText = viewModel?.statusAttrText
            nameLabel.text = viewModel?.status.user?.screen_name
            //提前计算好
            levelIconView.image = viewModel?.levelIcon
            vipIconView.image = viewModel?.vipIcon
            avatarImage.bm_setImage(urlString: viewModel?.status.user?.profile_image_url, placeholderImage: UIImage(named: "avatar_default_big"), isAvatar: true)
            bottomView.viewModel = viewModel
            contentPictureView.viewModel = viewModel
            
            sourceLabel.text = viewModel?.status.source
            //FIXME: 新浪API现在没有返回创建时间了,暂时用一个固定字符串代替
            //timeLabel.text = viewModel?.status.createDate?.bm_dateDescription
            timeLabel.text = "刚刚"
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
        //异步检测
        self.layer.drawsAsynchronously = true
        //栅格化 - 绘制之后生产独立的图像，停止滑动可以交互
        self.layer.shouldRasterize = true
        //指定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
        
        contentLabel.delegate = self
        repostLabel.delegate = self
        
    }
    
    func setupSubViews(){
        let topLineView = UIView()
        topLineView.backgroundColor = UIColor.init(rgb: 0xf2f2f2)
        addSubview(topLineView)
        topLineView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(BMLayout.Layout(BMStatusPictureOutterMargin))
        }
        
        addSubview(avatarImage)
        avatarImage.snp.makeConstraints { (make) in
            make.left.equalTo(BMLayout.Layout(BMStatusPictureOutterMargin))
            make.top.equalTo(topLineView.snp.bottom).offset(BMLayout.Layout(BMStatusPictureOutterMargin))
            make.size.equalTo(homeCellAvatarHeight)
        }
        
        nameLabel.textColor =  UIColor.init(rgb: 0xfc3e00)
        nameLabel.font = UIFont.systemFont(ofSize: BMLayout.Layout(13.5))
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImage.snp.top).offset(BMLayout.Layout(3))
            make.left.equalTo(avatarImage.snp.right).offset(BMLayout.Layout(BMStatusPictureOutterMargin))
        }
        
        addSubview(levelIconView)
        levelIconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(BMLayout.Layout(3))
            make.size.equalTo(BMLayout.Layout(14))
        }
        
        addSubview(timeLabel)
        timeLabel.textColor = UIColor.init(rgb: 0xfc6c00)
        timeLabel.font = UIFont.systemFont(ofSize: BMLayout.Layout(10))
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.bottom.equalTo(avatarImage.snp.bottom)
        }
        
        addSubview(sourceLabel)
        sourceLabel.textColor = UIColor.init(rgb: 0x828282)
        sourceLabel.font = UIFont.systemFont(ofSize: BMLayout.Layout(10))
        sourceLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeLabel)
            make.left.equalTo(timeLabel.snp.right).offset(BMLayout.Layout(8))
        }
        
        addSubview(vipIconView)
        vipIconView.snp.makeConstraints { (make) in
            make.size.equalTo(BMLayout.Layout(14))
            make.centerX.equalTo(avatarImage.snp.right).offset(-BMLayout.Layout(4))
            make.centerY.equalTo(avatarImage.snp.bottom).offset(-BMLayout.Layout(4))
        }
        
        bottomView = BMStatusToolView(parentView: self)
        
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        contentLabel.font = UIFont.systemFont(ofSize: BMLayout.Layout(15))
        contentLabel.textColor = UIColor.darkGray
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImage)
            make.top.equalTo(avatarImage.snp.bottom).offset(BMLayout.Layout(BMStatusPictureOutterMargin))
            make.right.equalToSuperview().offset(-BMLayout.Layout(BMStatusPictureOutterMargin))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension BMHomeBaseCell : BMLabelDelegate {
    func labelDidSelectedLinkText(label: BMLabel, text: String) {
        if !text.hasPrefix("http"){
            return
        }
        delegate?.homeCellDidClickUrlString?(cell: self, urlStr: text)
    }
}
