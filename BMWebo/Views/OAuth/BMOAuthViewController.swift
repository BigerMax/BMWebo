//
//  BMOAuthViewController.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/6/8.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class BMOAuthViewController: UIViewController,WKNavigationDelegate {

    
    private lazy var webView = WKWebView()
    
    override func loadView() {
        super.viewDidLoad()
        self.view = webView
        view.backgroundColor = UIColor.white
        
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
        title = "登录微博"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(closeWebView), isBackItem: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoInput))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUrl()
    }
    
    private func loadUrl() {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(BMAppKey)&redirect_uri=\(BMredirectUri)"
        guard let url = URL(string: urlString) else {
            print("url = nil")
            return
            
        }
        let request = URLRequest(url: url)
        webView.load(request as URLRequest)
    }
    
    @objc func closeWebView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func autoInput() {
        //动态注入js
        let account = ""
        let password = ""
        let js =  "document.getElementById('userId').value = '\(account)';" + "document.getElementById('passwd').value = '\(password)';"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    
    // MARK: WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("url ====> \(String(describing: webView.url?.absoluteString ))")
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        if webView.url?.absoluteString.hasPrefix(BMredirectUri) == false {
            print("请求 url =======> \(String(describing: webView.url?.absoluteString))")
            return
        }
        
        //get url query ==> 查询字符串 （？后面的内容）
        if webView.url?.query?.hasPrefix("code==") == false {
            print("取消授权")
            closeWebView()
            return
        }
        
        print("授权授权码")
        let code = webView.url?.query?.subString(from: "code=".count) ?? ""
        print("code = \(String(describing: code))")
        BMNetworkManager.shared.getAccessToken(code: code) { (isSuccess) in
            if isSuccess{
                print("login success")
                
                NotificationCenter.default.post(name: NSNotification.Name(BMUserLoginSuccessNotification), object: nil)
                self.closeWebView()
            }else{
                print("login failure")
            }
        }
    }
}
