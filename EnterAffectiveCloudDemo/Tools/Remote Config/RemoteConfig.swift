//
//  RemoteConfig.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/5/19.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit

//获取网址
public enum RemoteConfigKey: String {
    case help              = "help_center"
    case privacy           = "privacy"
    case items             = "terms_of_use"
    case introduce         = "flowtime_headband_intro"
    case eegService        = "eeg_realtime_info"
    case hrService         = "hr_realtime_info"
    case hrReport          = "hr_report_info"
    case hrvReport         = "hrv_report_info"
    case brainService      = "brainwave_spectrum_realtime_info"
    case brainReport       = "brainwave_spectrum_report_info"
    case attentionService  = "attention_realtime_info"
    case attentionReport   = "attention_report_info"
    case relaxationService = "relaxation_realtime_info"
    case relaxationReport  = "relaxation_report_info"
    case pressureService   = "pressure_realtime_info"
    case pressureReport    = "pressure_report_info"
    case productPrice      = "product_price"
    case fillAddress       = "fill_address"
    case cannotConnect     = "cannot_connect"
    case last7Times        = "last_7_times"
    case appVersion        = "new_app_version"
    case firmwareVersion   = "new_firmware_version"
    case firmwareUrl       = "firmware_url"
}

public struct FTRemoteConfigKeyDefaultValue {
    static let help = "https://www.notion.so/Flowtime-Help-Center-b151d8677e5c41d8af6364f44fb93369"
    static let cannotConnect = "https://www.notion.so/I-can-t-connect-the-headband-with-the-app-1ae10dc7fe1049c4953fc879f9042730"
    static let privacy = "https://www.meetinnerpeace.com/privacy-policy"
    static let items = "https://www.meetinnerpeace.com/terms-of-service"
    static let introduce = "https://www.meetinnerpeace.com/flowtime"
    static let eegService = "https://www.notion.so/EEG-b3a44e9eb01549c29da1d8b2cc7bc08d"
    static let hrService = "https://www.notion.so/Heart-Rate-4d64215ac50f4520af7ff516c0f0e00b"
    static let hrReport = "https://www.notion.so/Heart-Rate-Graph-fa83da8528694fd1a265882db31d3778"
    static let hrvReport = "https://www.notion.so/HRV-Graph-6f93225bf7934cb8a16eb6ba55da52cb"
    static let brainService = "https://www.notion.so/Brainwave-Power-4cdadda14a69424790c2d7913ad775ff"
    static let brainReport = "https://www.notion.so/Brainwave-Power-Graph-6f2a784b347d4d7d98b9fd0da89de454"
    static let relaxationService = "https://www.notion.so/Relaxation-c9e3b39634a14d2fa47eaed1d55d872b"
    static let relaxationReport  = "https://www.notion.so/Relaxation-Graph-d04c7d161ca94c6eb9c526cdefe88f02"
    static let attentionService = "https://www.notion.so/Attention-84fef81572a848efbf87075ab67f4cfe"
    static let attentionReport = "https://www.notion.so/Attention-Graph-8f9fa5017ba74a34866c1977a323960a"
    static let pressureService = "https://www.notion.so/Pressure-ee57f4590373442b9107b7ce665e1253"
    static let pressureReport = "https://www.notion.so/Pressure-Graph-48593014d6e44f7f8366364d70dced05"
    static let last7times = "https://www.notion.so/Last-7-Times-15a5331f15a3438ca1abdcbf2b0ff331"
    static let productPrice = "$198"
    static let fillAddress = "https://jinshuju.net/f/tQP3iq"
    static let appVersion        = "0.0.0"
    static let firmwareVersion   = "0.0.0"
    static let firmwareUrl       = "http://heartflow.oss-cn-hangzhou.aliyuncs.com/firmware/1.0.1"
}

public class FTRemoteConfig {
    public static let shared = FTRemoteConfig()
    public func getConfig(key: RemoteConfigKey) -> String? {
        var defaultValue = ""
        switch key {
        case .help:
            defaultValue = FTRemoteConfigKeyDefaultValue.help
        case .privacy:
            defaultValue = FTRemoteConfigKeyDefaultValue.privacy
        case .items:
            defaultValue = FTRemoteConfigKeyDefaultValue.items
        case .introduce:
            defaultValue = FTRemoteConfigKeyDefaultValue.introduce
        case .eegService:
            defaultValue = FTRemoteConfigKeyDefaultValue.eegService
        case .hrService:
            defaultValue = FTRemoteConfigKeyDefaultValue.hrService
        case .hrReport:
            defaultValue = FTRemoteConfigKeyDefaultValue.hrReport
        case .hrvReport:
            defaultValue = FTRemoteConfigKeyDefaultValue.hrvReport
        case .brainService:
            defaultValue = FTRemoteConfigKeyDefaultValue.brainService
        case .brainReport:
            defaultValue = FTRemoteConfigKeyDefaultValue.brainReport
        case .attentionService:
            defaultValue = FTRemoteConfigKeyDefaultValue.attentionService
        case .attentionReport:
            defaultValue = FTRemoteConfigKeyDefaultValue.attentionReport
        case .relaxationService:
            defaultValue = FTRemoteConfigKeyDefaultValue.relaxationService
        case .relaxationReport:
            defaultValue = FTRemoteConfigKeyDefaultValue.relaxationReport
        case .pressureService:
            defaultValue = FTRemoteConfigKeyDefaultValue.pressureService
        case .pressureReport:
            defaultValue = FTRemoteConfigKeyDefaultValue.pressureReport
        case .productPrice:
            defaultValue = FTRemoteConfigKeyDefaultValue.productPrice
        case .fillAddress:
            defaultValue = FTRemoteConfigKeyDefaultValue.fillAddress
        case .cannotConnect:
            defaultValue = FTRemoteConfigKeyDefaultValue.cannotConnect
        case .last7Times:
            defaultValue = FTRemoteConfigKeyDefaultValue.last7times
        case .appVersion:
            defaultValue = FTRemoteConfigKeyDefaultValue.appVersion
        case .firmwareVersion:
            defaultValue = FTRemoteConfigKeyDefaultValue.firmwareVersion
        case .firmwareUrl:
            defaultValue = FTRemoteConfigKeyDefaultValue.firmwareUrl
        }
        return MTAConfig.getInstance()?.getCustomProperty(key.rawValue, default: defaultValue)
    }
    
    ///判断是否要下载固件
    func shoudDownloadFirmware() -> Bool {
        guard Preference.currnetFirmwareVersion != 0 else { return false }
        let currentFirmware = Preference.currnetFirmwareVersion
        if let updateFirmwareString = getConfig(key: .firmwareVersion) {
            let updateFirmware = Int(updateFirmwareString.replacingOccurrences(of: ".", with: "")) ?? 100
            Preference.updateFirmwareVersion = updateFirmware
            if currentFirmware < updateFirmware {
                return true
            }
        }
        return false
    }
    
    func shouldUpdateApp() -> Bool {
        let currentVerString: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let currentVerNum = Int(currentVerString.replacingOccurrences(of: ".", with: "")) ?? 100
        if let serverVerStr = getConfig(key: .appVersion) {
            let serverVerNum = Int(serverVerStr.replacingOccurrences(of: ".", with: "")) ?? 100
            if serverVerNum > currentVerNum {
                return true
            }
        }
        return false
    }
}
