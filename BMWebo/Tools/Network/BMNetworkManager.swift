//
//  BMNetworkManager.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/5/7.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit
import AFNetworking

enum RequestMethod {
    case GET
    case POST
}

class BMNetworkManager: AFHTTPSessionManager {
    
    static let shared:BMNetworkManager = {
        let instance = BMNetworkManager()
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return instance
    }()
    
    lazy var userAccount = BMUserAccount()
    
    var isLogin:Bool {
        return userAccount.access_token != nil
    }
    
    func request(method:RequestMethod = .GET, URLString:String, parameters:[String:AnyObject]?, completion:@escaping (_ isSuccess:Bool, _ json:Any?)->()) {
        let success = { (task: URLSessionDataTask, json: Any?) -> () in
            completion(true, json)
        }
        let failure = { (task: URLSessionDataTask?, error: Error) -> () in
            print("Request error ==> \(error)")
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                print("token过期了兄弟")
                NotificationCenter.default.post(name: Notification.Name(BMUserShouldLoginNotification), object: "token403")
            }
            completion(false, nil)
        }
        
        if method == .GET {
            get(URLString, parameters: parameters, headers: nil, progress: nil, success: success, failure: failure)
        }else{
            post(URLString, parameters: parameters, headers: nil, progress: nil, success: success, failure: failure)
        }
    }
    
    func tokenRequest(method:RequestMethod = .GET, URLString:String,parameters:[String:AnyObject]?, completion:@escaping (_ isSuccess : Bool, _ json:Any?)->()) {
        guard let token = userAccount.access_token else {
            print("token is nil, need to login")
            NotificationCenter.default.post(name: Notification.Name(BMUserShouldLoginNotification), object: nil)
            completion(false, nil)
            return
        }
        var parameters = parameters
        if parameters == nil {
            parameters = [String:AnyObject]()
        }
        
        parameters!["access_token"] = token as AnyObject
        request(method: method, URLString: URLString, parameters: parameters, completion: completion)
    }
}

extension BMNetworkManager{
    
    
    /// fetch home page datas
    /// - Parameters:
    ///   - since_id: 返回比since_id 晚的微博，默认为0(最新) ==> 上拉刷新
    ///   - max_id: 返回 <= max_id 的微博，默认为0
    ///   - completion: 请求完成的回调
    func fetchHomePageList(since_id:Int64 = 0, max_id:Int64 = 0,completion:@escaping (_ isSuccess:Bool, _ list:[[String:AnyObject]]?) -> ()){
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        //max_id - 1 ==> 不然会出现两条一模一样的记录
        let maxidValue = max_id > 0 ? max_id - 1 : 0
        let parms = ["since_id":since_id,"max_id":maxidValue]
        
        tokenRequest(URLString: urlString, parameters: parms as [String : AnyObject]) { (isSuccess, json) in
            let jsonObject = json as?[String:Any]
            let result = jsonObject?["statuses"] as? [[String:AnyObject]]
            
            completion(isSuccess, result)
        }
    }
    
    //模拟未读消息
    func unreadCount(completion:@escaping (_ count: Int) -> ()){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let count = 3
            completion(count)
        }
    }
    
}
//MARK: -OAuth
extension BMNetworkManager{
    func getAccessToken(code: String, completion: @escaping((_ isSuccess: Bool) ->Void)){
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let parms = ["client_id":BMAppKey,
                     "client_secret":BMAppSecret,
                     "grant_type":"authorization_code",
                     "code":code,
                     "redirect_uri":BMredirectUri]
        request(method: .POST, URLString: urlString, parameters: parms as [String : AnyObject]) { (isSuccess, json) in
            //使用YYModel转模型,如果转出来是nil,记得属性前面加`@objc` 关键字
            // ==> swift4以后_YYModelMeta中的_keyMappedCount获取不到不带`@objc`的变量
            self.userAccount.yy_modelSet(with: json as? [String:AnyObject] ?? [:])
            
            //load user info
            self.fetchUserInfo { (dic) in
                self.userAccount.yy_modelSet(with: dic)
                self.userAccount.saveAccountInfo()
                completion(isSuccess)
            }
        }
    }
}

// MARK: -UserInfo
extension BMNetworkManager {
    func fetchUserInfo(completion:@escaping (([String:AnyObject])->())){
        guard let uid = userAccount.uid else { return }
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        let parms = ["uid":uid]
        
        tokenRequest(URLString: urlString, parameters: parms as [String : AnyObject]) { (isSuccess, json) in
            completion((json as? [String:AnyObject]) ?? [:])
        }
    }
}

// MARK: - 发布微博
extension BMNetworkManager{
    func creatStatus(text: String, completion:@escaping (_ result: [String:Any]?, _ isSuccess:Bool) ->()) {
        //FIXME: 发布接口==>高级写入接口,要权限申请.
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        let parms = ["status":text]
        
        tokenRequest(method: .POST, URLString: urlString, parameters: parms as [String : AnyObject]) { (isSuccess, json) in
            completion(json as? [String:Any], isSuccess)
        }
    }
}
