//
//  PageContentView.swift
//  MYAPP
//
//  Created by XY CHUH on 2018/10/3.
//  Copyright © 2018年 XY CHUH. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate: class {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
}

private let contentCellID = "contentCellID"

class PageContentView: UIView {
    //MARK:- 自定义属性
    private var childVcs: [UIViewController]
    private weak var parentViewController: UIViewController?
    private var startOffSetX: CGFloat = 0
    private var isForBidScollDelegate: Bool = false
    weak var delegate: PageContentViewDelegate?
    //MARK:- 懒加载属性
    private lazy var collectionView: UICollectionView = { [weak self] in
        // 1.创建layout
        let layOut = UICollectionViewFlowLayout()
        layOut.itemSize = (self?.bounds.size)!
        layOut.minimumLineSpacing = 0   //设置行间距
        layOut.minimumInteritemSpacing = 0 //设置item间距
        layOut.scrollDirection = .horizontal
        // 2.创建collectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layOut)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollsToTop = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: contentCellID)
        return collectionView
    }()
    //MARK:- 自定义构造函数
    init(frame: CGRect, childVcs: [UIViewController], parentViewController: UIViewController?) {
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        super.init(frame: frame)
        // 设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK:- 设置UI界面
extension PageContentView {
    private func setupUI() {
        // 1.将所有的自控制器添加到父控制器中
        for childVc in childVcs {
            parentViewController?.addChild(childVc)
        }
        // 2.添加UIcollectionView,用于在cell中存放控制器的view
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

//MARK:- 遵守UICollectionDataSource
extension PageContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellID, for: indexPath)
        // 2.给cell设置内容
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }                                        // 防止循环添加多次
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
}

//MARK:- 遵守UICollectionViewDelegate
extension PageContentView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {   //开始拖动
        isForBidScollDelegate = false
        startOffSetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {     // 监测到滚动的函数
        // 0.判断是否是点击事件
        if isForBidScollDelegate {
            return
        }
        // 1.定义需要获取的数据
        var progress: CGFloat = 0
        var sourceIndex: Int = 0
        var targetIndex: Int = 0
        // 2.判断是左滑还是右滑
        let currentOffSetX = scrollView.contentOffset.x
        let scollViewW = scrollView.bounds.width
        // 分左滑右滑分别计算progress，sourceIndex，targetIndex
        if currentOffSetX > startOffSetX {    // 左滑
            progress = currentOffSetX / scollViewW - floor(currentOffSetX / scollViewW)
            sourceIndex = Int(currentOffSetX/scollViewW)
            targetIndex = sourceIndex + 1
           if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            if currentOffSetX - startOffSetX == scollViewW {    //如果将此if语句注释掉最后一个label将不会成为选中的颜色
                progress = 1
                 targetIndex = sourceIndex
            }
        } else {                              // 右滑
            progress = 1 - (currentOffSetX / scollViewW - floor(currentOffSetX / scollViewW))
            targetIndex = Int(currentOffSetX / scollViewW)
            sourceIndex = targetIndex + 1
            /*if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }*/
        }
        //将获取的progress、sourceIndex、targetIndex传递给titleView
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

//MARK:- 对外暴露方法
extension PageContentView {
    func setCurrentIndex(currentIndex: Int){
        // 1.记录需要执行代理方法
        isForBidScollDelegate = true
        // 2.滚到正确的q位置
        let offSetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: true)
    }
}
