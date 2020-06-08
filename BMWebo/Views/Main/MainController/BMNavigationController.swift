//
//  BMNavigationController.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/5/14.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit

class BMNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            
            if let vc = viewController as? BMBaseViewController{
                var title = "返回"
                if children.count == 1 {
                    title = children.first?.title ?? "返回"
                }
                
                vc.naviItem.leftBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(popViewController(animated:)))
            }
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc func popToParent() {
        popViewController(animated: true)
    }
}
