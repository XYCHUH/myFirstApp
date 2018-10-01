//
//  PageTitleView.swift
//  MYAPP
//
//  Created by XY CHUH on 2018/9/28.
//  Copyright © 2018年 XY CHUH. All rights reserved.
//

import UIKit

class PageTitleView: UIView {
    private let kScollLineH: CGFloat = 2     //滚动条高度
    //MARK: - 定义属性
    private var titles: [String]    //数组形式的titles
    //MARK: - 懒加载属性
    private lazy var titleLabels: [UILabel] = [UILabel]()
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    private lazy var scollLine: UIView = {
        let scollLine = UIView()
        scollLine.backgroundColor = UIColor.red
        return scollLine
    }()
    //MARK: - 自定义构造函数
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: -设置UI界面
extension PageTitleView {
    private func setupUI() {
        //1.添加UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        //2.添加title对应的label
        setupTitleLabels()
        //3.设置底线和滚动的滑块
        setupButtonMenuAndScollLine()
    }
    
    private func setupTitleLabels() {
        //1.确定lable的一些frame值
        let labelW: CGFloat = frame.width / CGFloat(titles.count)
        let labelH: CGFloat = frame.height - kScollLineH
        let labelY: CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            //2.创建UIlabel
            let label = UILabel()
            
            //3.设置label属性
            label.text = title   //设置文字
            label.tag = index    //设置序号
            label.font = UIFont.systemFont(ofSize: 16)   //设置字号
            label.textColor = UIColor.darkGray         //设置文字颜色
            label.textAlignment = .center              //设置字体居中
            
            //4.设置lable的frame其他值
            let labelX: CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)

            //5.将label添加到scollView中
            scrollView.addSubview(label)
            titleLabels.append(label)
        }
    }
    
    private func setupButtonMenuAndScollLine() {
        //1.添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH: CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        //2.添加scollLine
       
        //2.1获取第一个label          /* let firstLabel = titleLabels.first! */
        titleLabels.first!.textColor = UIColor.red
        //2.2设置scollLine的属性
        scrollView.addSubview(scollLine)
        scollLine.frame = CGRect(x: titleLabels.first!.frame.origin.x, y: frame.height - kScollLineH, width: titleLabels.first!.frame.width, height: kScollLineH)
    }
}
