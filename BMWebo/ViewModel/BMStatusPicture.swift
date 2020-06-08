//
//  BMStatusPicture.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/5/23.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit

class BMStatusPicture: NSObject {

    ///原图
    @objc var largePic:String?
    
    ///缩略图
    @objc var thumbnail_pic:String?{
        didSet{
            //处理缩略图地址
            thumbnail_pic = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/wap360/")
            //原图
            largePic = thumbnail_pic?.replacingOccurrences(of: "/wap360/", with: "/large/")
        }
    }
    
    override var description: String{
        return self.yy_modelDescription()
    }
}
