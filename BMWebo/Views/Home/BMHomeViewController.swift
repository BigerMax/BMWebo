//
//  BMHomeViewController.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/5/14.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit

//原创微博
private let originCellID = "originCellID"
//转发weibo
private let repostCellID = "repostCellID"

class BMHomeViewController: BMBaseViewController {

    private lazy var listViewModel = BMStatusListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(tapBrowerPhoto(noti:)), name: NSNotification.Name(rawValue: BMWeiboCellBrowserPhotoNotification), object: nil)
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func tapBrowerPhoto(noti: Notification){
        
        let userInfo = noti.userInfo
        guard let selectedIndex = userInfo?[BMWeiboCellBrowserPhotoIndexKey] as? Int,
        let imageViews = userInfo?[BMWeiboCellBrowserPhotoImageViewsKeys] as? [UIImageView],
        let urls = userInfo?[BMWeiboCellBrowserPhotoURLsKeys] as? [String] else { return  }
        
        let vc = HMPhotoBrowserController.photoBrowser(withSelectedIndex: selectedIndex, urls: urls, parentImageViews: imageViews)
        present(vc, animated: true, completion: nil)
    }
    
    override func loadDatas() {
        listViewModel.loadStatus(pullup: self.isPull) { (isSuccess, needRefresh) in
            self.refreshControl?.endRefreshing()
            self.isPull = false
            if needRefresh{
                self.tableview?.reloadData()
            }
        }
    }
    
    override func setupNaviTitle() {
        let title = BMNetworkManager.shared.userAccount.screen_name
        let button = BMTitleButton(title: title, target: self, action: #selector(clickTitleButton(button:)))
        naviItem.titleView = button
    }
    
    @objc func showFriends() {
        print("showFriends")
    }

}

extension BMHomeViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = listViewModel.statusList[indexPath.row]
        let cellID = (viewModel.status.retweeted_status == nil) ? originCellID : repostCellID
        var cell:BMHomeBaseCell? = tableView.dequeueReusableCell(withIdentifier: cellID) as? BMHomeBaseCell
        if cell == nil {
            if viewModel.status.retweeted_status == nil{
                cell = BMHomeNormalCell(style: .default, reuseIdentifier: cellID)
            }else{
                cell = BMHomeRepostCell(style: .default, reuseIdentifier: cellID)
            }
        }
        cell?.delegate = self
        cell?.selectionStyle = .none
        cell?.viewModel = viewModel
        return cell ?? BMHomeBaseCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = listViewModel.statusList[indexPath.row]
        return viewModel.rowHeight
    }
}


extension BMHomeViewController:BMHomeCellDelegate{
    func homeCellDidClickUrlString(cell: BMHomeBaseCell, urlStr: String) {
        print("urlStr = \(urlStr)")
        let vc = BMWebViewController()
        vc.urlString = urlStr
        vc.title = "123"
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BMHomeViewController{
    override func setupTableView() {
        super.setupTableView()
        tableview?.rowHeight = UITableView.automaticDimension
        tableview?.estimatedRowHeight = 250
        tableview?.separatorStyle = .none
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友", fontSize:16, target: self, action: #selector(showFriends))
    }
}
