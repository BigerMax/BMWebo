//
//  BMStatusListViewModel.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/5/14.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import Foundation
import YYModel
import SDWebImage

// 超过5次上拉加载失败，就停止上拉刷新
private let maxPullupTimes = 5


class BMStatusListViewModel {
    lazy var statusList = [BMStatusViewModel]()
    
    private var pullupErrorTimes = 0
    /// 处理微博首页数据
    /// - Parameters:
    ///   - pullup: 是否下拉刷新
    ///   - completion: 完成请求,needRefresh = 是否需要刷新表格
    func loadStatus(pullup:Bool, completion:@escaping (_ isSuccess:Bool, _ needReFresh:Bool) -> ()){
        if pullup && pullupErrorTimes >= maxPullupTimes{
            completion(true, false)
            return
        }
        
        //取出当前最新的数据 -> 越上面越新
        let since_id = pullup ? 0 : (statusList.first?.status.id ?? 0)
        //上拉加载更多->取最旧的一条
        let max_id = !pullup ? 0 : (statusList.last?.status.id ?? 0)
        
        BMStatusListDAL.loadStatus(since_id: since_id, max_id: max_id) { (isSuccess, list) in
            if !isSuccess{
                completion(false, false)
                return
            }
            var array = [BMStatusViewModel]()
            for dic in list ?? []{
                guard let model = BMStatusModel.yy_model(with: dic) else { continue }
                
                //转化成model -> BMStatusViewModel
                array.append(BMStatusViewModel(model: model))
            }
            
            //data handle
            if pullup{
                //上拉加载更多,凭借在数组最后
                self.statusList += array
            }else{
                //下拉刷新,拼接在数组最前面
                self.statusList = array + self.statusList
            }
            
            if pullup && array.count == 0{
                self.pullupErrorTimes += 1
                completion(isSuccess,false)
            }else{
                self.cacheSingleImage(list: array){
                    completion(isSuccess, true)
                }
            }
        }
        
    }
    
    //本次下载的单张图片 - 换成
    private func cacheSingleImage(list: [BMStatusViewModel],finish: @escaping() -> ()){
        let group = DispatchGroup()
        var length = 0
        
        //单张图像 - 特殊处理
        for viewModel in list{
            if viewModel.picUrls?.count != 1{
                continue
            }
            
            //get picture url
            guard let picture = viewModel.picUrls?[0].thumbnail_pic,
            let url = URL(string: picture) else { continue }
            
            //SD下载图像
           //图像下载完成，会自动p保存到沙盒, 路径 ==> url 的 md5
           //如果该url的图像已经缓存 - 之后调用sd_xxx 不会在走下载.
           //1.调度组入组
            group.enter()
            SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { (image, _, _, _, _, _) in
                
                //图像转换成二进制数据
                if let image = image,
                    let imageData = image.jpegData(compressionQuality: 1.0){
                    length += imageData.count
                    viewModel.updateSingleImageSize(image: image)
                }
                //2.出组
                group.leave()
            }
        }
        
        //3.调度组完成
        group.notify(queue: DispatchQueue.main){
            print("down load finish ...")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                finish()
            }
        }
    }
}
