//
//  ZFBannerTools.swift
//  ZFBanner
//
//  Created by  zhany on 2019/5/16.
//  Copyright © 2019 zhany. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

extension UIImageView {
    
    func zf_setImage(url: String, placeholder: UIImage?) {
        guard let fileDirec = zf_cacheDirectory() else {return}
        do {
            try FileManager.default.createDirectory(atPath: fileDirec, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error.localizedDescription)
        }
        let filePath = fileDirec + "/" + md5String(str: url)
        if let image = UIImage(contentsOfFile: filePath) {
            self.image = image
        }else {
            if placeholder != nil {
                self.image = placeholder
            }
            
            guard let requestUrl = URL(string: url) else {return}
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: requestUrl)
                    guard let resultImage = UIImage(data: data) else {return}
                    DispatchQueue.main.async {
                        self.image = resultImage
                    }
                    try! data.write(to: URL(fileURLWithPath: filePath))
                } catch {
                    print("error->\(error.localizedDescription)")
                }
            }
        }
        
    }
    
    func md5String(str: String) -> String{
        let cStr = str.cString(using: .utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
    
}

func zf_cacheDirectory() -> String?{
    guard let directory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {return nil}
    let fileDirec = directory + "/ZFBannerImageCaches"
    return fileDirec
}

func fileSize(path: String) -> Double{
    do {
        if !FileManager.default.fileExists(atPath: path) {
            return 0
        }
        let attr = try FileManager.default.attributesOfItem(atPath: path)
        let size: Double = attr[FileAttributeKey.size] as! Double
        return size
    } catch {
        
    }
    return 0
}
