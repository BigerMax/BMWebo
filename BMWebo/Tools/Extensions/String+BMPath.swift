//
//  String+BMPath.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/5/7.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import Foundation

extension String{
    func bm_appendDocumentDir() -> String?{
        guard let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return nil }
        let path = "/userInfo.json"
        return dir + path
    }
    

}
