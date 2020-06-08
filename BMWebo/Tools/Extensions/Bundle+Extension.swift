//
//  Bundle+Extension.swift
//  BMWebo
//
//  Created by top-more on 2020/4/29.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit

extension Bundle {
    var namespace : String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
