//
//  UIBarButtonItem+Extension.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/6/8.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(title: String, fontSize: CGFloat = 16, target: AnyObject?, action: Selector, isBackItem: Bool = false) {
        let btn: UIButton = UIButton.bm_textButton(title: title, fontSize: fontSize, normalColor: UIColor.darkGray, highlightedColor: UIColor.orange)
        
        if isBackItem{
            let imageName = "navigationbar_back_withtext"
            btn.setImage(UIImage(named: imageName), for: .normal)
            btn.setImage(UIImage(named: imageName + "_highlight"), for: .highlighted)
            btn.sizeToFit()
        }
        
        btn.addTarget(target, action: action, for: .touchUpInside)
        self.init(customView: btn)
    }
}
