//
//  BMUserAccount.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/5/7.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit
import YYModel

private let accountFileName = "userAccount.json"

class BMUserAccount: NSObject {
    //访问令牌= "2.00s3H5jBsYt2bDda64ce2323LFzYfC"
    @objc var access_token : String?
    @objc var uid : String?
    @objc var expires_in : TimeInterval = 0.0{
        didSet{
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    @objc var expiresDate : Date?
    @objc var screen_name : String?
    @objc var avatar_large : String?
    
    override init() {
        super.init()
        guard let filePath = accountFileName.bm_appendDocumentDir(),
            let data = NSData(contentsOfFile: filePath),
            let dic = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String:AnyObject] else {
                print("filePath or data is nil")
                return
        }
        yy_modelSet(with: dic)
        
        if expiresDate?.compare(Date()) != .orderedDescending{
            //过期 == 过期时间 < 当前时间 == 降序时间
            print("账户过期")
            
            access_token = nil
            uid = nil
            try? FileManager.default.removeItem(atPath: filePath)
        }
    }
    
    override var description: String{
        return yy_modelDescription()
    }
    
    
    /**
            1.UserDefault
             2.sandox
                3.数据库
                    4.keychain
     */
    
    func saveAccountInfo() {
        var dic = self.yy_modelToJSONObject() as? [String:AnyObject] ?? [:]
        dic.removeValue(forKey: "expires_in")
        
        guard let data = try? JSONSerialization.data(withJSONObject: dic, options: []),
            let filePath = accountFileName.bm_appendDocumentDir() else { print("filePath write to failure")
                return
                
        }
        
        let result = (data as NSData).write(toFile: filePath, atomically: true)
        print("write to \(filePath) \(result ? "success" : "failure")")
    }
}
