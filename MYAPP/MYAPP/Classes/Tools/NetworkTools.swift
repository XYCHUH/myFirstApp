//
//  NetworkTools.swift
//  AlamofireTest
//
//  Created by XY CHUH on 2018/10/15.
//  Copyright © 2018年 XY CHUH. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case get
    case put
    case post
    case patch
    case delete
    
    func toAFMethod() -> Alamofire.HTTPMethod {
        switch self {
        case .get:
            return Alamofire.HTTPMethod.get
        case .put:
            return Alamofire.HTTPMethod.put
        case .post:
            return Alamofire.HTTPMethod.post
        case .patch:
            return Alamofire.HTTPMethod.patch
        case .delete:
            return Alamofire.HTTPMethod.delete
        }
    }
}
class NetworkTools {
    class func requestData(type: MethodType, URLString: String, parameters: [String : NSString]? = nil, finishedCallback:@escaping (_ result: AnyObject) -> ()) {
        // 1.获取类型
        let method = type == .get ? Alamofire.HTTPMethod.get : Alamofire.HTTPMethod.post
        // 2.发送网络请求
        Alamofire.request(URLString, method: method, parameters: parameters).responseJSON { (response) in
            // 3. 获取结果
            guard let result = response.result.value else {
                print(response.result.error as Any)
                return
            }
            // 4.将结果回调
            finishedCallback(result as AnyObject)
        }
    }
}
