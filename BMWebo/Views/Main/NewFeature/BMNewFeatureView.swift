//
//  BMNewFeatureView.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/6/8.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit

class BMNewFeatureView: UIView {

    private lazy var scrollView = UIScrollView()
    private lazy var enterHomeButton = UIButton()
    private lazy var pageControl = UIPageControl()
    private let pageCount = 4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubViews()
        updateSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(0)
        }
        
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        pageControl.pageIndicatorTintColor = UIColor.darkGray
        pageControl.numberOfPages = pageCount
        pageControl.isUserInteractionEnabled = false
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-BMLayout.Layout(80))
        }
        enterHomeButton.isHidden = true
        enterHomeButton.setBackgroundImage(UIImage(named: "new_feature_finish_button"), for: .normal)
        enterHomeButton.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), for: .highlighted)
        enterHomeButton.addTarget(self, action: #selector(clickEnterButton), for: .touchUpInside)
        enterHomeButton.setTitle("进入微博", for: .normal)
        addSubview(enterHomeButton)
        enterHomeButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.top).offset(-BMLayout.Layout(40))
            make.width.equalTo(BMLayout.Layout(105))
            make.height.equalTo(BMLayout.Layout(36))
        }
    }
    
    private func updateSubViews(){
        for i in 0..<pageCount{
            let imageName = "new_feature_\(i + 1)"
            let imageView = UIImageView(image: UIImage(named: imageName))
            let x = UIScreen.bm_screenW * CGFloat(i)
            imageView.frame = CGRect(x: x, y: 0, width: UIScreen.bm_screenW, height: UIScreen.bm_screenH)
            scrollView.addSubview(imageView)
        }
        
        let contentSizeW = UIScreen.bm_screenW * CGFloat(pageCount + 1)
        scrollView.contentSize = CGSize(width: contentSizeW, height: UIScreen.bm_screenH)
        scrollView.delegate = self
    }
}

extension BMNewFeatureView : UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //最后一个屏幕,视图消失
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        pageControl.currentPage = page
        pageControl.isHidden = (page == scrollView.subviews.count)
    }
    
    @objc func clickEnterButton() {
        removeFromSuperview()
    }
}
