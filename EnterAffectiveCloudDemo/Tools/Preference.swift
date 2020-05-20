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
}

extension Preference {
    static var bIsDownloadFirmware = false
}


