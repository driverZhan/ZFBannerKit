//
//  ViewController.swift
//  ZFBanner
//
//  Created by  zhany on 2019/5/16.
//  Copyright © 2019 zhany. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var banner: ZFBanner!
    @IBOutlet weak var sizeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var images = [ZFBannerItem]()
        for i in 1...5 {
            let item = ZFBannerItem()
            let imageName = "\(i)_launch"
            item.imageName = imageName
            images.append(item)
            
            let data = TestObject()
            data.id = i
            item.userInfo = data
        }
        
        let last = ZFBannerItem()
        last.imageName = "http://img4.duitang.com/uploads/item/201508/11/20150811220329_XyZAv.png"
        
        images.append(last)
        banner.loadImageSources(images: images)
        
        banner.delegate = self
    }
    
    @IBAction func show(sender: UIButton) {
        print("show")
        showSize()
    }
    
    private func showSize() {
        let size = ZFBanner.zf_cacheSize()
        var str: String!
        if size > 1024 * 1024 * 1024 {
            str = String(format: "%.2f GB", size / 1024 / 1024 / 1024)
        } else if size > 1024 * 1024 {
            str = String(format: "%.2f MB", size / 1024 / 1024)
        } else {
            str = String(format: "%.2f KB", size / 1024)
        }
        sizeLabel.text = "已缓存大小：" + str
    }
    
    @IBAction func clear(sender: UIButton) {
        ZFBanner.zf_clearCache { (completed) in
            if completed {
                self.showSize()
            }
        }
    }
    
}

extension ViewController: ZFBannerDelegate {
    func bannerIndexDidClicked(at index: Int, item: ZFBannerItem) {
        guard let data = item.userInfo as? TestObject else {return}
        print(data.id)
    }
}

class TestObject: NSObject {
    var id: Int = 0
}
