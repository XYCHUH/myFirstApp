//
//  PageTitleView.swift
//  MYAPP
//
//  Created by XY CHUH on 2018/9/28.
//  Copyright © 2018年 XY CHUH. All rights reserved.
//

import UIKit
//MARK:- 定义协议
protocol PageTitleViewDelegate: class {     //表示这个协议只能被类遵守
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int)
}

//MARK:- 定义常量
private let kScollLineH: CGFloat = 2     //滚动条高度
private let kNormalColor: (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor: (CGFloat, CGFloat, CGFloat) = (255, 0, 0)
//MARK:- 定义PageTitleView类
class PageTitleView: UIView {
    //MARK: - 定义属性
    private var titles: [String]    //数组形式的titles
    private var currentIndex: Int = 0
    weak var delegate: PageTitleViewDelegate?
    //MARK: - 懒加载属性
    private lazy var titleLabels: [UILabel] = [UILabel]()
    private lazy var scrollView: UIScrollView = {
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
        // 1.确定lable的一些frame值
        let labelW: CGFloat = frame.width / CGFloat(titles.count)
        let labelH: CGFloat = frame.height - kScollLineH
        let labelY: CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            // 2.创建UIlabel
            let label = UILabel()
            
            // 3.设置label属性
            label.text = title   //设置文字
            label.tag = index    //设置序号
            label.font = UIFont.systemFont(ofSize: 16)   //设置字号
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)         //设置文字颜色
            label.textAlignment = .center              //设置字体居中
            
            // 4.设置lable的frame其他值
            let labelX: CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)

            // 5.将label添加到scollView中
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            // 6.给label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    private func setupButtonMenuAndScollLine() {
        // 1.添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH: CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        // 2.添加scollLine
       
        // 2.1获取第一个label
        guard let firstLabel = titleLabels.first else { return }
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        // 2.2设置scollLine的属性
        scrollView.addSubview(scollLine)
        scollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScollLineH, width: titleLabels.first!.frame.width, height: kScollLineH)
    }
}

//MARK:- 监听label的点击
extension PageTitleView {
    @objc private func titleLabelClick(tapGes: UITapGestureRecognizer) {
        // 1.获取当前label
        guard let currentLabel = tapGes.view as? UILabel else { return }
        // 2.获取之前的label
        let oldLabel = titleLabels[currentIndex]
        // 3.切换文字颜色
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        // 4.保存最新的下标值
        currentIndex = currentLabel.tag
        // 5.滚动条位置发生改变
        let scollLineX = CGFloat(currentIndex) * scollLine.frame.width
        UIView.animate(withDuration: 0.15){        //设置动画
            self.scollLine.frame.origin.x = scollLineX
        }
        // 6.通知代理
        delegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)
    }
}

//MARK:- 对外暴露方法
extension PageTitleView {
    func setTitleWithProgress(progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        // 1.取出sourceLabel和targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        // 2.处理滑块逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        // 3.颜色的渐变
        // 3.1取出变化的范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        // 3.2变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        // 3.3变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        // 4.记录最新的Index
        currentIndex = targetIndex
    }
}
