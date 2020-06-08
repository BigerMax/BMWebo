//
//  BMLayout.swift
//  BMWebo
//
//  Created by top-more on 2020/4/29.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit

struct BMLayout {
    static let ratio:CGFloat = UIScreen.main.bounds.width / 375.0
    static func Layout(_ number : CGFloat) -> CGFloat {
        return number * ratio
    }
}
