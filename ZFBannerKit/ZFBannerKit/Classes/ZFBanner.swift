//
//  ZFBanner.swift
//  ZFBanner
//
//  Created by  zhany on 2019/5/16.
//  Copyright © 2019 zhany. All rights reserved.
//

import UIKit


fileprivate let bannerHeight: CGFloat = 200

@objc protocol ZFBannerDelegate {
    
    @objc optional func bannerIndexDidClicked(at index: Int, item: ZFBannerItem)
}

class ZFBanner: UIView {
    
    private var timer: Timer!
    private var autoScroll: Bool = true
    
    var autoScrollTimeInterval: TimeInterval = 3
    var placeholder: UIImage?
    
    var delegate: ZFBannerDelegate?
    var bannerIndexClickBlock: ((_ index: Int, _ item: ZFBannerItem) -> Void)?
    
    private var items = [ZFBannerItem]()
    private var itemCount: Int {
        get {
            return items.count
        }
    }
    
    lazy private var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        //        control.currentPageIndicatorTintColor = UIColor.green
        //        control.pageIndicatorTintColor = UIColor.orange
        control.hidesForSinglePage = true
        return control
    }()
    
    lazy private var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.1
        layout.minimumInteritemSpacing = 0.1
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    lazy private var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.isPagingEnabled = true
        collection.bounces = true
        collection.register(ZFBannerCell.classForCoder(), forCellWithReuseIdentifier: "ZFBannerCell")
        collection.dataSource = self
        collection.delegate = self
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds
        layout.itemSize = self.bounds.size
        pageControl.sizeToFit()
        pageControl.frame = CGRect(x: 0, y: 0, width: pageControl.frame.width, height: pageControl.frame.height)
        pageControl.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: self.bounds.height - pageControl.frame.size.height / 2)
        
    }
    
    private func setupUI() {
        addSubview(collectionView)
        addSubview(pageControl)
    }
    
    private func addTimer() {
        removeTimer()
        guard autoScroll == true else {
            return
        }
        timer = Timer.scheduledTimer(timeInterval: autoScrollTimeInterval, target: self, selector: #selector(nextPage(sender:)), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
    }
    
    private func removeTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    @objc private func nextPage(sender: Timer) {
        let offsetX = collectionView.contentOffset.x
        let width = layout.itemSize.width
        
        if Int(offsetX) % Int(width) == 0 {
            collectionView.setContentOffset(CGPoint(x: offsetX + width, y: 0), animated: true)
        }else {
            let count = round(offsetX / width)
            collectionView.setContentOffset(CGPoint(x: (count + 1) * width, y: 0), animated: true)
        }
    }
    
    func loadImageSources(images: [ZFBannerItem], shouldAutoScroll: Bool = true, timeInterval: TimeInterval = 3) {
        items.removeAll()
        items = images
        autoScroll = shouldAutoScroll
        autoScrollTimeInterval = timeInterval
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = items.count
        pageControl.updateCurrentPageDisplay()
        
        collectionView.performBatchUpdates({
            self.collectionView.reloadSections([0])
        }) { (completed) in
            self.scrollToCenterOrigin()
            
            self.addTimer()
        }
    }
    
}

extension ZFBanner: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item % itemCount]
        let index = indexPath.item % itemCount
        delegate?.bannerIndexDidClicked?(at: index, item: item)
        bannerIndexClickBlock?(index,item)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = Int(scrollView.contentOffset.x)
        let width = Int(layout.itemSize.width)
        if offsetX % width == 0 {
            let currentIndex = offsetX / width
            let number = collectionView.numberOfItems(inSection: 0)
            if currentIndex == 0 {
                scrollToCenterOrigin()
            }
            if currentIndex == number - 1 {
                scrollToCenterEnd()
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        addTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = Int(scrollView.contentOffset.x)
        let width = Int(layout.itemSize.width)
        pageControl.currentPage = (offsetX / width) % itemCount
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let offsetX = Int(scrollView.contentOffset.x)
        let width = Int(layout.itemSize.width)
        pageControl.currentPage = (offsetX / width) % itemCount
    }
    
    private func scrollToCenterOrigin() {
        let indexPath = IndexPath(row: itemCount, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
    private func scrollToCenterEnd() {
        let indexPath = IndexPath(row: itemCount * 2 - 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}

extension ZFBanner: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount * 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZFBannerCell", for: indexPath) as! ZFBannerCell
        let item = items[indexPath.item % itemCount]
        if item.networkImage {
            cell.imageView.zf_setImage(url: item.imageName, placeholder: placeholder)
        }else {
            if let image = UIImage(named: item.imageName) {
                cell.imageView.image = image
            }
        }
        return cell
    }
}

//MARK: clear resource
extension ZFBanner {
    class func zf_cacheSize() -> Double{
        guard let fileDir = zf_cacheDirectory() else {return 0}
        let fm = FileManager.default
        
        if fm.fileExists(atPath: fileDir) {
            guard let childrenPaths = fm.subpaths(atPath: fileDir) else {return 0}
            var size: Double = 0
            for path in childrenPaths {
                let filePath = fileDir + "/" + path
                size += fileSize(path: filePath)
            }
            return size
        }
        return 0
    }
    
    class func zf_clearCache(complete:((_ competed: Bool) -> Void)?) {
        guard let fileDir = zf_cacheDirectory() else {
            complete?(false)
            return
        }
        let fm = FileManager.default
        if fm.fileExists(atPath: fileDir) {
            guard let childrenPaths = fm.subpaths(atPath: fileDir) else {
                complete?(false)
                return
            }
            for path in childrenPaths {
                let filePath = fileDir + "/" + path
                if fm.fileExists(atPath: filePath) {
                    do {
                        try fm.removeItem(atPath: filePath)
                    } catch {
                        
                    }
                }
            }
            complete?(true)
        }
    }
}
