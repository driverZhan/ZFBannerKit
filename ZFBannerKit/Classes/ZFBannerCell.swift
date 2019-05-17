//
//  ZFBannerCell.swift
//  ZFBanner
//
//  Created by  zhany on 2019/5/16.
//  Copyright © 2019 zhany. All rights reserved.
//

import UIKit

class ZFBannerCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
        
    }
    
}

class ZFBannerItem: NSObject {
    var imageName: String!
    var userInfo: Any?
    
    var networkImage: Bool {
        get {
            return imageName.hasPrefix("https://") || imageName.hasPrefix("http://")
        }
    }
}
