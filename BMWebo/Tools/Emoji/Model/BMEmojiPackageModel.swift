//
//  BMEmojiPackageModel.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/5/14.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit

class BMEmojiPackeModel: NSObject {
    //表情包分组
    @objc var groupName:String?
    
    @objc var bgImageName: String?
    
    ///表情模型数组
    @objc lazy var emotions = [BMEmojiModel]()
    
    func emojiModel(page:Int) -> [BMEmojiModel]{
        //表情包每页数量
        let count = 20
        let location = page * count
        var length = count
        //越界处理
        if location + length > emotions.count{
            length = emotions.count - location
        }
        
        let range = NSRange(location: location, length: length)
        let subArray = (emotions as NSArray).subarray(with: range)
        
        return subArray as! [BMEmojiModel]
    }
    
    
    //表情页面数
    var numnerOfPage: Int{
        return (emotions.count - 1) / 20 + 1
    }
    
    ///表情包目录-通过info.plist创建表情模型数字
    @objc var directory:String?{
        didSet{
            //设置目录的时候,读取info.plist数据
            guard let directory = directory,
                let path = Bundle.main.path(forResource: "BMEmoji.bundle", ofType: nil),
                let bundle = Bundle(path: path),
                let infoPath = bundle.path(forResource: "info.plist", ofType: nil, inDirectory: directory),
            let array = NSArray(contentsOfFile: infoPath),
                let models = NSArray.yy_modelArray(with: BMEmojiModel.self, json: array) as? [BMEmojiModel]
                else {
                    print("Set directory failure.")
                    return
            }
            
            //设置表情目录
            for model in models{
                model.directory = directory
            }
            emotions += models
        }
    }
    
    override var description: String{
        return yy_modelDescription()
    }
}
