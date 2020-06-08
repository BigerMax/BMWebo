//
//  BMProfileViewController.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/6/8.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit

class BMProfileViewController: BMBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl?.endRefreshing()
        }
        // Do any additional setup after loading the view.
    }
    


}
