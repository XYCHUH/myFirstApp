//
//  HomeViewController.swift
//  MYAPP
//
//  Created by XY CHUH on 2018/9/26.
//  Copyright © 2018年 XY CHUH. All rights reserved.
//

import UIKit

let kTitleViewH: CGFloat = 40

class HomeViewController: UIViewController {
    // MARK: - 标题栏懒加载属性
    private lazy var pageTitleView: PageTitleView = { [weak self] in
        let titleFrame = CGRect(x: 0, y: kStateBarH + kNavBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["recommand", "game", "entertain", "play"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    
    private lazy var pageContentView: PageContentView = { [weak self] in
        // 1.确定内容的frame
        let kContentH = kScreenH - kStateBarH - kNavBarH - kTitleViewH - kTabBarH
        let contentFrame = CGRect(x: 0, y: kStateBarH + kNavBarH + kTitleViewH, width: kScreenW, height: kContentH)
        // 2.确定所有的子控制器
        var childVcs = [UIViewController]()
        childVcs.append(RecommendViewController())     //创建“推荐“
        for _ in 0..<3 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))   //生成rgb随机颜色
            childVcs.append(vc)
        }
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        contentView.delegate = self
        return contentView
    }()
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
       //设置UI界面
        setupUI()
    }
}
    
    // MARK: - 设置UI界面
extension HomeViewController {
     private func setupUI() {
        // 0.不希望系统自动调整scollView的内边距
        //pageTitleView.scrollView.contentInsetAdjustmentBehavior = .never
        // 1.设置导航栏
        setupNavigationBar()
        // 2.添加titleView
        view.addSubview(pageTitleView)
        // 3.添加contentView
        view.addSubview(pageContentView)
    }
     private func setupNavigationBar() {
       //设置左侧导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(ImageName: "logo")
        
        //设置右侧导航栏按钮
        let size = CGSize(width: 40, height: 40)
        let historyItem = UIBarButtonItem(ImageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(ImageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        let qrCodeItem = UIBarButtonItem(ImageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrCodeItem]
        
        
    }
}
// 遵守PageTitleViewDelegate协议
extension HomeViewController: PageTitleViewDelegate {
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}

//遵守PageContentViewDelegate协议
extension HomeViewController: PageContentViewDelegate {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
