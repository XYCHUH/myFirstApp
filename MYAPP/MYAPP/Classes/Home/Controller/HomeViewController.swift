//
//  HomeViewController.swift
//  MYAPP
//
//  Created by XY CHUH on 2018/9/26.
//  Copyright © 2018年 XY CHUH. All rights reserved.
//

import UIKit

let kTitleView: CGFloat = 40

class HomeViewController: UIViewController {
    // MARK: - 标题栏懒加载属性
        private lazy var pageTitleView: PageTitleView = {
        let titleFrame = CGRect(x: 0, y: kStateBarH + kNavBarH, width: kScreenW, height: kTitleView)
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
            return titleView
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
        //0.不希望系统自动调整scollView的内边距
        pageTitleView.scrollView.contentInsetAdjustmentBehavior = .never
        //1.设置导航栏
        setupNavigationBar()
        //2.设置titleView
        view.addSubview(pageTitleView)
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
