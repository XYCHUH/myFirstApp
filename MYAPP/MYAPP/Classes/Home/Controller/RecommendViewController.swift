//
//  RecommendViewController.swift
//  MYAPP
//
//  Created by XY CHUH on 2018/10/6.
//  Copyright © 2018年 XY CHUH. All rights reserved.
//

import UIKit

private let kItemMargin: CGFloat = 10
private let kItemW = (kScreenW - 3 * kItemMargin) / 2
private let kNormalItemH = kItemW * 3 / 4
private let kSpecialItemH = kItemW * 4 / 3
private let kNormalCellID = "kNormalCellID"    //设置cell的标识
private let kSpecialCellID = "kSpecialCellID"
private let kHeaderViewH: CGFloat = 50         //设置组头
private let kHeaderViewID = "kHeaderViewID"     //设置组头标识

class RecommendViewController: UIViewController {
    //MARK:- 懒加载属性
    private lazy var collectionView: UICollectionView = { [unowned self] in
        // 1.创建布局layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kNormalItemH)   // 设置cell的大小
        layout.minimumLineSpacing = 0     // 行间距为0
        layout.minimumInteritemSpacing = kItemMargin
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        // 2.创建UICollectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]     //对collectionView的界面范围进行约束
        // collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kNormalCellID)   // 注册cell
        collectionView.register(UINib(nibName: "CollectionViewNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "CollectionViewSpecialCell", bundle: nil), forCellWithReuseIdentifier: kSpecialCellID)
        // collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)            //注册headerview
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)   // 用xib文件注册
        collectionView.backgroundColor = UIColor.white
        return collectionView
        }()
    
    //MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置UI界面
        setupUI()
            }
}

//MARK:- 设置UI界面内容
extension RecommendViewController {
    private func setupUI() {
        // 1.将UICollectionView添加到控制器的view中
        view.addSubview(collectionView)
    }
}

//MARK:- 遵守UICollectionView的数据源协议
extension RecommendViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        }
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 定义cell
        var cell: UICollectionViewCell?
        //cell.backgroundColor = UIColor.orange
        if indexPath.section == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kSpecialCellID, for: indexPath)
        }
        else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath)
        }
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // 取出section的headerView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath)
        return headerView
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {                // 此方法继承自UICollectionViewDelegateFlowLayout用于改变cell的size
        if indexPath.section == 1 {
            return CGSize(width: kItemW, height: kSpecialItemH)
        }
        return CGSize(width: kItemW, height: kNormalItemH)
    }
    
}
