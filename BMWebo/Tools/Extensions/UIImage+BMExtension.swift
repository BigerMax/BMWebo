//
//  UIImage+BMExtension.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/6/4.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import Foundation

extension UIImage{
    
    /// 创建头像图像(圆形)
    /// - Parameters:
    ///   - size: 尺寸
    ///   - backColor: 背景颜色
    /// - Returns: 裁剪后的图像
    func bm_avatarImage(size: CGSize?, backColor: UIColor = UIColor.white, lineColor: UIColor = UIColor.lightGray) -> UIImage? {
        
        var size = size
        if size == nil {
            size = self.size
        }
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        backColor.setFill()
        UIRectFill(rect)
        
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()
        
        draw(in: rect)
        
        let ovalPath = UIBezierPath(ovalIn: rect)
        ovalPath.lineWidth = 2
        lineColor.setStroke()
        ovalPath.stroke()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result
    }
    
    func bm_image(size: CGSize? = nil,backColor: UIColor = UIColor.white) -> UIImage? {
        var size = size
        if size == nil {
            size = self.size
        }
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        backColor.setFill()
        UIRectFill(rect)
        draw(in: rect)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
}
