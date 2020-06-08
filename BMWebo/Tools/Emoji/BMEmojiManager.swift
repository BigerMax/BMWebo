//
//  BMEmojiManager.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/5/14.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit

class BMEmojiManager {
    static let shared = BMEmojiManager()
    
    lazy var packages = [BMEmojiPackeModel]()
    
    let pageCells = 20
    
    lazy var bundle : Bundle = {
        let path = Bundle.main.path(forResource: "BMEmoji.bundle", ofType: nil)
        return Bundle(path: path ?? "") ?? Bundle()
    }()
    
    private init(){
        loadPackageDatas()
    }
    
    //添加最近使用的表情
    func recentEmoji(model: BMEmojiModel){
       //1.表情使用次数+1
        model.times += 1
        
        //2.添加表情
        if !packages[0].emotions.contains(model){
            packages[0].emotions.append(model)
        }
        
        //3.排序
        packages[0].emotions.sort { $0.times > $1.times }
        
        //4.表情数组长度处理
        if packages[0].emotions.count > pageCells {
            let subRange = pageCells..<packages[0].emotions.count
            packages[0].emotions.removeSubrange(subRange)
        }
    }
}

private extension BMEmojiManager{
    func loadPackageDatas(){
        guard let plistPath  = bundle.path(forResource: "emoticons.plist", ofType: nil),
            let array = NSArray(contentsOfFile: plistPath) as? [[String:String]],
            let models = NSArray.yy_modelArray(with: BMEmojiPackeModel.self, json: array) as? [BMEmojiPackeModel]
            else {
                print("loadPackageDatas failure.")
                return
        }
        packages += models
    }
}

//MARK: - 表情符号处理
extension BMEmojiManager{
    
    
    
    ///更具传入的字符串[abc],查找对应的表情模型
    /// - Parameter string: 查询字符串
    /// - Returns:
    func findEmoji(string: String) -> BMEmojiModel? {
        for pModel in packages{
            
            //传入的参数和model对比,过滤出一致字符串对应的模型
            let result = pModel.emotions.filter { $0.chs == string }
            if result.count > 0 {
                return result.first
            }
        }
        return nil
    }
    
    
    
    /// 将字符串转换成属性文本
    /// - Parameters:
    ///   - string: 原始字符串
    ///   - font: <#font description#>
    /// - Returns:
    func getEmojiString(string: String, font: UIFont) -> NSAttributedString {
        let attStr = NSMutableAttributedString(string: string)
        //1.正则过滤【xxx】的表情文字
        let pattern = "\\[.*?\\]"
        
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else { return attStr }
        
        //2.字符串全量匹配
        let matchs = regx.matches(in: string, options: [], range: NSRange(location: 0, length: attStr.length))
        
        //3. 所有匹配结果(倒序)
               /**图片替换 - 必须倒序遍历！(*类比算法的字符串替换*)
                     r1 = {2,5}
                     r2 = {9,5}
                     
                     - 正序查找,替换之后，原始字符串长度会变
                     
                     ==> r2 就找不到 [打代码] 的范围了
                     
                     - 倒序查找
                     
                     ==> r1 的{2,5} 对应的还是range还是正确的
               */
        
        for result in matchs.reversed(){
            let range = result.range(at: 0)
            let subStr = (attStr.string as NSString).substring(with: range)
            
            //查找[xxx]对应的表情
            if let model = findEmoji(string: subStr){
                attStr.replaceCharacters(in: range, with: model.imageText(font: font))
            }
        }
        
        //统一设置属性和颜色
        attStr.addAttributes([NSAttributedString.Key.font : font,
                              NSAttributedString.Key.foregroundColor : UIColor.darkGray],
                              range: NSRange(location: 0, length: attStr.length))
        return attStr
    }
}
