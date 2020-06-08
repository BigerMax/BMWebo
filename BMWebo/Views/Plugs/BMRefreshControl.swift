//
//  BMRefreshControl.swift
//  BMWebo
//
//  Created by top-more on 2020/4/29.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit

private let BMRefreshOffsetY:CGFloat = 60

enum BMRefreshState {
    case normal
    case pulling
    case refreshing
}

class BMRefreshControl: UIControl {

    
    let BMRefreshControlKey = "contentOffset"
    
    lazy var refreshView = BMRefreshView.refreshView()
    private weak var scrollView : UIScrollView?
    
    init() {
        super.init(frame: CGRect())
        self.backgroundColor = superview?.backgroundColor
        setupUI()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let superView = newSuperview as? UIScrollView else {
            print("newSuperview is nil")
            return
        }
        scrollView = superView
        scrollView?.addObserver(self, forKeyPath: BMRefreshControlKey, options: [], context: nil)
        
    }
    
    override func removeFromSuperview() {
        superview?.removeObserver(self, forKeyPath: BMRefreshControlKey)
        super.removeFromSuperview()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollView = scrollView else {
            print("scrollView is nil")
            return
        }
        
        let height = -(scrollView.contentInset.top + scrollView.contentOffset.y)
        if height < 0 {
            return
        }
        self.frame = CGRect(x: 0, y: -height, width: scrollView.bounds.width, height: height)
        if refreshView.refreshState != .refreshing{
            refreshView.parentViewHeight = height
        }
        
        //判断临界点
        if scrollView.isDragging{
            if height > BMRefreshOffsetY && (refreshView.refreshState == .normal){
                refreshView.refreshState = .pulling
            }else if height <= BMRefreshOffsetY && (refreshView.refreshState == .pulling){
                refreshView.refreshState = .normal
            }
        }else{
            if refreshView.refreshState == .pulling{
                beginRefreshing()
                sendActions(for: .valueChanged)
            }
        }
    }
    
    func beginRefreshing() {
        guard let scrollView = scrollView else { return  }
        if refreshView.refreshState == .refreshing{
            return
        }
        refreshView.refreshState = .refreshing
        var inset = scrollView.contentInset
        inset.top += BMRefreshOffsetY
        scrollView.contentInset = inset
        refreshView.parentViewHeight = BMRefreshOffsetY
    }
    
    func endRefreshing() {
        if refreshView.refreshState != .refreshing{
            return
        }
        guard let scrollView = scrollView else { return  }
        refreshView.refreshState = .normal
        var inset = scrollView.contentInset
        inset.top -= BMRefreshOffsetY
        scrollView.contentInset = inset
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension BMRefreshControl{
    private func setupUI() {
        addSubview(refreshView)
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1,
                                         constant: 0))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1,
                                         constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint(item: refreshView,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1,
                                         constant: refreshView.bounds.height))
    }
}
