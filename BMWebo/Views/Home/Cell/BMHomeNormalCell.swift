//
//  BMHomeNormalCell.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/6/7.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import UIKit

class BMHomeNormalCell: BMHomeBaseCell {

    override func setupSubViews() {
        super.setupSubViews()
        contentPictureView = BMStatusPictureView(parentView: self, topView: contentLabel, bottomView: bottomView)
    }

}
