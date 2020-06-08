//
//  BMWeboCommon.swift
//  BMWebo
//
//  Created by top-more on 2020/4/29.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit

// MARK: - App infomation
let BMAppKey = "3300341398"

let BMAppSecret = "20caa93d4c230ebbd831bb3afba6bf84"
// 登录完成-跳转的地址
let BMredirectUri = "http://baidu.com"

//MARK: - global notification

let BMUserShouldLoginNotification = "BMUserShouldLoginNotification"

let BMUserLoginSuccessNotification = "BMUserLoginSuccessNotification"

/// 微博Cell浏览照片
/// @param urlString   urlString 字符串
/// @param photoIndex  照片索引
/// @param placeholder 占位图像
let BMWeiboCellBrowserPhotoNotification = "BMWeiboCellBrowserPhotoNotification"

let BMWeiboCellBrowserPhotoIndexKey = "BMWeiboCellBrowserPhotoIndexKey"
let BMWeiboCellBrowserPhotoURLsKeys = "BMWeiboCellBrowserPhotoURLsKeys"
let BMWeiboCellBrowserPhotoImageViewsKeys = "BMWeiboCellBrowserPhotoImageViewsKeys"

//MARK: - 微博配图视图常亮
let BMDefaultMargin = BMLayout.Layout(12)
//外部间距
let BMStatusPictureOutterMargin = BMLayout.Layout(12)
//内部间距
let BMStatusPictureInnerMargin = BMLayout.Layout(5)

let BMPictureMaxPerLine:CGFloat = 3

//1.calculate width
let BMPictureViewWidth = UIScreen.bm_screenW - (2 * BMStatusPictureOutterMargin)

let BMPictureItemWidth = (BMPictureViewWidth - (2 * BMStatusPictureInnerMargin)) / BMPictureMaxPerLine

// iPhone X
let BM_iPhoneX = (UIScreen.bm_screenW >= 375 && UIScreen.bm_screenH >= 812)

// Status bar height.
let BM_statusBarHeight:CGFloat = BM_iPhoneX ? 44 : 20

let BM_naviContentHeight:CGFloat = 44

let BM_bottomTabBarContentHeigth:CGFloat = 49

let BM_bottomTabBarSpeacing:CGFloat = BM_iPhoneX ? 34 : 0

// Tabbar height.
let BM_bottomTabBarHeight:CGFloat  =  BM_iPhoneX ? (BM_bottomTabBarContentHeigth + BM_bottomTabBarSpeacing) : BM_bottomTabBarContentHeigth

// Status bar & navigation bar height.
var BM_naviBarHeight:CGFloat = BM_statusBarHeight + BM_naviContentHeight
