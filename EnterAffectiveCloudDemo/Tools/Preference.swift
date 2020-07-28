//
//  Preference.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/15.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

typealias  EmptyBlock = () -> ()
typealias ActionBlock<T> = (T) -> ()

class Preference {
    static var FLOWTIME_WS = ""
    static var kCloudServiceAppKey = ""
    static var kCloudServiceAppSecret = ""
    static var kCloudServiceUploadCycle = 3  //0.6秒为一个计算周期，设置默认为3等于计算周期1.8秒，也就是1.8秒上传一次数据，详细请查看情感云文档
    static let help = "https://www.notion.so/Flowtime-Help-Center-b151d8677e5c41d8af6364f44fb93369"
    static let privacy = "https://www.meetinnerpeace.com/privacy-policy"
    static let terms = "https://www.meetinnerpeace.com/terms-of-service"
}

extension Preference {
    static let userID = 1
    static let meditationTime = 60
}

extension Preference {
    private static let shortVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    private static let buildVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    static let appVersion = shortVersion + "(\(buildVersion))"
}




