//
//  BMStatusPictureView.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/5/28.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit

class BMStatusPictureView: UIView {

    var urls: [BMStatusPicture]?{
        didSet{
            //hidden imageview
            subviews.forEach { $0.isHidden = true}
            
            guard let urls = urls else {
                print("BMStatusPictureView - urls is empty.")
                return
            }
            
            var index = 0
            for url in urls{
                let iv:UIImageView = subviews[index] as! UIImageView
                
                //特殊处理4张图片的情况
                if index == 1 && urls.count == 4{
                    index += 1
                }
                
                iv.bm_setImage(urlString: url.thumbnail_pic, placeholderImage: nil)
                iv.isHidden = false
                index += 1
                
                //处理gif图片
                guard let gifImageView = iv.subviews.first else {
                    return
                }
                
                let isGif = (url.thumbnail_pic as NSString?)?.pathExtension == "gif"
                gifImageView.isHidden = !isGif
            }
        }
    }
    
    var viewModel: BMStatusViewModel?{
        didSet{
            urls = viewModel?.picUrls
            //包含原创&被转发
            calculateViewSize()
        }
    }
    
    //图片点按手势
    @objc func tapImageView(tap:UITapGestureRecognizer){
        guard let imageView = tap.view,
            let picUrls = viewModel?.picUrls else { return }
        var selectedIndex = imageView.tag
        //四张图片 - 特殊处理index
        if picUrls.count == 4 && selectedIndex > 1{
            selectedIndex -= 1
        }
        let urls = ((picUrls as NSArray).value(forKey: "largePic") as? [String]) ?? []
        var imageViews = [UIImageView]()
        for view in subviews as! [UIImageView]{
            if !view.isHidden {
                imageViews.append(view)
            }
        }
        
        //使用通知 - 跨层通信
        let userInfo:[String:Any] = [BMWeiboCellBrowserPhotoURLsKeys:urls,
                                     BMWeiboCellBrowserPhotoIndexKey:selectedIndex,
                                     BMWeiboCellBrowserPhotoImageViewsKeys:imageViews]
        NotificationCenter.default.post(
        name: Notification.Name(BMWeiboCellBrowserPhotoNotification),
        object: nil,
        userInfo: userInfo)
    }
    
    
    init(parentView: UIView?, topView: UIView?, bottomView: UIView?) {
        super.init(frame: CGRect())
        self.backgroundColor = superview?.backgroundColor
        
        let margin = BMLayout.Layout(12)
        guard let parentView = parentView, let topView = topView else { return  }
        
        parentView.addSubview(self)
        
        if bottomView == nil{
            self.snp.makeConstraints { (make) in
                make.left.equalTo(margin)
                make.right.equalTo(-margin)
                make.top.equalTo(topView.snp.bottom)
                make.bottom.lessThanOrEqualToSuperview()
                make.height.equalTo(BMLayout.Layout(200))
            }
        }else{
            self.snp.makeConstraints { (make) in
                make.left.equalTo(margin)
                make.right.equalTo(-margin)
                make.top.equalTo(topView.snp.bottom)
                make.bottom.lessThanOrEqualTo(bottomView!.snp.top).offset(-margin)
                make.height.equalTo(BMLayout.Layout(200))
            }
        }
        
        setupPictures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BMStatusPictureView{
    private func calculateViewSize() {
        let size = viewModel?.pictureViewSize ?? CGSize()
        //handle width
        if viewModel?.picUrls?.count == 1 {
            //单图：动态缩放
            let view = subviews[0]
            //图片大小 = cell大小 - 间隔
            let height = size.height - BMStatusPictureOutterMargin
            view.frame = CGRect(x: 0, y: BMStatusPictureOutterMargin, width: size.width, height: height)
        }else{
            //多图，正常尺寸
            let view = subviews[0]
            view.frame = CGRect(x: 0,
                                y: BMStatusPictureOutterMargin,
                                width: BMPictureItemWidth,
                                height: BMPictureItemWidth)
        }
        
        //handle height
        self.snp.updateConstraints { (make) in
            make.height.equalTo(viewModel?.pictureViewSize.height ?? 0)
        }
    }
    
    private func setupPictures() {
        clipsToBounds = true
        let maxCount = 9
        
        for i in 0..<maxCount{
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            iv.image = UIImage(named: "timeline_icon_ip")
            let row = CGFloat(i / Int(BMPictureMaxPerLine))
            let colum = CGFloat(i % Int(BMPictureMaxPerLine))
            let x = colum * (BMPictureItemWidth + BMStatusPictureInnerMargin)
            let y = BMStatusPictureOutterMargin + row * (BMPictureItemWidth + BMStatusPictureInnerMargin)
            iv.frame = CGRect(x: x, y: y, width: BMPictureItemWidth, height: BMPictureItemWidth)
            addSubview(iv)
            
            //点击事件
            iv.isUserInteractionEnabled = true
            iv.tag = i
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapImageView(tap:)))
            iv.addGestureRecognizer(tap)
            imageViewAddGif(parentView: iv)
        }
    }
    
    private func imageViewAddGif(parentView: UIImageView){
        let gifImageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
        gifImageView.isHidden = true
        gifImageView.addSubview(gifImageView)
        gifImageView.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
        }
    }
}
