//
//  BMWebViewController.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/6/8.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit
import WebKit

class BMWebViewController: BMBaseViewController {

    private lazy var webView = WKWebView(frame: UIScreen.main.bounds)
    
    var urlString: String? {
        didSet{
            guard let urlString = urlString,
            let url = URL(string: urlString) else { return  }
            webView.load(URLRequest(url: url))
        }
        
    }
    
    override func setupTableView() {
        self.title = "网页"
        webView.scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        view.insertSubview(webView, belowSubview: navigationBar)
        webView.scrollView.contentInset.top = BM_naviBarHeight
        webView.backgroundColor = UIColor.white
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
    }
    
}
