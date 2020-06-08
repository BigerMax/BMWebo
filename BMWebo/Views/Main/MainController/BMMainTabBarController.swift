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
    }
    
    func setupChildrenControlers() {
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
