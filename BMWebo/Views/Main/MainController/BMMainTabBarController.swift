//
//  BMMainTabBarController.swift
//  BMWebo
//
//  Created by top-more on 2020/4/29.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit

class BMMainTabBarController: UITabBarController {

    private var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        setupChildrenControlers()
        setupCenterButton()
        setupTimer()
        //新特性
        setupNewFeatureViews()
        UITabBar.appearance().tintColor = UIColor.orange
        delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin(noti:)), name: NSNotification.Name(BMUserShouldLoginNotification), object: nil)
    }
    
    @objc func userLogin(noti: Notification) {
        var when = DispatchTime.now()
        
        if noti.object != nil {
            print("用户登录超时,请重新登录")
            when = DispatchTime.now() + 2
        }
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            let navi = UINavigationController(rootViewController: BMOAuthViewController())
            self.present(navi, animated: true, completion: nil)
        }
    }
    
    deinit {
        timer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    private lazy var tabBarCenterButton: UIButton = UIButton.bm_imageButton(normalImageName: "tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
    
    
    //center click action
    //@objc: 可以用OC的消息机制调用
    @objc private func centerBtnClick() {
        //发布微博
        let view = BMPublishView()
        view.show(rootVC: self) { [weak view] (clsName) in
            guard let clsName = clsName,
                let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? UIViewController.Type
                else{
                    view?.removeFromSuperview()
                    return
            }

            let vc = cls.init()
            //让vc在ViewDidLoad之前刷新 - 解决动画&约束混在一起的问题
            let navi = UINavigationController(rootViewController: vc)
            navi.view.layoutIfNeeded()
            self.present(navi, animated: true) {
                view?.removeFromSuperview()
            }
        }
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }

}

extension BMMainTabBarController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = children.firstIndex(of: viewController)
        
        //在首页点击“首页”tabbar，滚动到顶部
        if selectedIndex == 0 && index == 0 {
            let navi = children[0] as! UINavigationController
            let vc = navi.children[0] as! BMBaseViewController
            
            //scroll to top
            vc.tableview?.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            
            //滚动完刷新
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                vc.loadDatas()
            }
            
            vc.tabBarItem.badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        return !viewController.isMember(of: UIViewController.self)
    }
}

extension BMMainTabBarController{
    private func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(updateTimer), userInfo: nil,repeats: true)
    }
    
    @objc func updateTimer(){
        if !BMNetworkManager.shared.isLogin{
            return
        }
        
        BMNetworkManager.shared.unreadCount { (count) in
            //设置首页的page
            self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
            //set app badgeValue
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
    
    private func setupCenterButton() {
        tabBar.addSubview(tabBarCenterButton)
        let count = CGFloat(viewControllers?.count ?? 0)
        let width = tabBar.bounds.width / count
        let leftItemCount:CGFloat = 2
        tabBarCenterButton.frame = tabBar.bounds.insetBy(dx: leftItemCount * width, dy: 0)
        tabBarCenterButton.addTarget(self, action: #selector(centerBtnClick), for: .touchUpInside)
    }
    
    private func setupChildrenControlers() {
        let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (documentDir as NSString).appendingPathComponent("main.json")
        var data = NSData(contentsOfFile: jsonPath)
        
        if data == nil {
            let path = Bundle.main.path(forResource: "main.json", ofType: nil)
            data = NSData(contentsOfFile: path!)
        }
        
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String:AnyObject]]
            else {
                print("main.json don't exist.")
                return
                
        }
        
        var arrayM = [UIViewController]()
        for dic in array {
            arrayM.append(controller(dic: dic))
        }
        viewControllers = arrayM
    }
    
    private func controller(dic: [String:Any]) -> UIViewController {
        guard let clsName = dic["clsName"] as? String,
        let title = dic["title"] as? String,
        let imageName = dic["imageName"] as? String,
        let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? BMBaseViewController.Type,
        let visitorDic = dic["visitorInfo"] as? [String: String]
        else {
                return UIViewController()
        }
        
        let vc = cls.init()
        vc.title = title
        vc.visitorInfo = visitorDic
        
        let normalImage = "tabbar_" + imageName
        let selectedImage = "tabbar_" + imageName + "_selected"
        vc.tabBarItem.image = UIImage(named: normalImage)
        vc.tabBarItem.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal)
        
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.orange,
            NSAttributedString.Key.backgroundColor : UIColor.orange,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)
        ]
        
        vc.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        
        let attributes2 = [
            NSAttributedString.Key.foregroundColor : UIColor.orange,
            NSAttributedString.Key.backgroundColor : UIColor.orange,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)
        ]
        vc.tabBarItem.setTitleTextAttributes(attributes2, for: .selected)
        
        let navi = BMNavigationController(rootViewController: vc)
        return navi
    }
    
    private func setupNewFeatureViews() {
        if !BMNetworkManager.shared.isLogin{
            return
        }
        
        let tempView = isNewVersion ? BMNewFeatureView() : BMWelcomeView()
        tempView.frame = view.bounds
        view.addSubview(tempView)
    }
    
    private var isNewVersion: Bool{
        let saveVersionKey = "version"
        let defaults = UserDefaults.standard
        let currentVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let saveVersion:String = defaults.value(forKey: saveVersionKey) as? String ?? ""
        
        defaults.set(currentVersion, forKey: saveVersionKey)
        
        return currentVersion != saveVersion
    }
}
