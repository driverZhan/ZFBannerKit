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

open class ZFBannerItem: NSObject {
    
    private var _imageName: String!
    private var _userInfo: Any?
    @objc open var imageName: String! {
        get{return _imageName}
        set{
            _imageName = newValue
        }
    }
    @objc open var userInfo: Any? {
        get{return _userInfo}
        set{
            _userInfo = newValue
            
        }
    }
    
    @objc open var networkImage: Bool {
        get {
            return imageName.hasPrefix("https://") || imageName.hasPrefix("http://")
        }
    }
}
