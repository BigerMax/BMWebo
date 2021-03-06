//
//  String+Extension.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/5/24.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import Foundation

extension String{
    
    func bm_href() -> (link:String, text:String)?{
        //创建正则表达式，匹配
        let pattern = "<a href=\"(.*?)\".*?\">(.*?)</a>"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
            let result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count))
        else { return nil }
        
        let link = (self as NSString).substring(with: result.range(at: 1))
        let text = (self as NSString).substring(with: result.range(at: 2))
        return(link, text)
    }
}
