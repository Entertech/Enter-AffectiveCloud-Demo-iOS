//
//  Preference.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/15.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import Networking

typealias  EmptyBlock = () -> ()
typealias ActionBlock<T> = (T) -> ()

class Preference {
    static var FLOWTIME_WS = ""
    static var kCloudServiceAppKey = ""
    static var kCloudServiceAppSecret = ""
    
    static let help = "https://www.notion.so/Flowtime-Help-Center-b151d8677e5c41d8af6364f44fb93369"
    static let privacy = "https://www.meetinnerpeace.com/privacy-policy"
    static let terms = "https://www.meetinnerpeace.com/terms-of-service"
}

extension Preference {
    static var userID = 65535
    static let meditationTime = 180
}

extension Preference {
    private static let shortVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    private static let buildVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    static let appVersion = shortVersion + "(\(buildVersion))"
}


extension Preference {
    /// 当前的硬件版本号 1.0.1 记录101
    static var currnetFirmwareVersion: Int {
        get {
            //return Defaults[.currnetFirmwareVersion]
            return UserDefaults.standard.integer(forKey: "currnetFirmwareVersion")
        }
        set {
            //Defaults[.currnetFirmwareVersion] = newValue
            UserDefaults.standard.set(newValue, forKey: "currnetFirmwareVersion")
        }
    }
}



extension Preference {
    /// 需要更新的硬件版本号 1.0.1 记录101
    static var updateFirmwareVersion: Int {
        get {
            return UserDefaults.standard.integer(forKey: "updateFirmwareVersion")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "updateFirmwareVersion")
        }
    }
}



extension Preference {
    /// 是否做好硬件升级准备
    static var firmwareUpdateTip: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "firmwareUpdateTip")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "firmwareUpdateTip")
        }
    }
}

extension Preference {
    
    static var appUpdateLevel: Int {
        get {
            return UserDefaults.standard.integer(forKey: "appUpdateLevel")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "appUpdateLevel")
        }
    }
}

extension Preference {
    
    static var deviceStatusGuide: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "deviceStatusGuide")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "deviceStatusGuide")
        }
    }
}


extension Preference {
    
    static var haveFlowtimeConnectedBefore: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "haveFlowtimeConnectedBefore")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "haveFlowtimeConnectedBefore")
        }
    }
}

extension Preference {
    static var hardwareMac: String? {
        get {
            return UserDefaults.standard.string(forKey: "hardwareMac")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "hardwareMac")
        }
    }
    
    static var meditationSound: String? {
        get {
            return UserDefaults.standard.string(forKey: "meditationSound")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "meditationSound")
        }
    }
    
    // 无音乐冥想时长（单位：秒）
    static var noMusicMeditationDuration: Double {
        get {
            var value = UserDefaults.standard.double(forKey: "noMusicMeditationDuration")
            if value < 300 {
                value = 600.0
            }
            return value
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "noMusicMeditationDuration")
        }
    }
    
    static var statistics: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "statistics")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "statistics")
        }
    }
    
    static var showRate: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "showRate")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "showRate")
        }
    }
    
    static var accessToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "accessToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "accessToken")
            if let value = newValue {
                TokenManager.instance.accessToken = value
            }
        }
    }

    static var refreshToken: String? {
        get {
            return UserDefaults.standard.string(forKey: "refreshToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "refreshToken")
            if let value = newValue {
                TokenManager.instance.refreshToken = value
            }
        }
    }
    
    // status 8位 0-main 1-total 2-brain 3-hrv 4-randa 5-pressure
    class func setShareStatus(id: Int, status: Int) {
        UserDefaults.standard.set(status, forKey: "ShareID\(id)")
    }
    
    class func getShareStatus(id: Int) -> Int {
        return UserDefaults.standard.integer(forKey: "ShareID\(id)")
    }
}

// healthkit是否开启

extension Preference {
    
    static var healthKit: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "healthKit")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "healthKit")
        }
    }
}

// 提醒通知是否开始

extension Preference {
    
    static var reminder: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "reminder")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "reminder")
        }
    }
}

// 提醒记录星期

extension Preference {
    
    static var reminderDays: Int {
        get {
            return UserDefaults.standard.integer(forKey: "reminderDays")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "reminderDays")
        }
    }
}


// 提醒时间

extension Preference {
    
    static var remindTime: Int {
        get {
            return UserDefaults.standard.integer(forKey: "remindTime")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "remindTime")
        }
    }
}


extension Preference {
    static var bIsDownloadFirmware = false
    static let kLocalDateFormatterString = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    static let dateFormatterString = "yyyy-MM-dd HH:mm:ss"
    
    static let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    static let screenHeight = UIScreen.main.bounds.height
    static let screenWidth =  UIScreen.main.bounds.width
}


extension Preference {
    static let wxAppID = "wxa8a5c684e0425f48"
    static let wxSecret = "69235dff281112a29967a8d9df4db22a"
    static let universalLink = "https://api-test.myflowtime.cn/apple-app-site-association/"
}





