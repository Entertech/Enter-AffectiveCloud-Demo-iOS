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
    
    static let help = "https://docs.myflowtime.cn/"
    static let privacy = "https://www.meetinnerpeace.com/privacy-policy"
    static let terms = "https://www.meetinnerpeace.com/terms-of-service"
}

extension Preference {
    static let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    static let screenHeight = UIScreen.main.bounds.height
    static let screenWidth =  UIScreen.main.bounds.width
}

extension Preference {
    static var clientId = 98769875
    static let meditationTime = 60
    static let dateFormatter = "yyyy-MM-dd HH:mm:ss"
}

extension Preference {
    private static let shortVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    private static let buildVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    static let appVersion = shortVersion + "(\(buildVersion))"
}
