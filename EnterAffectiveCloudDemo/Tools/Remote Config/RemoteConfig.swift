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
    case hrvService        = "hrv_realtime_info"
    case brainService      = "brainwave_spectrum_realtime_info"
    case brainReport       = "brainwave_spectrum_report_info"
    case attentionService  = "attention_realtime_info"
    case attentionReport   = "attention_report_info"
    case relaxationService = "relaxation_realtime_info"
    case relaxationReport  = "relaxation_report_info"
    case pressureService   = "pressure_realtime_info"
    case pressureReport    = "pressure_report_info"
    case coherenceService  = "coherence_realtime_info"
    case coherenceReport   = ""
    case productPrice      = "product_price"
    case fillAddress       = "fill_address"
    case cannotConnect     = "cannot_connect"
    case last7Times        = "last_7_times"
    case appVersion        = "new_app_version"
    case firmwareVersion   = "new_firmware_version"
    case firmwareUrl       = "firmware_url"
}

public struct FTRemoteConfigKeyDefaultValue {
    static let help = "https://docs.myflowtime.cn/"
    static let cannotConnect = "https://www.notion.so/I-can-t-connect-the-headband-with-the-app-1ae10dc7fe1049c4953fc879f9042730"
    static let privacy = "https://www.entertech.cn/privacy"
    static let items = "https://www.entertech.cn/term-of-use"
    static let introduce = "https://www.meetinnerpeace.com/flowtime"
    static let eegService = "https://docs.myflowtime.cn/名词解释/脑电波（EEG）.html"
    static let hrService = "https://docs.myflowtime.cn/名词解释/心率.html"
    static let hrReport = "https://docs.myflowtime.cn/看懂图表/如何看心率变化曲线？.html"
    static let hrvReport = "https://docs.myflowtime.cn/看懂图表/如何看心率变异性（HRV）的变化曲线？.html"
    static let hrvService = "https://docs.myflowtime.cn/名词解释/心率变异性（HRV）.html"
    static let brainService = "https://docs.myflowtime.cn/名词解释/脑电波节律（Brainwave Rhythms）.html"
    static let brainReport = "https://docs.myflowtime.cn/看懂图表/如何看脑波频谱能量趋势图？.html"
    static let relaxationService = "https://docs.myflowtime.cn/名词解释/放松度.html"
    static let relaxationReport  = "https://docs.myflowtime.cn/看懂图表/如何看注意力和放松度曲线？.html"
    static let attentionService = "https://docs.myflowtime.cn/名词解释/注意力.html"
    static let attentionReport = "https://docs.myflowtime.cn/看懂图表/如何看注意力和放松度曲线？.html"
    static let pressureService = "https://docs.myflowtime.cn/名词解释/压力水平.html"
    static let pressureReport = "https://docs.myflowtime.cn/看懂图表/如何看压力水平曲线？.html"
    static let coherenceService = "https://docs.myflowtime.cn/名词解释/和谐度（Coherence）.html"
    static let coherenceReport = ""
    static let last7times = "https://docs.myflowtime.cn/%E7%9C%8B%E6%87%82%E5%9B%BE%E8%A1%A8/%E7%9C%8B%E6%87%82%E3%80%8C%E6%9C%80%E8%BF%91%207%20%E6%AC%A1%E3%80%8D%E5%9B%BE.html"
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
        case .hrvService:
            defaultValue = FTRemoteConfigKeyDefaultValue.hrvService
        case .coherenceService:
            defaultValue = FTRemoteConfigKeyDefaultValue.coherenceService
        case .coherenceReport:
            defaultValue = FTRemoteConfigKeyDefaultValue.coherenceReport
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
