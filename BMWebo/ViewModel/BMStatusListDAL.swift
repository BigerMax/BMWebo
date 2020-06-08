//
//  BMStatusListDAL.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/5/24.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import Foundation

/// DAL: Data Access Layou ==> 数据访问层,处理数据库 & 网络数据
class BMStatusListDAL {
    
    /// 加载数据(从本地数据库 or 网络请求)
    /// - Parameters:
    ///   - since_id: 下拉刷新id
    ///   - max_id: 上拉加载更多id
    ///   - ompletion: 完成回调
    class func loadStatus(since_id: Int64 = 0, max_id: Int64 = 0, completion:@escaping (_ isSuccess:Bool, _ list:[[String:AnyObject]]?) -> ()){
        guard let userId = BMNetworkManager.shared.userAccount.uid else { return print("userId = nil") }
        //1.检查本地数据,如果有数据,直接返回
        let array = BMSQLiteManager.shared.loadWeiboStatus(userId: userId, since_id: since_id, max_id: max_id)
        
        if array.count > 0 {
            print("加载本地数据库缓存数据")
            completion(true, array)
            return
        }
        
        print("本地缓存 = nil, 家在网络数据")
        //2.加载网络请求
        BMNetworkManager.shared.fetchHomePageList(since_id: since_id, max_id: max_id) { (isSuccess, array) in
            if !isSuccess{
                completion(false, nil)
                return
            }
            
            guard let array = array else{
                completion(false, nil)
                return
            }
            
            //3.加载完成之后,写入数据库
            BMSQLiteManager.shared.updateStatus(userId: userId, array: array)
            
            //4.返回网络请求数据
            completion(isSuccess, array)
        }
        
    }
}
