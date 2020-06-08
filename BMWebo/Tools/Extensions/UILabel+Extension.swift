//
//  UILabel+Extension.swift
//  BMWebo
//
//  Created by top-more on 2020/5/13.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
    class func bm_label(text: String, fontSize: CGFloat, color: UIColor) -> UILabel {
        let label = self.init()
        label.text = text
        label.font = UIFont.systemFont(ofSize: BMLayout.Layout(fontSize))
        label.textColor = color
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }
}
