//
//  String+SubString.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/6/8.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import Foundation

extension String{
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func subString(from: Int) -> String{
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    func subString(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func subString(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}
