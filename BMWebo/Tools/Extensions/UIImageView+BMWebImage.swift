//
//  UIImageView+BMWebImage.swift
//  BMWebo
//
//  Created by BiggerMax on 2020/6/4.
//  Copyright © 2020 BIGGERMAX. All rights reserved.
//

import Foundation
import SDWebImage

extension UIImageView{
    
    func bm_setImage(urlString: String?, placeholderImage: UIImage?, isAvatar: Bool = false){
        guard let urlString = urlString,
             let url = URL(string: urlString)  else {
                image = placeholderImage
                return
        }
        
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], context: nil, progress: nil) { [weak self] (image, error, _, _) in
            if (error != nil){
                print("url = \(url), error = \(String(describing: error))")
            }
            
            if isAvatar {
                let avatarImage = image?.bm_avatarImage(size: self?.bounds.size)
                self?.image = avatarImage
            }
        }
    }
}
