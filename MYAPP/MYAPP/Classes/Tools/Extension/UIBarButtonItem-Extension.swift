//
//  UIBarButtonItem-Extension.swift
//  MYAPP
//
//  Created by XY CHUH on 2018/9/28.
//  Copyright © 2018年 XY CHUH. All rights reserved.
//

import UIKit
//两者都可以
extension UIBarButtonItem {
    /*类方法
     class func createItem (ImageName: String, highImageName: String, size: CGSize) -> UIBarButtonItem {
        let btn = UIButton()
        btn.setImage(UIImage(named: ImageName), for: .normal)
        btn.setImage(UIImage(named: highImageName), for: .highlighted)
        btn.frame = CGRect(origin: CGPoint.zero, size: size)
        return UIBarButtonItem(customView: btn)
    }
}
     
*/
/*便利构造函数
 开头必须用到convenience 2>在便利构造函数中必须明确调用一个已存在的的构造函数self.init()
*/
    convenience init(ImageName: String, highImageName: String = "", size: CGSize = CGSize.zero) {
        //highImageName: String = ""预设参数后参数可以缺省
        //设置button图片
        let btn = UIButton()
        btn.setImage(UIImage(named: ImageName), for: .normal)
        if highImageName != "" {
            btn.setImage(UIImage(named: highImageName), for: .highlighted)
        }
        //设置button尺寸
        if size == CGSize.zero{
            btn.sizeToFit()
        } else {
        btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        //创建UIBarButtonItem
        self.init(customView: btn)
    }
}
