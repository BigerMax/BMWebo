//
//  BMStatusModel.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/5/14.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit
import YYModel

class BMStatusModel : NSObject {
    @objc var id: Int64 = 0
    @objc var text: String?
    @objc var user: BMUserModel?
    
    @objc var reposts_count = 0
    @objc var comments_count = 0
    //点赞数
    @objc var attitudes_count = 0
    @objc var pic_urls: [BMStatusPicture]?
    
    //现在新浪的api接口没有创建日期了
    @objc var creatDate: Date?
    
    @objc var create_at: String?{
        didSet{
            creatDate = Date.bm_sinaDate(string: create_at)
        }
    }
    
    @objc var source: String?{
        
        didSet{
            source = "来自" + (source?.bm_href()?.text ?? "")
        }
    }
    
    //被转发微博
    @objc var retweeted_status:BMStatusModel?
    
    override var description: String{
        return yy_modelDescription()
    }
    
    @objc class func modelContainerPropertyGenericClass() -> [String:AnyClass]{
        return ["pic_urls":BMStatusPicture.self]
    }
    
    
}
