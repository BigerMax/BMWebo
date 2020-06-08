//
//  BMBaseViewController.swift
//  BMWebo
//
//  Created by top-more on 2020/4/29.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit

class BMBaseViewController: UIViewController {

    lazy var navigationBar = BMNavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.bm_screenW, height: BM_naviBarHeight))
    
    lazy var naviItem = UINavigationItem()
    var tableview : UITableView?
    var refreshControl : BMRefreshControl?
    var isPull : Bool = false
    var visitorInfo: [String : String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        BMNetworkManager.shared.isLogin ? loadDatas() : ()
        registNotification()
        refreshControl?.beginRefreshing()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var title : String? {
        didSet{
            naviItem.title = title
        }
    }
    
    @objc func loadDatas() {
        refreshControl?.endRefreshing()
    }
    
    func registNotification() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(BMUserLoginSuccessNotification), object: nil, queue: OperationQueue.main){ [weak self]_ in
            guard let weakSelf = self else{
                return
            }
            weakSelf.naviItem.leftBarButtonItem = nil
            weakSelf.naviItem.rightBarButtonItem = nil
            
            //reload view
            weakSelf.setupUI()
            weakSelf.loadDatas()
            
        }
    }
}

extension BMBaseViewController:LoginDelegate{
    private func setupUI() {
        view.backgroundColor = .white
        setupNavigationBar()
        
        BMNetworkManager.shared.isLogin ? setupLoginSuccessUI() : setupVisitorView()
        
        //取消自动缩进
        tableview?.contentInsetAdjustmentBehavior = .never
        refreshControl = BMRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadDatas), for: .valueChanged)
        tableview?.addSubview(refreshControl!)
    }
    
    private func setupNavigationBar(){
        view.addSubview(navigationBar)
        navigationBar.items = [naviItem]
        navigationBar.barTintColor = UIColor.init(rgb: 0xF6F6F6)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.darkGray]
        navigationBar.backgroundColor = UIColor.init(rgb: 0xF6F6F6)
    }
    
    @objc func clickLogin() {
        NotificationCenter.default.post(name: Notification.Name(BMUserShouldLoginNotification), object: nil)
    }
    
    @objc func clickRegister() {
         print("clickRegister")
    }
    
    func setupLoginSuccessUI() {
        setupTableView()
        setupNaviTitle()
    }
    
    private func setupVisitorView() {
        let visitorView = BMVisitorView(frame: view.bounds)
        visitorView.visitorInfo = visitorInfo
        visitorView.delegate = self
        view.insertSubview(visitorView, belowSubview: navigationBar)
        
        naviItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(clickRegister))
        naviItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(clickLogin))
    }
    
    @objc func setupTableView(){
        tableview = UITableView(frame: view.bounds, style: .plain)
        view.insertSubview(tableview!, belowSubview: navigationBar)
        
        tableview?.delegate = self
        tableview?.dataSource = self
        
        let toolHeight:CGFloat = BM_naviBarHeight
        let tabBarHeight:CGFloat = BM_bottomTabBarHeight
        tableview?.contentInset = UIEdgeInsets(top: toolHeight, left: 0, bottom: tabBarHeight, right: 0)
        tableview?.scrollIndicatorInsets = tableview!.contentInset
    }
    @objc func setupNaviTitle(){
    }
    
    @objc func clickTitleButton(button: UIButton){
        button.isSelected = !button.isSelected
    }
}

extension BMBaseViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = tableView.numberOfSections - 1
        
        if row < 0 || section < 0 {
            return
        }
        
        let count = tableView.numberOfRows(inSection: section)
        if row == (count - 1) && !isPull {
            print("上拉刷新")
            isPull = true
            
            loadDatas()
            
        }
    }
}
